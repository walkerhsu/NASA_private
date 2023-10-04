import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'dart:convert';

import 'package:water_app/OceanData/ocean_data.dart';
import 'package:water_app/HTTP/http_constants.dart';

abstract class HttpRequest {
  static Future<OceanData> getJsonData(LatLng position, String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return OceanData.fromJson(position, jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<String> chatGPTAPI(String prompt) async {
    List<Map<String, String>> messages = [];
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${HTTPConstants.openAiKey}',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo-instruct",
          "messages": messages,
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
