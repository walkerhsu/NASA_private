import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:water_app/Authentication/authenticate.dart';
import 'package:water_app/Login/home_screen.dart';
import 'package:water_app/Pages/map_page.dart';
// import 'package:water_app/water_temperature.dart';
import 'package:water_app/Pages/map_taipei_location.dart';
import 'package:water_app/Pages/menu_book.dart';
import 'package:water_app/Storage/cloud_storage.dart';
import 'package:water_app/globals.dart';
// import 'package:get/get.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  static String id = 'home_screen';
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final String title;
  final List<Map<String, dynamic>> _listViewData = [
    {
      'title': 'Current location',
      'icon': const Icon(Icons.location_on_outlined),
      'body': const CheckCurrentPosition(),
      // 'body': const Center(
      // child: Text('Hello World'),
      // )
    },
    {
      'title': 'Taiwan location',
      'icon': const Icon(Icons.location_on_outlined),
      'body': const CheckTaipeiPosition(),
    },
    {
      'title': 'menu_book',
      'icon': const Icon(Icons.menu_book),
      'body': const MenuBook(),
    },
    {
      'title': 'Logout',
      'icon': const Icon(Icons.height_outlined),
      'body': const HomeScreen(),
    },
  ];
  int currentDrawerIndex = 0;
  @override
  void initState() {
    super.initState();
    title = widget.title;
    // CloudStorage.loadUserData(Authentication.getCurrentUserEmail())
    //     .then((value) {
    //   currentUser = value;
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (currentDrawerIndex == _listViewData.length - 1) {
      return const HomeScreen();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width * 0.5,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text(
                    'Water App',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ),
            for (int i = 0; i < _listViewData.length; i++)
              ListTile(
                leading: _listViewData[i]['icon'],
                title: Text(_listViewData[i]['title'] as String),
                onTap: () async {
                  if (!mounted) return;
                  Navigator.pop(context);
                  setState(() {
                    currentDrawerIndex = i;
                  });
                },
              ),
          ],
        ),
      ),
      body: _listViewData[currentDrawerIndex]['body'],
      // body: const Center(
      //   child: Text('Hello World'),
      // ),
    );
  }
}
