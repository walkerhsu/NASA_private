import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:water_app/components/info_widget.dart';
import 'package:water_app/processData/process_species.dart';

class SpeciesDetails extends StatelessWidget {
  final int index;

  const SpeciesDetails({
    super.key,
    this.index = 0,
  });

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
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      ProcessSpecies.CanadaSpecies[index]["detailed"]),
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
                  name: ProcessSpecies.CanadaSpecies[index]["common_name"],
                  waterName: ProcessSpecies.CanadaSpecies[index]["waterbody"],
                  // distance:
                  // collected:
                )))
      ],
    ));
  }
}
