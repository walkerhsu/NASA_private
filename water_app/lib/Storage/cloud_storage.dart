import 'package:firebase_storage/firebase_storage.dart';

abstract class CloudStorage {
  // Create a storage reference from our app
  static final storageRef = FirebaseStorage.instance.ref();

  // Create a reference to a file from a Google Cloud Storage URI
  static final taiwanSpeciesRef = storageRef.child("taiwan_species");
  static final canadaSpeciesRef = storageRef.child("canada_species");
  static final stationsRef = storageRef.child("stations");

  // Create a reference from an HTTPS URL
  // Note that in the URL, characters are URL escaped!
  final httpsReference = FirebaseStorage.instance.refFromURL(
      "https://firebasestorage.googleapis.com/b/YOUR_BUCKET/o/images%20stars.jpg");

  static Future<String> getImageURL(imageName, reference) async {
    if (reference == "taiwan_species") {
      return await taiwanSpeciesRef.child(imageName).getDownloadURL();
    } else if (reference == "canada_species") {
      return await canadaSpeciesRef.child(imageName).getDownloadURL();
    } else if (reference == "stations") {
      return await stationsRef.child(imageName).getDownloadURL();
    } else {
      return "assets/images/Logo.png";
    }
  }

  static Future<String> getCanadaCSV() async {
    return await storageRef.child("CriticalHabitat_FGP.csv").getDownloadURL();
  }
}
