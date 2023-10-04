import 'package:flutter/material.dart';
import 'package:water_app/map_page.dart';

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
      'title': 'Current location',
      'icon': const Icon(Icons.location_on_outlined),
      'body': const CheckCurrentPosition(),
      // 'body': const Center(
        // child: Text('Hello World'),
      // )
    },
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
  int currentDrawerIndex = 0;
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
