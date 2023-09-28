import 'package:flutter/material.dart';
import 'package:water_app/map_page.dart';
import 'package:water_app/processData/process_temperature.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final String title;
  final List<Map<String, dynamic>> _listViewData = [
    {
      'title': 'Water temperature',
      'icon': const Icon(
        Icons.thermostat_outlined,
      ),
    },
    {
      'title': 'Water quality',
      'icon': const Icon(Icons.water_drop_outlined),
    },
    {
      'title': 'Water level',
      'icon': const Icon(Icons.height_outlined),
    },
  ];

  @override
  void initState() {
    super.initState();
    title = widget.title;
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
            for (int i = 0; i < _listViewData.length; i++)
              ListTile(
                leading: _listViewData[i]['icon'],
                title: Text(_listViewData[i]['title'] as String),
                onTap: () async {
                  if (i == 0) {
                    await ProcessTemperature.processCsv(context);
                  }
                  if (!mounted) return;
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
      body: const MapPage(),
      // body: const Center(
      //   child: Text('Hello World'),
      // ),
    );
  }
}
