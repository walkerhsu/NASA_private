import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:water_app/Pages/map_page.dart';
// import 'package:water_app/water_temperature.dart';
import 'package:water_app/Pages/map_taipei_location.dart';
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
    // {
    //   'title': 'Water temperature',
    //   'icon': const Icon(Icons.thermostat_outlined),
    //   'body': const WaterTemperature(),
    // },
    {
      'title': 'Water quality',
      'icon': const Icon(Icons.water_drop_outlined),
      // 'body': const MapPage(),
      'body': const Center(
        child: Text('Hello World'),
      )
    },
    {
      'title': 'Water level',
      'icon': const Icon(Icons.height_outlined),
      // 'body': const MapPage(),
      'body': const Center(
        child: Text('Hello World'),
      )
    },
  ];
  List<Location> locations = [
    Location(cityName: "Taipei", coordinate: const LatLng(25.0330, 121.5654)),
    Location(cityName: "Tokyo", coordinate: const LatLng(35.6839, 139.7744)),
    Location(cityName: "New York", coordinate: const LatLng(40.6943, -73.9249)),
    Location(
        cityName: "Vancouver", coordinate: const LatLng(49.2827, -123.1207)),
  ];

  int currentDrawerIndex = 0;
  @override
  void initState() {
    super.initState();
    title = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: <Widget>[
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              padding: const EdgeInsets.all(8.0),
              child: SearchAnchor(
                  builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  hintText: "Search place...",
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0)),
                  onTap: () {
                    controller.openView();
                  },
                  onChanged: (_) {
                    controller.openView();
                  },
                  leading: Icon(Icons.search, color: Colors.grey[800]),
                  // trailing: <Widget>[
                  //   Tooltip(
                  //     message: 'Change brightness mode',
                  //     child: IconButton(
                  //       isSelected: isDark,
                  //       onPressed: () {
                  //         setState(() {
                  //           isDark = !isDark;
                  //         });
                  //       },
                  //       icon: const Icon(Icons.wb_sunny_outlined),
                  //       selectedIcon: const Icon(Icons.brightness_2_outlined),
                  //     ),
                  //   )
                  // ],
                );
              }, suggestionsBuilder:
                      (BuildContext context, SearchController controller) {
                return locations.map((location) {
                  return ListTile(
                    title: Text(location.cityName),
                    onTap: () {
                      setState(() {
                        controller.closeView(location.cityName);
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
            // GestureDetector(onTap: () => {
            //     Get.to(() => SpotDetails())
            // })
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

class Location {
  String cityName;
  LatLng coordinate;

  Location({required this.cityName, required this.coordinate});
}
