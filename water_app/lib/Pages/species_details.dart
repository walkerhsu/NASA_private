import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:water_app/Components/info_widgets.dart';
import 'package:water_app/Constants/all_info.dart';
import 'package:water_app/Constants/screen_info.dart';
import 'package:water_app/globals.dart';
import 'package:water_app/processData/calculate_distance.dart';
import 'package:water_app/processData/process_book.dart';
// import 'package:water_app/processData/process_species.dart';

class SpeciesDetails extends StatelessWidget {
  final String speciesName;
  final Map<String, dynamic> station;
  final String country;
  final LatLng currentPosition;

  const SpeciesDetails({
    super.key,
    this.station = const {"waterbody": "Pacific Ocean"},
    required this.country,
    this.speciesName = "Canada Goose",
    required this.currentPosition,
  });

  int nameToIdx() {
    int index = 0;
    for (int i = 0; i < AllInfo.allSpecies[country].length; i++) {
      if (AllInfo.allSpecies[country][i]["scientific_name"] == speciesName) {
        index = i;
        return index;
      }
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    Map species = AllInfo.allSpecies[country][nameToIdx()];
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: 350,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(species["image"]),
                  fit: BoxFit.cover,
                ),
              ),
            )),
        Positioned(
          top: 45,
          left: 20,
          right: 20,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
            top: Constants.screenHeight * 0.35,
            bottom: 0,
            child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InfoWidget(
                  name: ProcessBook.getCommonName(species["scientific_name"]),
                  scientificName: species["scientific_name"],
                  waterName: station["waterbody"],
                  type: "species",
                  distance: CalculateDistance.calculateDistance(
                          currentPosition, station['location']),
                  collected: currentUser.seenSpecies
                      .contains(species["scientific_name"])
                      .toString(),
                  country: country,
                  location: station["location"],
                )))
      ],
    ));
  }
}
