import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:water_app/Pages/species_details.dart';
import 'package:water_app/Components/big_text.dart';
import 'package:water_app/Components/small_text.dart';
import 'package:water_app/Components/tags_widget.dart';
import 'package:water_app/Components/tags_widget_button.dart';
import 'package:water_app/globals.dart';
import 'package:water_app/processData/process_book.dart';
import 'package:water_app/processData/process_species.dart';
import 'package:water_app/Constants/all_info.dart';

class MenuBook extends StatelessWidget {
  const MenuBook({Key? key, required this.country, required this.currentPosition}) : super(key: key);
  static String id = 'menu_book';
  final String country;
  final LatLng currentPosition;

  final int unknownSpecies = 10;
  final int crossAxisCount = 2;
  @override
  Widget build(BuildContext context) {
    List<String> references = [
      "taiwan_species",
      "canada_species",
      // "american_species"
    ];
    List<String> countries = ["Taiwan", "Canada", "America"];
    // if (AllInfo.allSpecies.isNotEmpty) {
    print("book");
    print(ProcessBook.book["Hynobius formosanus"]);
    // print(currentUser.seenSpecies);
    List<dynamic> seenSpecies = currentUser.seenSpecies;
    // print(AllInfo.allSpecies[countries[1]]);
    List<dynamic> filterseenSpecies = ProcessBook.book.entries
        .where((element) => seenSpecies.contains(element.key))
        .toList();

    print(filterseenSpecies);
    // print("in");

    return Scaffold(
        body: Column(children: [
      Container(
        width: double.maxFinite,
        height: 50,
        child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BigText(text: "collection pregress", size: 15),
              // SizedBox(width: 10),
              BigText(text: "text", size: 15),
              // SizedBox(width: 10),
              BigText(text: "text", size: 15),
            ]),
      ),
      Expanded(
        // child: SingleChildScrollView(
        child: GridView.count(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            children: [
              for (int i = 0; i < references.length - 1; i++)
                for (int j = 0;
                    j < filterseenSpecies.length + unknownSpecies;
                    j++)
                  GestureDetector(
                    onTap: () {
                      print("currentPosition");
                      print(currentPosition);
                      String tempcountry = filterseenSpecies[j].value["country"];
                      // print("tempcountry");
                      // print(tempcountry);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => SpeciesDetails(
                                // station:AllInfo.allStations[countries[i]][j],
                                speciesName: filterseenSpecies[j].key,
                                country: tempcountry,
                                currentPosition: currentPosition,
                            )),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.white,
                      child: Stack(children: [
                        Container(
                          margin: const EdgeInsets.only(
                              right: 5, left: 5, top: 10, bottom: 0),
                          // width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: (j < filterseenSpecies.length)
                                    ? NetworkImage(
                                            filterseenSpecies[j].value["image"])
                                        as ImageProvider<Object>
                                    : AssetImage("assets/images/unknown.jpg")
                                        as ImageProvider<Object>,
                                // image: NetworkImage(imageURLs[j]),
                                fit: BoxFit.cover,
                                opacity: 0.9),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white.withOpacity(0.8),
                              ),
                              child: Column(
                                children: [
                                  (j < filterseenSpecies.length)
                                      ? SmallText(
                                          text: filterseenSpecies[j].key)
                                      : SmallText(text: "unknown"),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: (j < filterseenSpecies.length)
                                        ? [
                                            TagsWidget(
                                              tagName: filterseenSpecies[j]
                                                  .value["country"],
                                              textsize: 8,
                                              iconColor:
                                                  TagsWidgetButton.blueColor,
                                              iconBackgroundColor:
                                                  TagsWidgetButton.almondColor,
                                              iconRatio: 0.6,
                                              width: 55,
                                            ),
                                            const SizedBox(width: 5),
                                            TagsWidget(
                                              tagName: filterseenSpecies[j]
                                                  .value["rank"],
                                              textsize: 8,
                                              iconColor:
                                                  TagsWidgetButton.blueColor,
                                              iconBackgroundColor:
                                                  TagsWidgetButton.almondColor,
                                              iconRatio: 0.6,
                                              width: 55,
                                            ),
                                            const SizedBox(width: 5),
                                            TagsWidget(
                                              tagName: currentUser.seenSpecies
                                                      .contains(
                                                          filterseenSpecies[j]
                                                              .key)
                                                  ? "collected"
                                                  : "?",
                                              textsize: 8,
                                              iconColor:
                                                  TagsWidgetButton.blueColor,
                                              iconBackgroundColor:
                                                  TagsWidgetButton.almondColor,
                                              iconRatio: 0.6,
                                              width: 60,
                                            ),
                                          ]
                                        : [
                                            TagsWidget(
                                              tagName: "?",
                                              textsize: 8,
                                              iconColor:
                                                  TagsWidgetButton.brownColor,
                                              iconBackgroundColor: Colors.white,
                                              iconRatio: 0.6,
                                              width: 55,
                                            ),
                                            const SizedBox(width: 5),
                                            TagsWidget(
                                              tagName: "?",
                                              textsize: 8,
                                              iconColor:
                                                  TagsWidgetButton.brownColor,
                                              iconBackgroundColor: Colors.white,
                                              iconRatio: 0.6,
                                              width: 55,
                                            ),
                                            const SizedBox(width: 5),
                                            TagsWidget(
                                              tagName: "?",
                                              textsize: 8,
                                              iconColor:
                                                  TagsWidgetButton.brownColor,
                                              iconBackgroundColor: Colors.white,
                                              iconRatio: 0.6,
                                              width: 55,
                                            ),
                                          ],
                                  ),
                                ],
                              )),
                        )
                      ]),
                    ),
                  )
            ]),
      ),
    ]));
    // }
    // else {
    //   return const Center(child: CircularProgressIndicator());
    // }
    // }
    //   ],
    // );
  }
}
