import 'package:flutter/material.dart';
import 'package:water_app/Login/home_screen.dart';
import 'package:water_app/Login/login_screen.dart';
import 'package:water_app/Login/signup_screen.dart';
import 'package:water_app/Pages/home_page.dart';
import 'package:water_app/Theme/theme_data.dart';
import 'package:water_app/Notification/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:water_app/Pages/home_page.dart';
import 'package:water_app/Theme/theme_data.dart';
import 'package:water_app/Notification/notification_service.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.themeData(false, context),
      // home: const MyHomePage(title: 'Flutter Map Home Page'),
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => const HomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        SignUpScreen.id: (context) => const SignUpScreen(),
        MyHomePage.id: (context) => const MyHomePage(title: 'Flutter Map Home Page'),
      },
    );
  }
}
