import 'package:latlong2/latlong.dart';
import 'package:water_app/OceanData/ocean_names.dart';

class OceanData {
  final String image;
  final String oceanName;
  final LatLng location;
  final double temperature;
  final double quality;
  final double seaLevel;

  OceanData({
    required this.image,
    required this.oceanName,
    required this.location,
    required this.temperature,
    required this.quality,
    required this.seaLevel,
  });

  factory OceanData.fromJson(LatLng position, Map<String, dynamic> json) {
    for (int i = 0; i < OceanNames.oceanNames.length; i++) {
      if (OceanNames.oceanNames[i]["name"] == json['ocean']['name']) {
        return OceanData(
          image: OceanNames.oceanNames[i]["image"],
          oceanName: json['ocean']['name'],
          location: position,
          temperature: 25.0,
          quality: 100,
          seaLevel: 1.0,
        );
      }
    }
    return OceanData(
      image: "assets/images/101.jpeg",
      oceanName: "no name",
      location: position,
      temperature: 25.0,
      quality: 100,
      seaLevel: 1.0,
    );
  }
}
