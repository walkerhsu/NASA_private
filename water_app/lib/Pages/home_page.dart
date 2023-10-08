import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:water_app/Authentication/authenticate.dart';
import 'package:water_app/Components/loading.dart';
import 'package:water_app/Login/home_screen.dart';
import 'package:water_app/Pages/map_page.dart';
import 'package:water_app/Pages/menu_book.dart';
import 'package:water_app/Storage/cloud_storage.dart';
import 'package:water_app/Components/big_text.dart';
import 'package:water_app/Components/small_text.dart';
import 'package:water_app/globals.dart';
import 'package:water_app/information/map_consts.dart';
import 'package:water_app/map_location.dart';
import 'package:water_app/processData/process_book.dart';
import 'package:water_app/processData/process_city.dart';
import 'package:water_app/processData/process_species.dart';
import 'package:water_app/processData/process_stations.dart';
// import 'package:get/get.dart';

class CheckCurrentPosition extends StatelessWidget {
  const CheckCurrentPosition({super.key});
  static String id = 'home_page';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetCurrentLocation.handleCurrentPosition(context, "Taiwan"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            LatLng currentPosition = snapshot.data as LatLng;
            return LoadAllData(
              currentPosition: currentPosition,
            );
          } else {
            return const Loading();
          }
        });
  }
}

class LoadAllData extends StatelessWidget {
  final LatLng currentPosition;
  const LoadAllData({
    super.key,
    required this.currentPosition,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          ProcessSpecies.processCsv(context),
          ProcessStations.processCsv(context),
          ProcessBook.processCsv(context),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MyHomePage(
              currentPosition: currentPosition,
              title: "Blue Vista",
            );
          } else {
            return const Loading();
          }
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key, required this.title, required this.currentPosition});
  final String title;
  final LatLng currentPosition;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final String title;
  late final LatLng currentPosition;

  List<String> dataCountries = ["Taiwan", "America", "Canada"];
  String dataCountry = "Taiwan";

  late Widget currentWidget;
  late final List<Map<String, dynamic>> locations;
  // ignore: non_constant_identifier_names
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
    currentPosition = widget.currentPosition;
    currentWidget = MapPage(
        country: dataCountry,
        refSearchLocation: currentPosition,
        currentPosition: currentPosition);
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
    print(currentWidget);
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
                          print(location['coordinate']);
                          setState(() {
                            controller.closeView(location['cityName']);
                            currentWidget = MapPage(
                                country: dataCountry,
                                refSearchLocation:
                                    location['coordinate'] as LatLng,
                                currentPosition: currentPosition);
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
                        size: 24,
                        fontWeight: FontWeight.normal)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const SmallText(text: 'Menu Book', size: 16),
              onTap: () async {
                if (!mounted) return;
                Navigator.pop(context);
                setState(() {
                  currentWidget = MenuBook(
                    country: dataCountry,
                    currentPosition: MapConstants.myLocation[dataCountry]!,
                  );
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
                      currentWidget = MapPage(
                        country: dataCountries[i],
                        currentPosition: currentPosition,
                      );
                    });
                  }),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.grey[600]),
              title: const SmallText(text: 'Logout', size: 16.0),
              onTap: () async {
                await Authentication.signOut();
                if (!mounted) return;
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
