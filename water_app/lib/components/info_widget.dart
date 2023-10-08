// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:water_app/Components/big_text.dart';
import 'package:water_app/Components/small_text.dart';
import 'package:water_app/Components/special_icon.dart';
import 'package:water_app/Components/tags_widget.dart';
import 'package:water_app/Components/gpt_response.dart';
import 'package:water_app/Constants/all_info.dart';
import 'package:water_app/processData/process_book.dart';
// import 'package:water_app/information/species_info.dart';

class InfoWidget extends StatelessWidget {
  final String name;
  final String? scientificName;
  final String waterName;
  final String distance;
  final String? collected;
  final String type;
  final String rpi;
  final String pH;
  final String temperature;
  final String NH3_N;
  final String NH3_N_unit;
  final String country;

  const InfoWidget({
    super.key,
    this.name = 'cat',
    this.scientificName,
    this.waterName = 'Pacific Ocean',
    this.distance = '500',
    this.collected = 'uncollected',
    this.type = "species",
    this.rpi = "0",
    this.pH = "0",
    this.temperature = "0",
    this.NH3_N = "0",
    this.NH3_N_unit = "mg/L",
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        BigText(text: name),
        const SizedBox(height: 5),
        SmallText(text: scientificName ?? "", fontStyle: FontStyle.italic),
        const SizedBox(height: 10),
        type == "species" || country == "Canada"
        ? 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: (type == "species")?[
                // List.generate()
                const SpecialIcon(
                  icon: Icons.wrap_text_outlined,
                  size: 30,
                ),
                const BigText(text: "RANK:", size: 20,),
                BigText(text: ProcessBook.book[scientificName]!["rank"], size: 20),
              ]:[
                const SizedBox(height: 0),
              ],
            ), 
          ],
        )
        :
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                // List.generate()
                const SpecialIcon(
                  icon: Icons.wrap_text_outlined,
                  size: 30,
                ),
                const BigText(text: "RPI:", size: 20,),
                SmallText(text: rpi, size: 20),
              ],
            ),
            SizedBox(height: 10),
            SmallText(text: "pH: " + pH?? "0", size: 12),
            SizedBox(height: 10),
            SmallText(text: "temp: " + temperature?? "0", size: 12),
            SizedBox(height: 10),
            SmallText(text: "NH3-N: " + NH3_N + " " + NH3_N_unit?? "mg/L", size: 12),
            // SizedBox(width: 5),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 10),
            TagsWidget(
              tagName: waterName,
              icon: Icons.circle_sharp,
              height: 32,
            ),
            TagsWidget(
              tagName: (distance + " m"),
              icon: Icons.location_on,
            ),
            TagsWidget(
              tagName: collected!,
              icon: Icons.accessibility_new_rounded,
            ),
            const SizedBox(height: 10),
          ],
        ),
        const SizedBox(height: 20),
        // const BigText(
        //   text: 'Water Quality',
        //   size: 24,
        // ),
        // const ExpandedDescription(description: ObservatoryInfo.wois),
        // BigText(
        //   text: title[0],
        //   size: 24,
        // ),
        // const SizedBox(height: 10),
        type == "species"
            ? GptResponse(species: scientificName, water: null, type: type)
            : type == "water"
                ? GptResponse(species: null, water: waterName, type: type)
                : GptResponse(species: null, water: null, type: type),
      ],
    );
  }
}
