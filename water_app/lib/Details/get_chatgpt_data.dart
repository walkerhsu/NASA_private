import 'package:flutter/material.dart';
import 'package:water_app/HTTP/http_request.dart';

class GetChatGPTData extends StatelessWidget {
  const GetChatGPTData({Key? key, required this.station}) : super(key: key);
  final Map<String, dynamic> station;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: HttpRequest.chatGPTAPI("How to protect ${station['location']}"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            String answer = snapshot.data!;
            return Center(
              child: Text("answer : $answer"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
