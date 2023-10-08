import 'dart:math';

import 'package:flutter/material.dart';
import 'package:water_app/Components/big_text.dart';
import 'package:water_app/Components/small_text.dart';

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
      color: const Color.fromARGB(255, 42, 42, 42),
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
                        fontColor: const Color.fromARGB(255, 189, 189, 189),
                      ),
                      const SizedBox(height: 10),
                      SmallText(
                        text: station['river'] ?? '',
                        fontColor: const Color.fromARGB(255, 189, 189, 189),
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
                child: GetImageData(),
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
  GetImageData({super.key});
  final List<String> imageURLs = [
    "https://t3.ftcdn.net/jpg/01/13/46/78/360_F_113467839_JA7ZqfYTcIFQWAkwMf3mVmhqXr7ZOgEX.jpg",
    "https://images.unsplash.com/photo-1437482078695-73f5ca6c96e2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cml2ZXJ8ZW58MHx8MHx8fDA%3D&w=1000&q=80",
    "https://upload.wikimedia.org/wikipedia/commons/d/de/Elwha_River_-_Humes_Ranch_Area2.JPG",
    "https://smartwatermagazine.com/sites/default/files/styles/thumbnail-830x455/public/what_is_a_river.jpg?itok=7SHK_wQm",
    "https://img.traveltriangle.com/blog/wp-content/uploads/2018/09/cover30.jpg",
    "https://cdn.britannica.com/97/158797-050-ABECB32F/North-Cascades-National-Park-Lake-Ann-park.jpg?w=400&h=300&c=crop",
    "https://media.istockphoto.com/id/1069539210/photo/fantastic-autumn-sunset-of-hintersee-lake.jpg?s=612x612&w=0&k=20&c=oqKJzUgnjNQi-nSJpAxouNli_Xl6nY7KwLBjArXr_GE=",
    "https://www.sciencenews.org/wp-content/uploads/2022/09/092822_js_fewer-blue-lakes_feat.jpg",
    "https://www.sciencenews.org/wp-content/uploads/2022/09/092822_js_fewer-blue-lakes_feat.jpg",
    "https://d3qvqlc701gzhm.cloudfront.net/thumbs/daf73532a7b2c2653b9475a031c5e142d1d1eab2ff6fbedcc55af10aacc7dbc5-750.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    String imageURL = imageURLs[Random().nextInt(imageURLs.length)];
    return Image.network(imageURL, fit: BoxFit.cover);
  }
}
