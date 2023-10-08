import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:water_app/Pages/markers.dart';
import 'package:water_app/processData/process_stations.dart';
import 'package:water_app/Constants/map_consts.dart';
import 'package:water_app/map_data.dart';
import 'package:water_app/map_location.dart';
import 'dart:async';

class MapPage extends StatefulWidget {
  final LatLng currentPosition;
  final LatLng? refSearchLocation;
  final String country;
  const MapPage(
      {super.key,
      required this.currentPosition,
      this.refSearchLocation,
      required this.country});
  // ignore: constant_identifier_names
  static const String ACCESS_TOKEN = String.fromEnvironment("ACCESS_TOKEN");
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  late final PageController pageController;
  final MapController mapController = MapController();
  bool drawMapData = true;
  late int selectedIndex;
  late LatLng? refLocation;
  late List<int> argsort = [];
  late LatLng currentLocation;
  late List<Map<String, dynamic>> stations;
  late String country;
  late Timer timerCurrentPosition;

  final int markerNum = 10;

  showLocation(idx) {
    if (drawMapData) {
      pageController.animateToPage(
        idx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      setState(() {
        drawMapData = true;
      });
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => pageController.animateToPage(
          idx,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        ),
      );
    }
  }

  animateMap(idx) {
    _animatedMapMove(
      stations[idx]['location'] ?? MapConstants.myLocation,
      12,
    );
  }

  @override
  void initState() {
    super.initState();
    country = widget.country;
    currentLocation = widget.currentPosition;
    refLocation = widget.refSearchLocation;
    argsort = ProcessStations.sortStations(currentLocation, country);
    selectedIndex = argsort[0];
    pageController = PageController(
      initialPage: 0,
    );
    stations = ProcessStations.getStationData(widget.country);
    timerCurrentPosition =
        Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (!mounted) return;
      return await GetCurrentLocation.handleCurrentPosition(
              context, widget.country)
          .then((value) {
        setState(() {
          currentLocation = value;
        });
      });
    });
  }

  Future<LatLng> refreshLocation() async {
    return await GetCurrentLocation.handleCurrentPosition(context, country);
  }

  @override
  void dispose() {
    pageController.dispose();
    mapController.dispose();
    super.dispose();
  }

  reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(refLocation);
    return Stack(
      children: [
        FlutterMap(
            mapController: mapController,
            options: MapOptions(
              minZoom: 4,
              maxZoom: 19,
              zoom: 12,
              center: refLocation ?? currentLocation,
              interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              onTap: (_, point) {
                List<int> newArgSort =
                    ProcessStations.sortStations(point, country);
                setState(() {
                  refLocation = point;
                  argsort = newArgSort;
                  selectedIndex = argsort[0];
                  drawMapData = true;
                });
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  _animatedMapMove(point, 12);
                });
              },
              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  setState(() {
                    drawMapData = false;
                  });
                }
              },
            ),
            nonRotatedChildren: [
              TileLayer(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/markymarklee/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
                additionalOptions: const {
                  'accessToken':
                      "pk.eyJ1IjoibWFya3ltYXJrbGVlIiwiYSI6ImNsbmV2MmJpczBnYmgydHBkZ2l5czRmMGwifQ.lHpfBNNYv6tWDfhiJWHhNA",
                  'mapStyleId': "clnh585ju01j501pu1hvggjk5",
                },
              ),
              Stack(children: [
                MarkerLayer(
                  markers: [
                    for (int i = 0; i < markerNum; i++)
                      Marker(
                        width: 80,
                        height: 120,
                        point: stations[argsort[i]]["location"],
                        builder: (context) => GestureDetector(
                          onTap: () {
                            showLocation(i);
                            setState(() {
                              selectedIndex = argsort[i];
                            });
                          },
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 500),
                            scale: argsort[i] == selectedIndex ? 1 : 0.7,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: argsort[i] == selectedIndex ? 1 : 0.5,
                              child: Column(children: [
                                Text(
                                  stations[argsort[i]]["station"],
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                SvgPicture.asset(
                                  'assets/icons/map_marker.svg',
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ),
                    Marker(
                      width: 30,
                      height: 30,
                      point: currentLocation,
                      builder: (context) => Image.asset(
                        'assets/icons/current_position.png',
                      ),
                    ),
                  ],
                ),
              ]),
              SpeciesMarker(
                  country: country,
                  currentPosition: widget.currentPosition,
                  refPosition: refLocation)
            ]),
        Positioned(
          left: 0,
          right: 0,
          bottom: 2,
          height: MediaQuery.of(context).size.height * 0.3,
          child: drawMapData
              ? PageView.builder(
                  controller: pageController,
                  onPageChanged: (value) {
                    _animatedMapMove(
                        stations[argsort[value]]['location'] ??
                            MapConstants.myLocation,
                        12);
                    setState(() {
                      selectedIndex = argsort[value];
                      drawMapData = true;
                    });
                  },
                  itemCount: markerNum,
                  itemBuilder: (_, index) {
                    return MapData(
                      station: stations[argsort[index]],
                      country: country,
                      currentPosition: widget.currentPosition,
                    );
                  },
                )
              : const SizedBox.shrink(),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.room,
                      color: Colors.white.withOpacity(1),
                    ),
                    onPressed: () async {
                      await GetCurrentLocation.handleCurrentPosition(
                              context, country)
                          .then((value) {
                        _animatedMapMove(value, 12);
                        setState(() {
                          currentLocation = value;
                          refLocation = null;
                          argsort =
                              ProcessStations.sortStations(value, country);
                          selectedIndex = argsort[0];
                          drawMapData = true;
                        });
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);
    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });
    controller.forward();
  }
}
