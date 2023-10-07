import 'package:flutter/material.dart';
import 'package:water_app/components/tags_widget.dart';

class SmallText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight fontWeight;

  const SmallText({
    super.key,
    required this.text,
    this.size = 10.0,
    this.color = const Color.fromARGB(255, 0, 0, 0),
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}