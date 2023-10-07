import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';

abstract class FirebaseStorageFunctions {
  static final storageRef = FirebaseStorage.instance.ref();

  static Future<String> getImageURL(String path) async {
    // Use future builder to display images!
    return await storageRef.child(path).getDownloadURL();
  }

  static Future<String> getChatGPTKey() async {
    return await storageRef
        .child('chatgpt_api_key.txt')
        .getData()
        .then((value) {
      return const Utf8Codec().decode(value!);
    });
  }
}
