import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:water_app/Storage/cloud_storage.dart';

abstract class HttpRequest {
  static List<String> getPrompt(String? species, String? water, String type) {
    if (type == "species") {
      List<String> prompt = [
        "give me a description of $species within 30 words.",
        "give me three concrete advice within 30 words on how to preserve $species.",
        "tell me a fun fact about $species in 30 words in a lively way."
      ];
      return prompt;
    } else if (type == "water") {
      List<String> prompt = [
        "tell me a fun fact about $water in 30 words in a lively way",
        "tell me one concrete advice on what I should take care of when going to $water,  or how to preserve $water in 30 words in a lively way",
      ];
      return prompt;
    } else {
      return [""];
    }
  }

  static Future<String> getWaterFact(String? water) async {
    if(water == null){
      return "";
    }
    String prompt =
        "tell me a fun fact about $water in 30 words in a lively way";
    return await chatGPTAPI(prompt);
  }

  static Future<String> getSpeciesDescription(String? species) async {
    String prompt = "give me a description of $species within 30 words.";
    return await chatGPTAPI(prompt);
  }

  static Future<String> getWaterAdvice(String? water) async {
    String prompt =
        "tell me one concrete advice on what I should take care of when going to $water, or how to preserve $water in 30 words in a lively way";
    return await chatGPTAPI(prompt);
  }

  static Future<String> getSpeciesFact(String? species) async {
    String prompt =
        "tell me a fun fact about $species in 30 words in a lively way.";
    return await chatGPTAPI(prompt);
  }

  static Future<String> getSpeciesAdvice(String? species) async {
    String prompt =
        "give me three concrete advice within 30 words on how to preserve $species.";
    return await chatGPTAPI(prompt);
  }

  static Future<String> getWaterSource(String? water) async {
    String prompt = "what is the source of $water? 30 words";
    return await chatGPTAPI(prompt);
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
