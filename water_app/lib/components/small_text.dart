import 'package:flutter/material.dart';
import 'package:water_app/Components/tags_widget.dart';

class SmallText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final String fontFamily;

  const SmallText({
    super.key,
    required this.text,
    this.size = 10.0,
    this.color = const Color.fromARGB(255, 0, 0, 0),
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    // this.fontFamily = "font-variant-caps: small-caps"
    this.fontFamily = "Poppins",
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontFamily: fontFamily,
        color: color,
      ),
    );
  }
}