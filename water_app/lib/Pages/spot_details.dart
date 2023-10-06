import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:water_app/map_location.dart';
import 'package:water_app/Pages/map_page.dart';

class SpotDetails extends StatelessWidget {
  const SpotDetails({super.key});

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
                  image: AssetImage('assets/images/observatory.png'),
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
            //   GestureDetector(
            //     onTap: () {
            //       // Navigator.pop(context),
            //       Get.to(() => const CheckCurrentPosition());
            //       print("press back");
            //     },
            //     child:
            //   Icon(Icons.arrow_back_ios, color: Colors.white,),
            //   )
            // ]

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
        )
      ],
    ));
  }
}
