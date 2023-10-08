import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:water_app/Pages/spot_details.dart';
import 'package:water_app/Components/special_card.dart';
// import 'package:water_app/processData/process_species.dart';
// import 'package:water_app/Details/get_chatGPT_data.dart';

class MapData extends StatefulWidget {
  const MapData({super.key, required this.station, required this.country, required this.currentPosition});
  final Map<String, dynamic> station;
  final String country;
  final LatLng currentPosition;

  @override
  State<MapData> createState() => _MapDataState();
}

class _MapDataState extends State<MapData> {
  late final Map<String, dynamic> station;
  late String country;

  @override
  void initState() {
    super.initState();
    station = widget.station;
    country = widget.country;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SpotDetails(
                  station: station,
                  country: country,
                  currentPosition: widget.currentPosition,
                ),
              ),
            );
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => GetDetailData(location: stations['location']),
            //   ),
            // );
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => GetChatGPTData(station: station),
            //   ),
            // );
            // if(station['location'] != null) {
            //   print(station['location']);
            // }
            // LocalNotificationService.showLocalNotification(
            //   'Yay you did it!',
            //   'Congrats on your first local notification',
            // );
          },
          child: SpecialCard(station: station)),
    );
  }
}
