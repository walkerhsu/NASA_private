import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:water_app/Components/info_widget.dart';
import 'package:water_app/Components/tags_widget.dart';
import 'package:water_app/Components/tags_widget_button.dart';
import 'package:water_app/Constants/all_info.dart';
import 'package:water_app/processData/calculate_distance.dart';

class SpotDetails extends StatelessWidget {
  final int index;
  final Map<String, dynamic> station;
  final String country;
  final LatLng currentPosition;

  const SpotDetails(
      {super.key,
      required this.station,
      required this.country,
      required this.currentPosition,
      this.index = 1});

  @override
  Widget build(BuildContext context) {
    print("INFO");
    print(AllInfo.allStations[country][index]);

    return Scaffold(
        body: Stack(
          children: [
            Positioned(
                left: 0,
                right: 0,
                child: Hero(
                  tag: "home_to_info",
                  child: Container(
                      width: double.maxFinite,
                      height: 350,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/observatory.png'),
                          fit: BoxFit.cover,
                        ),
                      )),
                )),
            Positioned(
              top: 45,
              left: 20,
              right: 20,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // SpecialIcon(
                    //   icon: Icons.arrow_back_ios_rounded,
                    //   backgroundColor: Colors.black.withOpacity(0.5),
                    //   iconColor: Colors.white,
                    //   size: 40,
                    // ),
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ]),
            ),
            Positioned(
                left: 0,
                right: 0,
                top: 300,
                bottom: 0,
                child: Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InfoWidget(
                      name: station['station'],
                      rpi: station['RPI'].toString(),
                      pH: station['pH'].toString(),
                      temperature: station['temperature'].toString(),
                      NH3_N: station['NH3-N'].toString(),
                      NH3_N_unit: station['NH3-N_unit'],
                      type: "water",
                      waterName: (country == "Taiwan")
                          ? station['river']
                          : station["waterbody"],
                      distance: CalculateDistance.calculateDistance(
                              station['location'], currentPosition)
                          .toString(),
                      country: country,
                    ))),
          ],
        ),
        // (!AllInfo.allStations[country][index]["species1"] || !AllInfo.allStations[country][index]["species2"] || !AllInfo.allStations[country][index]["species3"])?
        bottomNavigationBar: (AllInfo.allStations[country][index]["species1"] !=
                    null ||
                AllInfo.allStations[country][index]["species2"] != null ||
                AllInfo.allStations[country][index]["species3"] != null)
            ? Container(
                height: 100,
                padding: const EdgeInsets.only(
                    top: 30, bottom: 30, right: 10, left: 10),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 173, 216, 230),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ListView(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      (AllInfo.allStations[country][index]["species1"] != "")
                          ? TagsWidgetButton(
                              tagName: AllInfo.allStations[country][index]
                                  ["species1"],
                              icon: Icons.tag_rounded,
                              iconColor: TagsWidget.brownColor,
                              station: station,
                              country: country,
                              currentPosition: currentPosition,
                            )
                          : const SizedBox(width: 0),
                      (AllInfo.allStations[country][index]["species1"] != "")
                          ? const SizedBox(width: 5)
                          : const SizedBox(width: 0),
                      (AllInfo.allStations[country][index]["species2"] != "")
                          ? TagsWidgetButton(
                              tagName: AllInfo.allStations[country][index]
                                  ["species2"],
                              icon: Icons.tag_rounded,
                              iconColor: TagsWidget.brownColor,
                              station: station,
                              country: country,
                              currentPosition: currentPosition,
                            )
                          : const SizedBox(width: 0),
                      (AllInfo.allStations[country][index]["species2"] != "")
                          ? const SizedBox(width: 5)
                          : const SizedBox(width: 0),
                      (AllInfo.allStations[country][index]["species3"] != "")
                          ? TagsWidgetButton(
                              tagName: AllInfo.allStations[country][index]
                                  ["species3"],
                              icon: Icons.tag_rounded,
                              iconColor: TagsWidget.brownColor,
                              station: station,
                              country: country,
                              currentPosition: currentPosition,
                            )
                          : const SizedBox(width: 0),
                      (AllInfo.allStations[country][index]["species3"] != "")
                          ? const SizedBox(width: 5)
                          : const SizedBox(width: 0),
                    ],
                  )
                ]),
              )
            : const SizedBox(
                height: 0,
                width: 0,
              ));
  }
}
