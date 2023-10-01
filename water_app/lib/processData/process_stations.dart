import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:csv/csv.dart';

abstract class ProcessStations {
  static List<Map<String, dynamic>> stations = [];
  static final List<String> dataName = [
    "station",
    "latitude",
    "longitude",
    "river",
    "RPI",
    "Electrode",
    "BOD5",
    "SS",
    "NH3-N",
    "pH",
    "temperature"
  ];
  static List<Map<String, dynamic>> taiwanStationData = [];

  static Future<List<Map<String, dynamic>>> processCsv(context) async {
    if(taiwanStationData.isNotEmpty) {
      return taiwanStationData;
    }
    var riverDataString = await DefaultAssetBundle.of(context).loadString(
      "assets/data/Taiwan_river_data.csv",
    );
    List<List<dynamic>> taiwanRiverData =
        const CsvToListConverter().convert(riverDataString, eol: "\n");

    for (int i = 1; i < taiwanRiverData.length; i++) {
      Map<String, dynamic> stationData = {};
      for (int j = 0; j < dataName.length; j++) {
        stationData[dataName[j]] = taiwanRiverData[i][j];
      }
      LatLng latLng = LatLng(stationData["latitude"], stationData["longitude"]);
      stationData["location"] = latLng;
      // remove latitude and longitude from stationData
      stationData.remove("latitude");
      stationData.remove("longitude");
      taiwanStationData.add(stationData);
    }
    return taiwanStationData;
  }
}
