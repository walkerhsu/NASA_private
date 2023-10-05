import 'package:firebase_storage/firebase_storage.dart';

abstract class FirebaseStorageFunctions {
  static final storageRef = FirebaseStorage.instance.ref();

  static Future<String> getImageURL(String path) async {
    // Use future builder to display images!
    return await storageRef.child(path).getDownloadURL();
  }
}
