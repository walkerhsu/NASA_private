import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';

import 'package:water_app/testData/map_consts.dart';
import 'package:water_app/testData/map_markers.dart';
import 'package:water_app/map_data.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  // ignore: constant_identifier_names
  static const String ACCESS_TOKEN = String.fromEnvironment("ACCESS_TOKEN");
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final PageController pageController;
  int selectedIndex = 0;
  LatLng currentLocation = MapConstants.myLocation;
  bool drawMapData = true;
  final MapController mapController = MapController();
  late final String title;
  final zoomlevel = 13.0;

  showLocation(idx) {
    setState(() {
      selectedIndex = idx;
      currentLocation = mapMarkers[idx].location ?? MapConstants.myLocation;
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
      mapMarkers[idx].location ?? MapConstants.myLocation,
      zoomlevel,
    );
  }

  @override
  void initState() {
    super.initState();
    title = widget.title;
    pageController = PageController(
      initialPage: selectedIndex,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              minZoom: 5,
              maxZoom: 18,
              zoom: zoomlevel,
              center: currentLocation,
              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  setState(() {
                    drawMapData = false;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/walkerhsu/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
                additionalOptions: const {
                  'accessToken': MapConstants.mapBoxAccessToken,
                  'mapStyleId': MapConstants.mapBoxStyleId,
                },
              ),
              MarkerLayer(
                markers: [
                  for (int i = 0; i < mapMarkers.length; i++)
                    Marker(
                      height: 40,
                      width: 40,
                      point: mapMarkers[i].location ?? MapConstants.myLocation,
                      builder: (context) {
                        return GestureDetector(
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
                        );
                      },
                    ),
                ],
              ),
            ],
          ),
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
                          mapMarkers[value].location ?? MapConstants.myLocation,
                          zoomlevel);
                      setState(() {
                        selectedIndex = value;
                        currentLocation = mapMarkers[value].location ??
                            MapConstants.myLocation;
                        drawMapData = true;
                      });
                    },
                    itemCount: mapMarkers.length,
                    itemBuilder: (_, index) {
                      final MapMarker item = mapMarkers[index];
                      return MapData(
                        item: item,
                      );
                    },
                  )
                : const SizedBox.shrink(),
          )
        ],
      ),
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
