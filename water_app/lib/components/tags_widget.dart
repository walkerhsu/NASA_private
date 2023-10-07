import 'package:flutter/material.dart';
import 'package:water_app/Components/small_text.dart';

class TagsWidget extends StatelessWidget {
  final String tagName;
  final IconData icon;
  final Color iconColor;
  final double width;
  final double height;
  static Color defaultColor = const Color.fromARGB(255, 0, 128, 128);
  static Color blueColor = const Color.fromARGB(255, 70, 130, 180);
  static Color brownColor = const Color.fromARGB(255, 149, 69, 53);

  const TagsWidget({
    super.key,
    this.tagName = 'tags',
    this.icon = Icons.tag_rounded,
    this.iconColor = const Color.fromARGB(255, 0, 128, 128),
    this.width = 125,
    this.height = 25,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          // color: defaultColor
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Icon(
            icon,
            color: iconColor,
            size: height * 0.8,
          ),
          const SizedBox(width: 10),
          SmallText(text: tagName)
        ],
      )
    );
  }
}