import 'package:flutter/material.dart';
import 'package:water_app/Components/big_text.dart';
import 'package:water_app/Components/small_text.dart';
import 'package:water_app/Components/special_icon.dart';
import 'package:water_app/Components/tags_widget.dart';
import 'package:water_app/Components/gpt_response.dart';
// import 'package:water_app/information/species_info.dart';

class InfoWidget extends StatelessWidget {
  final String name;
  final String? scientificName;
  final String waterName;
  final String distance;
  final String? collected;
  final String type;

  const InfoWidget({
    super.key,
    this.name = 'cat',
    this.scientificName,
    this.waterName = 'Pacific Ocean',
    this.distance = '500 m',
    this.collected = 'uncollected',
    this.type = "species",
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
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 15,
              children: [
                // List.generate()
                SpecialIcon(
                  icon: Icons.wrap_text_outlined,
                  size: 40,
                ),
                SmallText(text: 'wrap text'),
              ],
            ),
            SizedBox(height: 10),
            SmallText(text: 'smallify'),
            SizedBox(height: 10),
            SmallText(text: 'smallify'),
            SizedBox(height: 10),
            SmallText(text: 'smallify'),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TagsWidget(
              tagName: waterName,
              icon: Icons.circle_sharp,
            ),
            TagsWidget(
              tagName: distance,
              icon: Icons.location_on,
            ),
            TagsWidget(
              tagName: collected!,
              icon: Icons.accessibility_new_rounded,
            ),
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
            ? GptResponse(species: name, water: null, type: type)
            : type == "water"
                ? GptResponse(species: null, water: name, type: type)
                : GptResponse(species: null, water: null, type: type),
        
        // const ExpandedDescription(description: SpeciesInfo.blueWhale),
        // type == "Observatory"
        //     ?
        //     const Column(
        //       children: [
        //         BigText(
        //           text: 'Water Quality',
        //           size: 24,
        //         ),
        //         ExpandedDescription(description: ObservatoryInfo.wois),
        //     ])
        //     : const Expanded(
        //         child: SingleChildScrollView(
        //             child: Column(children: [
        //         BigText(
        //           text: 'Introduce',
        //           size: 24,
        //         ),
        //         ExpandedDescription(description: SpeciesInfo.blueWhale),
        //       ])))
        // ,
      ],
    );
  }
}
