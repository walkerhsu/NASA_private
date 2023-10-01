// ignore_for_file: non_constant_identifier_names

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

abstract class ProcessSpecies {
  // static List<Map<LatLng, double>> theta = [];
  // static List<Map<LatLng, double>> phi = [];
  static List<Map<String, dynamic>> species = [];

  static Future<List<Map<String, dynamic>>> processCsv(context) async {
    if(species.isNotEmpty) {
      return species;
    }
    var noFrogSpeciesString = await DefaultAssetBundle.of(context).loadString(
      "assets/data/taiwan_no_frog.csv",
    );
    // var phiAngleString = await DefaultAssetBundle.of(context).loadString(
    //   "assets/data/ocean_current_phi_angle.csv",
    // );
    List<List<dynamic>> noFrogSpecies =
        const CsvToListConverter().convert(noFrogSpeciesString, eol: "\n");
    int IMAGEIDX = 0;
    int LATITUDEIDX = 1;
    int LONGITUDEIDX = 2;
    int SPECIESIDX = 3;
    int COMMONNAMEIDX = 4;


    for (int i = 1; i < noFrogSpecies.length; i++) {
      Map<String, dynamic> speciesData = {};
      speciesData["image"] = noFrogSpecies[i][IMAGEIDX];
      double latitude = noFrogSpecies[i][LATITUDEIDX];
      double longitude = noFrogSpecies[i][LONGITUDEIDX];
      speciesData["location"] = LatLng(latitude, longitude);
      speciesData["species"] = noFrogSpecies[i][SPECIESIDX];
      speciesData["common_name"] = noFrogSpecies[i][COMMONNAMEIDX];
      species.add(speciesData);
    }

    return species;
  }
}

LatLng createCoord(LatLng coord, double theta, double phi) {
  LatLng newCoord = coord;
  // print({coord.latitude + theta, coord.longitude + phi});
  if ((coord.longitude + phi) >= 180.0 && (coord.longitude + phi) <= 540.0) {
    newCoord = LatLng(coord.latitude + theta, (coord.longitude + phi) - 360);
    // print(newCoord);
    return newCoord;
  } else if ((coord.longitude + phi) <= -180.0 &&
      (coord.longitude + phi) >= -540.0) {
    newCoord = LatLng(coord.latitude + theta, (coord.longitude + phi) + 360);
    // print(newCoord);
    return newCoord;
  }
  newCoord = LatLng(coord.latitude + theta, (coord.longitude + phi));
  // print(newCoord);
  return newCoord;
}
