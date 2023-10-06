import 'package:firebase_storage/firebase_storage.dart';

abstract class CloudStorage {
  // Create a storage reference from our app
  static final storageRef = FirebaseStorage.instance.ref();

  // Create a reference to a file from a Google Cloud Storage URI
  static final taiwanSpeciesRef = storageRef.child("taiwan_species");
  static final canadaSpeciesRef = storageRef.child("canada_species");
  // Create a reference from an HTTPS URL
  // Note that in the URL, characters are URL escaped!
  final httpsReference = FirebaseStorage.instance.refFromURL(
      "https://firebasestorage.googleapis.com/b/YOUR_BUCKET/o/images%20stars.jpg");

  static Future<String> getImageURL(imageName) async {
    return await taiwanSpeciesRef.child(imageName).getDownloadURL();
  }
}
