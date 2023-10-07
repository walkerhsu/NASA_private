import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'dart:convert';

import 'package:water_app/OceanData/ocean_data.dart';
import 'package:water_app/Storage/cloud_storage.dart';

abstract class HttpRequest {
  static Future<OceanData> getJsonData(LatLng position, String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return OceanData.fromJson(position, jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  static String getPrompt(String? species, String? water, String type) {
    if (type == "species") {
      return "Give me three concrete advices on how to preserve $species briefly.";
    } else if (type == "water") {
      return "Tell me one fact about harmful things that a person can negatively impact the $water briefly.";
    } else {
      return "No such type.";
    }
  }

  static Future<String> chatGPTAPI(
      String? species, String? water, String type) async {
    List<Map<String, String>> messages = [];
    String prompt = getPrompt(species, water, type);
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${CloudStorage.chatGPTKey}',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": messages,
          "temperature": 1,
          "max_tokens": 100,
        }),
      );

      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }

      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }
}
