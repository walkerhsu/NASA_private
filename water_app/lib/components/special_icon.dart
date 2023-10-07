import 'package:flutter/material.dart';

class SpecialIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double size;

  const SpecialIcon({
    super.key,
    required this.icon,
    this.backgroundColor = const Color.fromARGB(255, 241, 232, 213),
    this.iconColor = const Color(0xff756d54),
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
          color: backgroundColor
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: size * 0.6,
      ),
    );
  }
}