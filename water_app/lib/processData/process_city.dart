// import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:csv/csv.dart';
import 'dart:io' show Platform;

abstract class ProcessCities {
  static final List<String> dataName = [
    'cityName', // 0
    'latitude', // 2
    'longitude', // 3
    'country', // 4
    'admin_name' // 7
  ];
  static final List<int> dataNameOrder = [0, 2, 3, 4, 7];
  static List<Map<String, dynamic>> citiesData = [];

  static Future<List<Map<String, dynamic>>> processCsv() async {
    if (citiesData.isNotEmpty) {
      return citiesData;
    }
    var cityDataString = await rootBundle.loadString(
      "assets/data/worldcities.csv",
    );
    late List<List<dynamic>> cityRawData;
    if (kIsWeb) {
      cityRawData = const CsvToListConverter().convert(
        cityDataString,
      );
    } else {
      // print(Platform.isAndroid);
      if (Platform.isAndroid) {
        cityRawData = const CsvToListConverter().convert(
          cityDataString,
        );
      } else if (Platform.isIOS) {
        cityRawData =
            const CsvToListConverter().convert(cityDataString, eol: "\n");
      }
    }

    for (int i = 1; i < cityRawData.length; i++) {
      Map<String, dynamic> cityData = {};
      for (int j = 0; j < dataName.length; j++) {
        cityData[dataName[j]] = cityRawData[i][dataNameOrder[j]];
      }
      // print("Number $i : ${cityRawData[i]}");

      LatLng latLng = LatLng(double.parse(cityData["latitude"]),
          double.parse(cityData["longitude"]));
      cityData["coordinate"] = latLng;
      // remove latitude and longitude from cityData
      cityData.remove("latitude");
      cityData.remove("longitude");
      citiesData.add(cityData);
    }
    // for (int i = 0; i < citiesData.length; i++) {
    //   print(citiesData);
    // }
    return citiesData;
  }

  // static List<int> sortStations(LatLng currentPosition) {
  //   List<int> argsort = [];
  //   for (int i = 0; i < taiwanStationData.length; i++) {
  //     argsort.add(i);
  //   }
  //   argsort.sort((a, b) => CalculateDistance.calaulateDistance(
  //           currentPosition, taiwanStationData[a]["location"])
  //       .compareTo(CalculateDistance.calaulateDistance(
  //           currentPosition, taiwanStationData[b]["location"])));
  //   // print(argsort);
  //   return argsort;
  // }
}
