import 'package:flutter/material.dart';
import 'package:water_app/Components/big_text.dart';
import 'package:water_app/Components/small_text.dart';
import 'package:water_app/Storage/cloud_storage.dart';

class SpecialCard extends StatelessWidget {
  final Map<String, dynamic> station;
  const SpecialCard({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Color.fromARGB(255, 42, 42, 42),
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
                      const SizedBox(height: 20),
                      BigText(
                        text: station['station'] ?? '',
                        fontColor: Color.fromARGB(255, 189, 189, 189),
                      ),
                      const SizedBox(height: 10),
                      SmallText(
                        text: station['river'] ?? '',
                        fontColor: Color.fromARGB(255, 189, 189, 189),
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
