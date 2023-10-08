import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:water_app/Pages/species_details.dart';
// import 'package:water_app/Components/big_text.dart';
import 'package:water_app/Components/small_text.dart';

class TagsWidgetButton extends StatelessWidget {
  final String tagName;
  final FontStyle fontStyle;
  final FontWeight fontWeight;
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final double width;
  final double height;
  final Map<String, dynamic> station;
  final String country;
  final LatLng currentPosition;
  static Color defaultColor = const Color.fromARGB(255, 0, 128, 128);
  static Color blueColor = const Color.fromARGB(255, 70, 130, 180);
  static Color brownColor = const Color.fromARGB(255, 149, 69, 53);
  static Color almondColor = const Color.fromARGB(255, 234, 221, 202);

  const TagsWidgetButton({
    super.key,
    this.tagName = 'tags',
    this.fontStyle = FontStyle.normal,
    this.fontWeight = FontWeight.normal,
    this.backgroundColor = Colors.white,
    this.icon = Icons.tag_rounded,
    this.iconColor = const Color.fromARGB(255, 0, 128, 128),
    this.width = 110,
    this.height = 35,
    required this.station,
    required this.country,
    required this.currentPosition,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SpeciesDetails(
            station: station,
            speciesName: tagName,
            country: country,
            currentPosition: currentPosition,
          ),
        ));
      },
      child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height / 2),
              color: backgroundColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 10),
              Icon(
                icon,
                color: iconColor,
                size: height * 0.7,
              ),
              const SizedBox(width: 10),
              Flexible(
                  child: SmallText(
                text: tagName,
                fontStyle: fontStyle,
                fontWeight: fontWeight,
              ))
            ],
          )),
    );
  }
}
