import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'package:water_app/UserData/userdata.dart';
import 'package:water_app/globals.dart';

abstract class CloudStorage {
  // Create a storage reference from our app
  static final storageRef = FirebaseStorage.instance.ref();

  // Create a reference to a file from a Google Cloud Storage URI
  static final taiwanSpeciesRef = storageRef.child("taiwan_species");
  static final canadaSpeciesRef = storageRef.child("canada_species");
  static final americaSpeciesRef = storageRef.child("america_species");
  static final stationsRef = storageRef.child("stations");
  static String chatGPTKey = "";

  // Create a reference from an HTTPS URL
  // Note that in the URL, characters are URL escaped!
  static Future<String> getImageURL(imageName, reference) async {
    if (reference == "Taiwan") {
      return await taiwanSpeciesRef.child(imageName).getDownloadURL();
    } else if (reference == "Canada") {
      return await canadaSpeciesRef.child(imageName).getDownloadURL();
    } else if (reference == "America") {
      return await americaSpeciesRef.child(imageName).getDownloadURL();
    } else if (reference == "stations") {
      return await stationsRef.child(imageName).getDownloadURL();
    } else {
      return "assets/images/Logo.png";
    }
  }

  static Future<List<String>> getImageURLs (List<Map<String,dynamic>> species ,String reference) async {
    // ignore: non_constant_identifier_names
    List<String> URLs = [];
    for (int i=0; i<species.length; i++) {
      String url = await getImageURL(species[i]['no_bg_image'], reference);
      URLs.add(url);
    }
    return URLs;
  }

  static Future<String> getCanadaStationsCSV() async {
    return getRawtxtData("canada_stations.csv");
  }

  static Future<void> getChatGPTKey() async {
    return await storageRef
        .child('chatgpt_api_key.txt')
        .getData()
        .then((value) {
      chatGPTKey = const Utf8Codec().decode(value!);
    });
  }

  static Future<String> getRawImageURL(path) async {
    return await storageRef.child(path).getDownloadURL();
  }

  static Future<String> getNoBGImageURL(path) async {
    return storageRef.child("image_mat").child(path).getDownloadURL();
  }

  static Future<String> getRawtxtData(path) async {
    return await storageRef.child(path).getData().then((value) {
      return const Utf8Codec().decode(value!);
    });
  }

  static void uploadTxt(path, data) async {
    storageRef.child(path).putData(data);
    return;
  }

  static Future<User> loadUserData(email) async {
    Map<String, dynamic> json =
        jsonDecode(await getRawtxtData("/userdata/$email.json").then((value) {
      return value;
    }));
    return User.fromJson(json);
  }

  static void uploadUserData(email) async {
    Map<String, dynamic> j = currentUser.toJson();
    storageRef.child("/userdata/$email.json").putString(jsonEncode(j));
  }
}
