import 'package:flutter/material.dart';
// import 'package:water_app/Details/get_chatgpt_data.dart';
import 'package:water_app/Notification/notification_service.dart';
import 'package:water_app/Pages/spot_details.dart';
import 'package:water_app/Storage/cloud_storage.dart';
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
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: const Color.fromARGB(255, 30, 29, 29),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            station['station'] ?? '',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            station['river'] ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const GetImageData(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class GetImageData extends StatelessWidget {
  const GetImageData({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: CloudStorage.getImageURL('Logo.png', "stations"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            String imageURL = snapshot.data as String;
            return Image.network(imageURL, fit: BoxFit.cover);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
