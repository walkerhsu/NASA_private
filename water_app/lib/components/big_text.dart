import 'package:flutter/material.dart';

class BigText extends StatelessWidget {
  final String text;
  final double size;

  const BigText({
    super.key,
    required this.text,
    this.size = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}