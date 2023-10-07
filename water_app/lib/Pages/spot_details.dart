import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:water_app/Components/info_widget.dart';
import 'package:water_app/Components/tags_widget.dart';
import 'package:water_app/Components/tags_widget_button.dart';
import 'package:water_app/processData/process_stations.dart';
// import 'package:get/route_manager.dart';
// import 'package:get/get.dart';
// import 'package:water_app/map_location.dart';
// import 'package:water_app/Pages/map_page.dart';

class SpotDetails extends StatelessWidget {
  final int index;
  final Map<String, dynamic> station;

  const SpotDetails({super.key, required this.station, this.index = 2});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Positioned(
                left: 0,
                right: 0,
                child: Container(
                  width: double.maxFinite,
                  height: 350,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/observatory.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
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
                        // await Get.to(() => CheckCurrentPosition());
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
                      name: station['station'],
                      type: "water",
                      // distance:
                      // collected:
                    ))),
          ],
        ),
        // (!ProcessStations.taiwanStationData[index]["species1"].isEmpty || !ProcessStations.taiwanStationData[index]["species2"].isEmpty || !ProcessStations.taiwanStationData[index]["species3"].isEmpty)?
        bottomNavigationBar: (!ProcessStations
                    .taiwanStationData[index]["species1"].isEmpty ||
                !ProcessStations
                    .taiwanStationData[index]["species2"].isEmpty ||
                !ProcessStations
                    .taiwanStationData[index]["species3"].isEmpty)
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (!ProcessStations
                              .taiwanStationData[index]["species1"].isEmpty)
                          ? TagsWidgetButton(
                              tagName: ProcessStations
                                  .taiwanStationData[index]["species1"],
                              icon: Icons.tag_rounded,
                              iconColor: TagsWidget.brownColor,
                              station: station,
                            )
                          : const SizedBox(width: 0),
                      const SizedBox(width: 5),
                      (!ProcessStations
                              .taiwanStationData[index]["species2"].isEmpty)
                          ? TagsWidgetButton(
                              tagName: ProcessStations
                                  .taiwanStationData[index]["species2"],
                              icon: Icons.tag_rounded,
                              iconColor: TagsWidget.brownColor,
                              station: station,
                            )
                          : const SizedBox(width: 0),
                      const SizedBox(width: 5),
                      (!ProcessStations
                              .taiwanStationData[index]["species3"].isEmpty)
                          ? TagsWidgetButton(
                              tagName: ProcessStations
                                  .taiwanStationData[index]["species3"],
                              icon: Icons.tag_rounded,
                              iconColor: TagsWidget.brownColor,
                              station: station,
                            )
                          : const SizedBox(width: 0),
                      const SizedBox(width: 5),
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
