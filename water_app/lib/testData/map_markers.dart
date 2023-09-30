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
    location: const LatLng(15.509497, 114.447952

),
    rating: 2,
  ),
  MapMarker(
    image: 'assets/images/象山.jpeg',
    title: '象山',
    address: '110臺北市信義區信義路五段59號',
    location: const LatLng(25.03285856445492, 121.57011041776809),
    rating: 4,
  ),
  MapMarker(
    image: 'assets/images/101.jpeg',
    title: '台北101/世貿',
    address: '110臺北市信義區信義路五段5號',
    location: const LatLng(25.032905292662157, 121.56278709677412),
    rating: 5,
  ),
  MapMarker(
    image: 'assets/images/信義安和.jpeg',
    title: '信義安和',
    address: '106臺北市大安區信義路四段233號',
    location: const LatLng(25.03313893343131, 121.55283356894425),
    rating: 2,
  ),
];
