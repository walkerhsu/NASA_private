import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:water_app/processData/process_stations.dart';

import 'package:water_app/testData/map_consts.dart';
import 'package:water_app/map_data.dart';
// import 'package:water_app/testData/map_current_arrow.dart';
import 'package:water_app/processData/process_current.dart';
import 'package:water_app/processData/process_species.dart';
import 'package:water_app/map_location.dart';

class MapPageBuilder extends StatelessWidget {
  final LatLng currentPosition;
  const MapPageBuilder({super.key, required this.currentPosition});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          ProcessCurrent.processCsv(context),
          ProcessSpecies.processCsv(context),
          ProcessStations.processCsv(context)
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            List<List<LatLng>> current =
                snapshot.data![0] as List<List<LatLng>>;
            List<Map<String, dynamic>> species =
                snapshot.data![1] as List<Map<String, dynamic>>;
            List<Map<String, dynamic>> stations =
                snapshot.data![2] as List<Map<String, dynamic>>;
            // print(ProcessCurrent.current[0].keys.first);
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

class MapPage extends StatefulWidget {
  final List<List<LatLng>> current;
  final List<Map<String, dynamic>> species;
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
  int selectedIndex = 0;
  bool drawMapData = true;
  final MapController mapController = MapController();

  late LatLng currentLocation;
  late final List<List<LatLng>> current;
  late final List<Map<String, dynamic>> species;
  late final List<Map<String, dynamic>> stations;

  showLocation(idx) {
    setState(() {
      selectedIndex = idx;
      currentLocation = stations[idx]['location'] ?? MapConstants.myLocation;
      drawMapData = true;
    });
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => animateMap(selectedIndex),
    );
  }

  animateMap(idx) {
    pageController.animateToPage(
      selectedIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    _animatedMapMove(
      stations[idx]['location'] ?? MapConstants.myLocation,
      11,
    );
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: selectedIndex,
    );
    current = widget.current;
    currentLocation = widget.currentPosition;
    species = widget.species;
    stations = widget.stations;
  }

  @override
  void dispose() {
    pageController.dispose();
    mapController.dispose();
    super.dispose();
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
              zoom: 10,
              center: currentLocation,
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
              MarkerLayer(
                markers: [
                  for (int i = 0; i < stations.length; i++)
                    Marker(
                      width: 40,
                      height: 40,
                      point: stations[i]["location"],
                      builder: (context) => GestureDetector(
                        onTap: () {
                          showLocation(i);
                        },
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 500),
                          scale: selectedIndex == i ? 1 : 0.7,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: selectedIndex == i ? 1 : 0.5,
                            child: SvgPicture.asset(
                              'assets/icons/map_marker.svg',
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
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
                        stations[value]['location'] ?? MapConstants.myLocation,
                        14);
                    setState(() {
                      selectedIndex = value;
                      currentLocation = stations[value]['location'] ??
                          MapConstants.myLocation;
                      drawMapData = true;
                    });
                  },
                  itemCount: stations.length,
                  itemBuilder: (_, index) {
                    return MapData(
                      station: stations[index],
                    );
                  },
                )
              : const SizedBox.shrink(),
        )
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
