import 'package:flutter/material.dart';
import 'package:water_app/Components/big_text.dart';
import 'package:water_app/Components/expanded_description.dart';
import 'package:water_app/Components/small_text.dart';
import 'package:water_app/Components/special_icon.dart';
import 'package:water_app/Components/tags_widget.dart';
import 'package:water_app/information/observatory_info.dart';
// import 'package:water_app/information/species_info.dart';

class InfoWidget extends StatelessWidget {
  final String name;
  final String scientific_name;
  final String waterName;
  final String distance;
  final String collected;
  final String type;

  const InfoWidget(
      {super.key,
      this.name = 'Hello World',
      this.scientific_name = "You know it",
      this.waterName = 'Pacific Ocean',
      this.distance = '500 m',
      this.collected = 'uncollected',
      this.type = "Observatory"});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        BigText(text: name),
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
              tagName: collected,
              icon: Icons.accessibility_new_rounded,
            ),
          ],
        ),
        const SizedBox(height: 20),
        const BigText(
          text: 'Water Quality',
          size: 24,
        ),
        const ExpandedDescription(description: ObservatoryInfo.wois),
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
        const SizedBox(height: 50),
      ],
    );
  }
}
