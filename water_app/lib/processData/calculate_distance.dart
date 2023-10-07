import 'package:latlong2/latlong.dart';
import 'dart:math' show cos, sin, acos;

class CalculateDistance {
  static double calaulateDistance(
      LatLng currentPosition, LatLng stationPosition) {
    // ignore: constant_identifier_names
    const double Radius = 6371;
    return acos(sin(currentPosition.latitude) * sin(stationPosition.latitude) +
            cos(currentPosition.latitude) *
                cos(stationPosition.latitude) *
                cos(stationPosition.longitude - currentPosition.longitude)) *
        Radius;
  }
}
