import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:water_app/Authentication/authenticate.dart';
import 'package:water_app/Login/home_screen.dart';
import 'package:water_app/Pages/map_page.dart';
import 'package:water_app/Pages/menu_book.dart';
import 'package:water_app/Storage/cloud_storage.dart';
import 'package:water_app/Components/big_text.dart';
import 'package:water_app/Components/small_text.dart';
import 'package:water_app/globals.dart';
import 'package:water_app/information/map_consts.dart';
import 'package:water_app/processData/process_city.dart';
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
  String dataCountry = "Taiwan";

  late Widget currentWidget;
  late final List<Map<String, dynamic>> locations;
  List<String> IconURL = [
    'assets/icons/taiwan.png',
    'assets/icons/united-states.png',
    'assets/icons/canada.png',
  ];

  int currentDrawerIndex = 0;
  @override
  void initState() {
    super.initState();
    title = widget.title;
    CloudStorage.loadUserData(Authentication.getCurrentUserEmail())
        .then((value) {
      currentUser = value;
    });
    locations = ProcessCities.citiesData;
    currentWidget = CheckCurrentPosition(country: dataCountry);
  }

  List<Map<String, dynamic>> _search(String str) {
    List<Map<String, dynamic>> results = [];
    for (var city in locations) {
      if (city['cityName'].toLowerCase().contains(str.toLowerCase())) {
        results.add(city);
      }
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.grey[300],
          title: BigText(
            text: title,
            fontColor: Colors.black,
            size: 25,
          ),
          actions: <Widget>[
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  padding: const EdgeInsets.all(8.0),
                  child: SearchAnchor(builder:
                      (BuildContext context, SearchController controller) {
                    return SearchBar(
                      controller: controller,
                      hintText: "Search place...",
                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16.0)),
                      onTap: () {
                        controller.openView();
                      },
                      onChanged: (string) {
                        // print(string);
                        controller.openView();
                      },
                      leading: Icon(Icons.search, color: Colors.grey[800]),
                    );
                  }, suggestionsBuilder:
                      (BuildContext context, SearchController controller) {
                    List<Map<String, dynamic>> results =
                        _search(controller.text);
                    // print(results.take(15).toList());
                    return results.take(15).map((location) {
                      return ListTile(
                        title: Row(
                          children: <Widget>[
                            Text(location['cityName']),
                            const SizedBox(width: 12),
                            Text(
                              '${location['admin_name']}, ${location['country']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            controller.closeView(location['cityName']);
                            currentWidget = CheckCurrentPosition(
                              country: dataCountry,
                              refSearchLocation:
                                  location['coordinate'] as LatLng,
                            );
                          });
                        },
                      );
                    });
                  }),
                ),
              ],
            ),
          ]),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width * 0.5,
              child: const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFFE0E0E0),
                ),
                child: Center(
                    child: BigText(
                        text: 'Blue Vista',
                        size: 20,
                        fontWeight: FontWeight.normal)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const SmallText(text: 'menu_book', size: 16),
              onTap: () async {
                if (!mounted) return;
                Navigator.pop(context);
                setState(() {
                  currentWidget = const MenuBook();
                });
              },
            ),
            for (int i = 0; i < dataCountries.length; i++)
              ListTile(
                  leading: Image.asset(
                    IconURL[i],
                    width: 24.0,
                  ),
                  title: SmallText(text: dataCountries[i], size: 16),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      dataCountry = dataCountries[i];
                      currentWidget = CheckCurrentPosition(
                          country: dataCountries[i],
                          refSearchLocation:
                              MapConstants.myLocation[dataCountries[i]]);
                    });
                  }),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.grey[600]),
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
      body: currentWidget,
      // body: const Center(
      //   child: Text('Hello World'),
      // ),
    );
  }
}
