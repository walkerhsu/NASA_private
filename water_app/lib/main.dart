import 'package:flutter/material.dart';
import 'package:water_app/home_page.dart';
import 'package:water_app/Theme/theme_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.themeData(false, context),
      home: const MyHomePage(title: 'Flutter Map Home Page'),
    );
  }
}
