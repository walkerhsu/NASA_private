import 'package:flutter/material.dart';
import 'package:water_app/home_page.dart';
import 'package:water_app/Theme/theme_data.dart';
import 'package:water_app/Notification/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService.setup();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
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
