import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

abstract class ProcessTemperature {
  static List<double> latitude = [];
  static List<double> longtitude = [];
  static List<Map<LatLng, double>> temperature = [];

  static Future<void> processCsv(context) async {
    var result = await DefaultAssetBundle.of(context).loadString(
      "assets/data/water_temperature.csv",
    );
    List<List<dynamic>> data =
        const CsvToListConverter().convert(result, eol: "\n");
    for (int i = 1; i < data[0].length; i++) {
      if (data[0][i] > 180 && data[0][i] < 360) {
        longtitude.add(data[0][i] - 360 as double);
      } else {
        longtitude.add(data[0][i] as double);
      }
    }
    for (int i = 1; i < data.length; i++) {
      latitude.add(data[i][0] as double);
    }
    for (int i = 0; i < latitude.length; i++) {
      for (int j = 0; j < longtitude.length; j++) {
        if (data[i+1][j+1].runtimeType != String) {
          LatLng latLng = LatLng(latitude[i], longtitude[j]);
          temperature.add({latLng: data[i+1][j+1]});
        }
      }
    }
  }
}
