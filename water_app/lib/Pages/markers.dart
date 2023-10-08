import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:water_app/Camera/camera.dart';
import 'package:water_app/ShowSpecies/generate_species.dart';
import 'package:water_app/Storage/cloud_storage.dart';
import 'package:water_app/map_location.dart';
import 'package:water_app/processData/process_book.dart';
import 'dart:async';
import 'package:water_app/processData/process_species.dart';
import 'package:latlong2/latlong.dart';
import 'package:water_app/Components/login_widget.dart';

class MarkerLayers extends StatefulWidget {
  const MarkerLayers({
    super.key,
    required this.currentPosition,
    required this.refPosition,
    required this.stations,
    required this.showLocation,
    required this.argsort,
    required this.follow,
    required this.selectedindex,
    required this.country,
  });
  final LatLng currentPosition;
  final LatLng? refPosition;
  final List<Map<String, dynamic>> stations;
  final Function showLocation;
  final List<int> argsort;
  final bool follow;
  final int selectedindex;
  final String country;

  @override
  State<MarkerLayers> createState() => _MarkerLayersState();
}

class _MarkerLayersState extends State<MarkerLayers> {
  late int selectedIndex;
  List<int> argsort = [];
  final int markerNum = 10;
  late Timer timerCurrentPosition;
  late Timer timerSpecies;
  late LatLng currentPosition;
  late String country;
  late List<Map<String, dynamic>> popUpSpecies;

  reload() {
    setState(() {});
  }

  List<Map<String, dynamic>> getCountrySpecies() {
    if (country == "Taiwan") {
      return ProcessSpecies.TaiwanSpecies;
    } else if (country == "Canada") {
      return ProcessSpecies.CanadaSpecies;
    } else if (country == "America") {
      return ProcessSpecies.AmericaSpecies;
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    country = widget.country;
    selectedIndex = widget.selectedindex;
    currentPosition = widget.currentPosition;
    timerCurrentPosition =
        Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (widget.follow) {
        if (mounted) {
          await GetCurrentLocation.handleCurrentPosition(
                  context, widget.country)
              .then((value) {
            currentPosition = value;
            reload();
          });
        }
      }
    });
    timerSpecies = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (widget.country != "Canada") {
        if (mounted) {}
      }
    });

    argsort = widget.argsort;
    selectedIndex = widget.selectedindex;
  }

  @override
  void dispose() {
    super.dispose();
    timerCurrentPosition.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: [
        for (int i = 0; i < markerNum; i++)
          Marker(
            width: 70,
            height: 100,
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

class SpeciesMarker extends StatefulWidget {
  const SpeciesMarker(
      {super.key,
      required this.country,
      required this.currentPosition,
      required this.refPosition});
  final String country;
  final LatLng? refPosition;
  final LatLng currentPosition;
  @override
  State<SpeciesMarker> createState() => _SpeciesMarkerState();
}

class _SpeciesMarkerState extends State<SpeciesMarker> {
  late Timer timerSpecies;
  late LatLng refPoint;
  late List<CameraDescription> _cameras;

  List<Map<String, dynamic>> getCountrySpecies() {
    if (widget.country == "Taiwan") {
      return ProcessSpecies.TaiwanSpecies;
    } else if (widget.country == "Canada") {
      return ProcessSpecies.CanadaSpecies;
    } else if (widget.country == "America") {
      return ProcessSpecies.AmericaSpecies;
    }
    return [];
  }

  late List<Map<String, dynamic>> popUpSpecies;
  @override
  void initState() {
    super.initState();
    refPoint = widget.refPosition ?? widget.currentPosition;
    popUpSpecies = GenerateSpecies.getSpecies(
        widget.refPosition ?? widget.currentPosition, getCountrySpecies());
    print(popUpSpecies);
    timerSpecies = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (mounted) {
        setState(() {
          popUpSpecies = GenerateSpecies.getSpecies(
              widget.refPosition ?? widget.currentPosition,
              getCountrySpecies());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: [
        for (int i = 0; i < popUpSpecies.length; i++)
          Marker(
              width: 70,
              height: 70,
              point: LatLng(
                  refPoint.latitude + (popUpSpecies[i]["delta_lat"] as double),
                  refPoint.longitude +
                      (popUpSpecies[i]["delta_long"] as double)),
              builder: (context) {
                String sn = popUpSpecies[i]["scientific_name"];
                // print(ProcessBook.book[sn]!["no_bg_image"]);
                return FutureBuilder(
                    future: CloudStorage.getNoBGImageURL(
                        ProcessBook.book[sn]!["no_bg_image"]),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return GestureDetector(
                          onTap: () async {
                            _cameras = await availableCameras();
                            if (!mounted) return;
                            if (_cameras.isEmpty) {
                              showAlert(
                                context: context,
                                title: "No camera found",
                                desc: "Please check your camera settings.",
                                onPressed: () => Navigator.pop(context),
                              ).show();
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return CameraPage(
                                      camera: _cameras[0],
                                      country: widget.country,
                                      scientificName: popUpSpecies[i]
                                          ["scientific_name"],
                                      image: snapshot.data as String);
                                }),
                              );
                            }
                          },
                          child: Image.network(snapshot.data as String),
                        );
                        // Gesture detector to camera
                      } else {
                        return const SizedBox();
                      }
                    });
              })
      ],
    );
  }
}
