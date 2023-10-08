import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:water_app/Components/info_widget.dart';
import 'package:water_app/Constants/all_info.dart';
import 'package:water_app/globals.dart';
import 'package:water_app/processData/calculate_distance.dart';
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
      print(speciesName);
      print(AllInfo.allSpecies[country][i]["scientific_name"]);
      if (AllInfo.allSpecies[country][i]["scientific_name"] == speciesName) {
        index = i;
        return index;
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    print("index");
    print(nameToIdx());
    print(currentPosition);
    // print(AllInfo.allSpecies[country][6]);
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
                  image: NetworkImage(
                      AllInfo.allSpecies[country][nameToIdx()]["image"]),
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
            top: 330,
            bottom: 0,
            child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InfoWidget(
                    name: AllInfo.allSpecies[country][nameToIdx()]
                        ["common_name"],
                    scientificName: AllInfo.allSpecies[country][nameToIdx()]
                        ["scientific_name"],
                    waterName: station["waterbody"],
                    type: "species",
                    distance: CalculateDistance.calculateDistance(
                            currentPosition,
                            station['location'])
                        .toString(),
                    collected: currentUser.seenSpecies
                        .contains(AllInfo.allSpecies[country][nameToIdx()]
                            ["scientific_name"])
                        .toString(),
                    country: country,
                )))
      ],
    ));
  }
}
