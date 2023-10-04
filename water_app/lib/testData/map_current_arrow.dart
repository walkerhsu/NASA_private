import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapCurrentArrow {
  final LatLng? startLocation;
  final LatLng? endLocation;

  MapCurrentArrow({required this.startLocation, required this.endLocation});
}

final mapCurrentArrows = [
  MapCurrentArrow(
    startLocation: const LatLng(25.03285856445492, 121.57011041776809),
    endLocation: const LatLng(25.032905292662157, 121.56278709677412),
  ),
];

double rotateAngle(LatLng startLocation, LatLng endLocation) {
  return Geolocator.bearingBetween(
    startLocation.latitude,
    startLocation.longitude,
    endLocation.latitude,
    endLocation.longitude,
  );
}
  