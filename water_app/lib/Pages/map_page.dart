import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:water_app/Camera/camera.dart';
import 'package:water_app/processData/process_stations.dart';

import 'package:water_app/testData/map_consts.dart';
import 'package:water_app/map_data.dart';
// import 'package:water_app/testData/map_current_arrow.dart';
import 'package:water_app/processData/process_current.dart';
import 'package:water_app/processData/process_species.dart';
import 'package:water_app/map_location.dart';
import 'dart:async';

class CheckCurrentPosition extends StatelessWidget {
  const CheckCurrentPosition({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetCurrentLocation.handleCurrentPosition(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            LatLng currentPosition = snapshot.data as LatLng;
            return MapPageBuilder(currentPosition: currentPosition);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class MapPageBuilder extends StatelessWidget {
  final LatLng currentPosition;
  const MapPageBuilder({super.key, required this.currentPosition});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          ProcessCurrent.processCsv(context),
          ProcessSpecies.processCsv(context),
          ProcessStations.processCsv(context),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            List<List<LatLng>> current =
                snapshot.data![0] as List<List<LatLng>>;
            List<List<Map<String, dynamic>>> species =
                snapshot.data![1] as List<List<Map<String, dynamic>>>;
            List<Map<String, dynamic>> stations =
                snapshot.data![2] as List<Map<String, dynamic>>;
            return MapPage(
                currentPosition: currentPosition,
                current: current,
                species: species,
                stations: stations);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class MapPage extends StatefulWidget {
  final List<List<LatLng>> current;
  final List<List<Map<String, dynamic>>> species;
  final LatLng currentPosition;
  final List<Map<String, dynamic>> stations;
  const MapPage(
      {super.key,
      required this.current,
      required this.currentPosition,
      required this.species,
      required this.stations});
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

  late List<int> argsort = [];

  late LatLng currentLocation;
  late LatLng? refLocation;

  late final List<List<LatLng>> current;
  late final List<List<Map<String, dynamic>>> species;
  late List<Map<String, dynamic>> stations;

  late List<CameraDescription> _cameras;

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
    current = widget.current;
    currentLocation = widget.currentPosition;
    refLocation = null;
    species = widget.species;
    stations = widget.stations;
    argsort = ProcessStations.sortStations(currentLocation);
    selectedIndex = argsort[0];
    pageController = PageController(
      initialPage: 0,
    );
  }

  Future<LatLng> refreshLocation() async {
    return await GetCurrentLocation.handleCurrentPosition(context);
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
    return Stack(
      children: [
        FlutterMap(
            mapController: mapController,
            options: MapOptions(
              minZoom: 5,
              maxZoom: 18,
              zoom: 12,
              center: currentLocation,
              onTap: (tapPosition, point) {
                _animatedMapMove(point, 12);
                setState(() {
                  refLocation = point;
                  argsort = ProcessStations.sortStations(refLocation!);
                  selectedIndex = argsort[0];
                  drawMapData = true;
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
                    "https://api.mapbox.com/styles/v1/walkerhsu/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
                additionalOptions: const {
                  'accessToken': MapConstants.mapBoxAccessToken,
                  'mapStyleId': MapConstants.mapBoxStyleId,
                },
              ),
              // PolylineLayer(
              //   polylines: current
              //       .map((e) => Polyline(
              //             points: e,
              //             color: Colors.red,
              //             strokeWidth: 5,
              //           ))
              //       .toList(),
              // ),
              MarkerLayers(
                currentPosition: widget.currentPosition,
                refPosition: refLocation,
                stations: stations,
                argsort: argsort,
                showLocation: showLocation,
                follow: true,
                selectedindex: selectedIndex,
              )
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
                    );
                  },
                )
              : const SizedBox.shrink(),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
            width: double.infinity,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                      icon: Icon(
                        Icons.photo_camera,
                        color: Colors.white.withOpacity(.5),
                      ),
                      onPressed: () async {
                        _cameras = await availableCameras();
                        if (!mounted) return;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                CameraPage(camera: _cameras[0]),
                          ),
                        );
                      }))
            ]),
          ),
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
                      await GetCurrentLocation.handleCurrentPosition(context)
                          .then((value) {
                        _animatedMapMove(value, 12);
                        setState(() {
                          currentLocation = value;
                          refLocation = null;
                          argsort = ProcessStations.sortStations(value);
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

class MarkerLayers extends StatefulWidget {
  const MarkerLayers(
      {super.key,
      required this.currentPosition,
      required this.refPosition,
      required this.stations,
      required this.showLocation,
      required this.argsort,
      required this.follow,
      required this.selectedindex});
  final LatLng currentPosition;
  final LatLng? refPosition;
  final List<Map<String, dynamic>> stations;
  final Function showLocation;
  final List<int> argsort;
  final bool follow;
  final int selectedindex;

  @override
  State<MarkerLayers> createState() => _MarkerLayersState();
}

class _MarkerLayersState extends State<MarkerLayers> {
  late int selectedIndex;
  List<int> argsort = [];
  final int markerNum = 10;
  late Timer timer;
  late LatLng currentPosition;

  reload() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedindex;
    currentPosition = widget.currentPosition;
    timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (widget.follow) {
        if (mounted) {
          await GetCurrentLocation.handleCurrentPosition(context).then((value) {
            currentPosition = value;
            reload();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    argsort = widget.argsort;
    selectedIndex = widget.selectedindex;
    return MarkerLayer(
      markers: [
        for (int i = 0; i < markerNum; i++)
          Marker(
            width: 50,
            height: 80,
            point: widget.stations[argsort[i]]["location"],
            builder: (context) => GestureDetector(
              onTap: () {
                widget.showLocation(i);
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
                      widget.stations[argsort[i]]["station"],
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
          point: currentPosition,
          builder: (context) => Image.asset(
            'assets/icons/current_position.png',
          ),
        )
      ],
    );
  }
}
