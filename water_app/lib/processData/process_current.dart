import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

abstract class ProcessCurrent {
  static List<double> latitude = [];
  static List<double> longtitude = [];
  // static List<Map<LatLng, double>> theta = [];
  // static List<Map<LatLng, double>> phi = [];
  static List<List<LatLng>> current = [];

  static Future<List<List<LatLng>>> processCsv(context) async {
    var thetaAngleString = await DefaultAssetBundle.of(context).loadString(
      "assets/data/ocean_current_theta_angle.csv",
    );
    var phiAngleString = await DefaultAssetBundle.of(context).loadString(
      "assets/data/ocean_current_phi_angle.csv",
    );
    List<List<dynamic>> thetaAngle =
        const CsvToListConverter().convert(thetaAngleString, eol: "\n");
    List<List<dynamic>> phiAngle =
        const CsvToListConverter().convert(phiAngleString, eol: "\n");
    for (int i = 1; i < thetaAngle[0].length; i++) {
      if (thetaAngle[0][i] > 180 && thetaAngle[0][i] <= 540) {
        longtitude.add(thetaAngle[0][i] - 360 as double);
      } else {
        longtitude.add(thetaAngle[0][i] as double);
      }
    }
    for (int i = 1; i < thetaAngle.length; i++) {
      latitude.add(thetaAngle[i][0] as double);
    }
    for (int i = 0; i < latitude.length; i++) {
      for (int j = 0; j < longtitude.length; j++) {
        if (thetaAngle[i + 1][j + 1].runtimeType != String) {
          LatLng latLng = LatLng(latitude[i], longtitude[j]);
          current.add([
            latLng,
            createCoord(
                latLng, thetaAngle[i + 1][j + 1], phiAngle[i + 1][j + 1])
          ]);
        }
      }
    }
    return current;
  }
}

LatLng createCoord(LatLng coord, double theta, double phi) {
  LatLng newCoord = coord;
  // print({coord.latitude + theta, coord.longitude + phi});
  if ((coord.longitude + phi) >= 180.0 && (coord.longitude + phi) <= 540.0) {
    newCoord = LatLng(coord.latitude + theta, (coord.longitude + phi) - 360);
    // print(newCoord);
    return newCoord;
  }
  else if((coord.longitude + phi) <= -180.0 && (coord.longitude + phi) >= -540.0) {
    newCoord = LatLng(coord.latitude + theta, (coord.longitude + phi) + 360);
    // print(newCoord);
    return newCoord;
  }
  newCoord = LatLng(coord.latitude + theta, (coord.longitude + phi));
  // print(newCoord);
  return newCoord;
}
