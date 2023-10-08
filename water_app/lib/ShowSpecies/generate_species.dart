import 'dart:math';
import 'package:latlong2/latlong.dart';

abstract class GenerateSpecies {
  static const maxSpeciesIterate = 10000;
  static const maxDistance = 100;
  static const maxSpecies = 3;
  static const maxDeltaLat = 0.15;
  static const maxDeltaLong = 0.1;

  static List<Map<String, dynamic>> getSpecies(
      LatLng curPos, List<Map<String, dynamic>> species) {
    List<Map<String, dynamic>> closestSpecies = [];
    for (int i = 0; i < maxSpeciesIterate; i++) {
      int val = Random().nextInt(species.length);
      double distance = const Distance()
          .as(LengthUnit.Kilometer, curPos, species[val]["location"] as LatLng);
      if (distance <= maxDistance) {
        Map<String, dynamic> t = species[val];
        t["delta_lat"] = Random().nextDouble() * maxDeltaLat - maxDeltaLat / 2;
        t["delta_long"] =
            Random().nextDouble() * maxDeltaLong - maxDeltaLong / 2;
        closestSpecies.add(species[val]);
      }
      if (closestSpecies.length >= maxSpecies) {
        break;
      }
    }

    return closestSpecies;
  }
}
