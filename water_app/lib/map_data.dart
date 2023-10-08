import 'package:flutter/material.dart';
import 'package:water_app/Pages/spot_details.dart';
import 'package:water_app/components/special_card.dart';
// import 'package:water_app/processData/process_species.dart';
// import 'package:water_app/Details/get_chatGPT_data.dart';

class MapData extends StatefulWidget {
  const MapData({super.key, required this.station});
  final Map<String, dynamic> station;
  @override
  State<MapData> createState() => _MapDataState();
}

class _MapDataState extends State<MapData> {
  late final Map<String, dynamic> station;

  @override
  void initState() {
    super.initState();
    station = widget.station;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SpotDetails(station: station),
            ),
          );
        },
        child: SpecialCard(station: station),
      ),
    );
  }
}
