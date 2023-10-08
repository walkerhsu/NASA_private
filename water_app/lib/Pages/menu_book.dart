import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:water_app/Components/login_widget.dart';
import 'package:water_app/Pages/species_details.dart';
import 'package:water_app/Components/big_text.dart';
import 'package:water_app/Components/small_text.dart';
import 'package:water_app/Components/tags_widget.dart';
import 'package:water_app/Components/tags_widget_button.dart';
import 'package:water_app/globals.dart';
import 'package:water_app/processData/process_book.dart';
import 'package:water_app/processData/process_stations.dart';

class MenuBook extends StatefulWidget {
  const MenuBook(
      {Key? key, required this.country, required this.currentPosition})
      : super(key: key);
  static String id = 'menu_book';
  final String country;
  final LatLng currentPosition;

  @override
  State<MenuBook> createState() => _MenuBookState();
}

class _MenuBookState extends State<MenuBook> {
  final int unknownSpecies = 10;

  final int crossAxisCount = 2;
  List<dynamic> filters = [];

  @override
  Widget build(BuildContext context) {
    List<String> references = [
      "taiwan_species",
      "canada_species",
      "american_species"
    ];
    List<String> catagory = ["Collected"];
    // if (AllInfo.allSpecies.isNotEmpty) {
    // print("book");
    // print(ProcessBook.book["Hynobius formosanus"]);
    // print(currentUser.seenSpecies);
    List<dynamic> seenSpecies = currentUser.seenSpecies;
    // print(AllInfo.allSpecies[countries[1]]);
    List<dynamic> filterseenSpecies1 = ProcessBook.book.entries
        .where((element) => seenSpecies.contains(element.key))
        .toList();
    LatLng currentPosition = widget.currentPosition;
    String country = widget.country;

    ProcessStations.sortStations(currentPosition, country);
    // List<dynamic>
    print("filters");
    print(filters);

    List<dynamic> finalProduct = ProcessBook.book.entries.toList();
    print(finalProduct[1].value["collected"]);
    for (int i = 0; i < catagory.length; i++) {
      if (filters.contains("Collected")) {
        finalProduct = finalProduct
            .where((element) => seenSpecies.contains(element.key))
            .toList();
      }
    }

    return Scaffold(
        body: Column(children: [
      SizedBox(
        width: double.maxFinite,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              // BigText(text: "collection progress", size: 15),
              // const SizedBox(width: 10,),
              catagory.map((e) {
            return FilterChip(
              label: SmallText(text: e),
              selected: filters.contains(e),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    filters.add(e);
                  } else {
                    filters.remove(e);
                  }
                  // print(filters);
                });
              },
            );
          }).toList(),
        ),
      ),
      Expanded(
        // child: SingleChildScrollView(
        child: GridView.count(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            children: [
              // for (int i = 0; i < references.length - 1; i++)
              for (int j = 0; j < finalProduct.length; j++)
                GestureDetector(
                  onTap: () {
                    if (!currentUser.seenSpecies
                        .contains(finalProduct[j].key)) {
                      showAlert(
                        context: context,
                        title: "You haven't collected this species!!",
                        desc:
                            "Please collect other species , and you can see the detail information~",
                        onPressed: () => Navigator.pop(context),
                      ).show();
                    } else {
                      print(finalProduct[j].value["collected"]);
                      String tempcountry = finalProduct[j].value["country"];
                      // print("tempcountry");
                      // print(tempcountry);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => SpeciesDetails(
                                  speciesName: finalProduct[j].key,
                                  country: tempcountry,
                                  currentPosition: currentPosition,
                                  station: ProcessStations.currentStation,
                                )),
                      );
                    }
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
                              image: (currentUser.seenSpecies
                                      .contains(finalProduct[j].key))
                                  ? NetworkImage(finalProduct[j].value["image"])
                                      as ImageProvider<Object>
                                  : const AssetImage(
                                      "assets/images/unknown.jpg"),
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
                                (j < finalProduct.length)
                                    ? SmallText(text: finalProduct[j].key)
                                    : const SmallText(text: "unknown"),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: (j < finalProduct.length)
                                      ? [
                                          TagsWidget(
                                            tagName: finalProduct[j]
                                                .value["country"],
                                            textsize: 8,
                                            iconColor:
                                                TagsWidgetButton.brownColor,
                                            iconBackgroundColor:
                                                Color.fromARGB(255, 232, 212, 225),
                                            iconRatio: 0.6,
                                            width: 55,
                                          ),
                                          const SizedBox(width: 5),
                                          TagsWidget(
                                            tagName:
                                                finalProduct[j].value["rank"],
                                            textsize: 8,
                                            iconColor:
                                                TagsWidgetButton.brownColor,
                                            iconBackgroundColor:
                                                const Color.fromARGB(
                                                    255, 221, 221, 255),
                                            iconRatio: 0.6,
                                            width: 55,
                                          ),
                                          const SizedBox(width: 5),
                                          TagsWidget(
                                            tagName: currentUser.seenSpecies
                                                    .contains(
                                                        finalProduct[j].key)
                                                ? "collected"
                                                : "?",
                                            textsize: 8,
                                            icon: currentUser.seenSpecies
                                                    .contains(
                                                        finalProduct[j].key)
                                                ? Icons.check_rounded
                                                : Icons.question_mark_rounded,
                                            iconColor: currentUser.seenSpecies
                                                    .contains(
                                                        finalProduct[j].key)
                                                ? Color.fromARGB(
                                                    255, 12, 152, 66)
                                                : TagsWidgetButton.brownColor,
                                            iconBackgroundColor: Color.fromARGB(255, 255, 255, 255),
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
  }
}
