// ignore_for_file: non_constant_identifier_names

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:water_app/processData/calculate_distance.dart';

abstract class ProcessSpecies {
  static List<Map<String, dynamic>> species = [];
  static List<Map<String, dynamic>> TaiwanSpecies = [];
  static List<Map<String, dynamic>> CanadaSpecies = [];
  static List<Map<String, dynamic>> AmericaSpecies = [];

  static Future<List<Map<String, dynamic>>> processCsv(
      context, String country) async {
    if (country == "Taiwan") {
      if (TaiwanSpecies.isEmpty) {
        var noFrogSpeciesString =
            await DefaultAssetBundle.of(context).loadString(
          "assets/data/taiwan_no_frog.csv",
        );

        List<List<dynamic>> noFrogSpecies =
            const CsvToListConverter().convert(noFrogSpeciesString, eol: "\n");

        int IMAGEIDX = 0;
        int LATITUDEIDX = 1;
        int LONGITUDEIDX = 2;
        int SPECIESIDX = 3;
        int COMMONNAMEIDX = 4;

        for (int i = 1; i < noFrogSpecies.length; i++) {
          Map<String, dynamic> speciesData = {};
          speciesData["no_bg_image"] = "image$i.png";
          speciesData["image"] = noFrogSpecies[i][IMAGEIDX];
          double latitude = noFrogSpecies[i][LATITUDEIDX];
          double longitude = noFrogSpecies[i][LONGITUDEIDX];
          speciesData["location"] = LatLng(latitude, longitude);
          speciesData["scientific_name"] = noFrogSpecies[i][SPECIESIDX];
          speciesData["common_name"] = noFrogSpecies[i][COMMONNAMEIDX];
          speciesData["country"] = "Taiwan";

          TaiwanSpecies.add(speciesData);
          species.add(speciesData);
        }
      }
      return TaiwanSpecies;
    } else if (country == "America") {
      if (AmericaSpecies.isEmpty) {}
      return [];
    } else {
      return [];
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

  static List<int> sortSpecies(LatLng currentPosition, String country) {
    List<int> argsort = [];
    if (country == "Taiwan") {
      for (int i = 0; i < TaiwanSpecies.length; i++) {
        argsort.add(i);
      }
      argsort.sort((a, b) => CalculateDistance.calaulateDistance(
              currentPosition, TaiwanSpecies[a]["location"])
          .compareTo(CalculateDistance.calaulateDistance(
              currentPosition, TaiwanSpecies[b]["location"])));
    } else if (country == "Canada") {}

    // print(argsort);
    return argsort;
  }
}
