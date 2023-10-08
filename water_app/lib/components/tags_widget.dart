import 'package:flutter/material.dart';

import 'small_text.dart';

class TagsWidget extends StatelessWidget {
  final String tagName;
  final double textsize;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final double iconRatio;
  final double width;
  final double height;
  static Color defaultColor = const Color.fromARGB(255, 0, 128, 128);
  static Color blueColor = const Color.fromARGB(255, 70, 130, 180);
  static Color brownColor = const Color.fromARGB(255, 149, 69, 53);
  static Color almondColor = const Color.fromARGB(240, 234, 221, 202);

  const TagsWidget({
    super.key,
    this.tagName = 'tags',
    this.textsize = 10,
    this.icon = Icons.tag_rounded,
    this.iconBackgroundColor = Colors.white,
    this.iconColor = const Color.fromARGB(255, 0, 128, 128),
    this.iconRatio = 0.6,
    this.width = 100,
    this.height = 25,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 2),
            color: iconBackgroundColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: width * 0.03),
            Icon(
              icon,
              color: iconColor,
              size: height * iconRatio,
            ),
            SizedBox(width: width * 0.03),
            SmallText(text: tagName, size: textsize),
          ],
        ));
  }
}
