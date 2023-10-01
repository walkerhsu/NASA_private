import 'package:latlong2/latlong.dart';

class MapMarker {
  final String? image;
  final String? title;
  final String? address;
  final LatLng? location;
  final int? rating;

  MapMarker({
    required this.image,
    required this.title,
    required this.address,
    required this.location,
    required this.rating,
  });
}

final mapMarkers = [
  MapMarker(
    image: 'assets/images/ocean.jpeg',
    title: 'test ocean data',
    address: '不告訴你啦哈哈哈',
    location: const LatLng(15.509497, 114.447952),
    rating: 2,
  ),
  MapMarker(
    image: 'assets/images/101.jpeg',
    title: '台灣海峽',
    address: '110臺北市信義區信義路五段59號',
    location: const LatLng(24.420687, 119.385833),
    rating: 4,
  ),
];
