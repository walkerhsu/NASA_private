import 'package:flutter/material.dart';
import 'package:water_app/Authentication/authenticate.dart';
import 'package:water_app/Login/home_screen.dart';
import 'package:water_app/Pages/map_page.dart';
// import 'package:water_app/water_temperature.dart';
import 'package:water_app/Pages/menu_book.dart';
import 'package:water_app/Storage/cloud_storage.dart';
import 'package:water_app/globals.dart';
// import 'package:get/get.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  static String id = 'home_page';
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final String title;

  List<String> dataCountries = ["Taiwan", "America", "Canada"];
  int action = 0;
  String dataCountry = "Taiwan";
  @override
  void initState() {
    super.initState();
    title = widget.title;
    CloudStorage.loadUserData(Authentication.getCurrentUserEmail())
        .then((value) {
      currentUser = value;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text('menu_book'),
              onTap: () async {
                if (!mounted) return;
                Navigator.pop(context);
                setState(() {
                  action = 1;
                });
              },
            ),
            for (int i = 0; i < dataCountries.length; i++)
              ListTile(
                  leading: const Icon(Icons.height_outlined),
                  title: Text(dataCountries[i]),
                  onTap: () async {
                    if (!mounted) return;
                    Navigator.pop(context);
                    setState(() {
                      setState(() {
                        action = 0;
                      });
                      dataCountry = dataCountries[i];
                    });
                  }),
            ListTile(
              leading: const Icon(Icons.height_outlined),
              title: const Text('Logout'),
              onTap: () async {
                if (!mounted) return;
                Authentication.signOut();
                Navigator.popUntil(context, ModalRoute.withName(HomeScreen.id));
              },
            ),
          ],
        ),
      ),
      body: action == 0
          ? CheckCurrentPosition(country: dataCountry)
          : const MenuBook(),
      // body: const Center(
      //   child: Text('Hello World'),
      // ),
    );
  }
}
