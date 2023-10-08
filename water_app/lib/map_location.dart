import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:water_app/information/map_consts.dart';
import 'package:geocoding/geocoding.dart';

abstract class GetCurrentLocation {
  static Future<bool> _handleLocationPermission(context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  static Future<LatLng> handleCurrentPosition(context, String country) async {
    final hasPermission = await _handleLocationPermission(context);

    Position position = await Geolocator.getCurrentPosition(
        // forceAndroidLocationManager: true,
        desiredAccuracy: LocationAccuracy.best);
    LatLng currentLocation = LatLng(position.latitude, position.longitude);
    if (!hasPermission || kIsWeb) {
      if (country == "Taiwan" || country == "Canada" || country == "America") {
        // return MapConstants.myLocation[country]!;
        return currentLocation;
      } else {
        return MapConstants.myLocation["Taiwan"]!;
      }
    }
    List<Placemark> placemark = [];
    try {
      placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);
    } catch (e) {
      // print(e);
      // web error: MissingPluginException
      // print(MapConstants.myLocation[country]!);
      return currentLocation;
    }

    // ignore: non_constant_identifier_names
    // print(placemark);
    String GPScountry = placemark[0].country!;
    if (((GPScountry == "台灣" || GPScountry == "Taiwan") &&
            country == "Taiwan") ||
        ((GPScountry == "加拿大" || GPScountry == "Canada") &&
            country == "Canada") ||
        ((GPScountry == "美國" || GPScountry == "United States") &&
            country == "America")) {
      return currentLocation;
    } else {
      return MapConstants.myLocation[country]!;
    }
  }
}
