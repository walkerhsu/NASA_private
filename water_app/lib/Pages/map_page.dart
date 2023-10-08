import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:water_app/Camera/camera.dart';
import 'package:water_app/Storage/cloud_storage.dart';
import 'package:water_app/Pages/markers.dart';
import 'package:water_app/processData/process_book.dart';
import 'package:water_app/processData/process_stations.dart';
import 'package:water_app/information/map_consts.dart';
import 'package:water_app/map_data.dart';
import 'package:water_app/processData/process_species.dart';
import 'package:water_app/map_location.dart';
import 'dart:async';

class CheckCurrentPosition extends StatelessWidget {
  final String country;
  final LatLng? refSearchLocation;
  const CheckCurrentPosition(
      {super.key, required this.country, this.refSearchLocation});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetCurrentLocation.handleCurrentPosition(context, country),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            LatLng currentPosition = snapshot.data as LatLng;
            return MapPageBuilder(
              currentPosition: currentPosition,
              country: country,
              refSearchLocation: refSearchLocation,
            );
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
  final String country;
  final LatLng? refSearchLocation;
  const MapPageBuilder(
      {super.key,
      required this.currentPosition,
      required this.country,
      this.refSearchLocation});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: country == "Canada"
            ? Future.wait([
                ProcessStations.processCsv(context, "Canada"),
                ProcessBook.processCsv(context),
              ])
            : Future.wait([
                ProcessSpecies.processCsv(context, country),
                ProcessStations.processCsv(context, country),
                ProcessBook.processCsv(context),
              ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            late List<Map<String, dynamic>> stations;
            if (country == "Canada") {
              stations = snapshot.data![0] as List<Map<String, dynamic>>;
            } else {
              stations = snapshot.data![1] as List<Map<String, dynamic>>;
            }
            return MapPage(
              currentPosition: currentPosition,
              refSearchLocation: refSearchLocation,
              stations: stations,
              country: country,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class MapPage extends StatefulWidget {
  final LatLng currentPosition;
  final List<Map<String, dynamic>> stations;
  final LatLng? refSearchLocation;
  final String country;
  const MapPage(
      {super.key,
      required this.currentPosition,
      required this.stations,
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
  late List<CameraDescription> _cameras;
  late String country;

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
    stations = widget.stations;
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
    return Stack(
      children: [
        FlutterMap(
            mapController: mapController,
            options: MapOptions(
              minZoom: 5,
              maxZoom: 18,
              zoom: 12,
              center: refLocation ?? currentLocation,
              onTap: (tapPosition, point) {
                _animatedMapMove(point, 12);
                setState(() {
                  refLocation = point;
                  argsort = ProcessStations.sortStations(refLocation!, country);
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
                    "https://api.mapbox.com/styles/v1/markymarklee/{mapStyleId}/tiles/256/{z}/{x}/{y}?access_token={accessToken}",
                additionalOptions: const {
                  'accessToken':
                      "pk.eyJ1IjoibWFya3ltYXJrbGVlIiwiYSI6ImNsbmV2MmJpczBnYmgydHBkZ2l5czRmMGwifQ.lHpfBNNYv6tWDfhiJWHhNA",
                  'mapStyleId': "clnfny2al01j001ps7ep1g539",
                },
              ),
              MarkerLayers(
                currentPosition: widget.currentPosition,
                refPosition: refLocation,
                stations: stations,
                argsort: argsort,
                showLocation: showLocation,
                follow: true,
                selectedindex: selectedIndex,
                country: country,
              ),
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
                        String image = await CloudStorage.getImageURL(
                            "image1.png", country);
                        if (!mounted) return;
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return CameraPage(
                                camera: _cameras[0],
                                country: country,
                                scientificName: "image1",
                                image: image);
                          }),
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
