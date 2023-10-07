// ignore_for_file: non_constant_identifier_names

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:water_app/Storage/cloud_storage.dart';

abstract class ProcessSpecies {
  static List<Map<String, dynamic>> species = [];
  static List<Map<String, dynamic>> TaiwanSpecies = [];
  static List<Map<String, dynamic>> CanadaSpecies = [];

  static Future<List<List<Map<String, dynamic>>>> processCsv(context) async {
    if (TaiwanSpecies.isEmpty) {
      var noFrogSpeciesString = await DefaultAssetBundle.of(context).loadString(
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

    if (CanadaSpecies.isEmpty) {
      String canadaSpeciesCSVString = await CloudStorage.getCanadaCSV();
      int WATERBODYIDX = 7;
      int SARA_STATUS_IDX = 8;
      int CANADACOMMONNAMEIDX = 1;
      int SCIENCIFICNAMEIDX = 2;
      int LATIDX = 5;
      int LNGIDX = 6;
      int DETAILEDIDX = 7;
      int RAWIMG = 8;

      List<List<dynamic>> canadaSpecies =
          const CsvToListConverter().convert(canadaSpeciesCSVString, eol: "\n");

      for (int i = 1; i < canadaSpecies.length; i++) {
        Map<String, dynamic> speciesData = {};
        speciesData["common_name"] = canadaSpecies[i][CANADACOMMONNAMEIDX];
        speciesData["scientific_name"] = canadaSpecies[i][SCIENCIFICNAMEIDX];
        speciesData["waterbody"] = canadaSpecies[i][WATERBODYIDX];
        speciesData["sara_status"] = canadaSpecies[i][SARA_STATUS_IDX];
        double latitude = canadaSpecies[i][LATIDX];
        double longitude = canadaSpecies[i][LNGIDX];
        speciesData["location"] = LatLng(latitude, longitude);
        speciesData["image"] = canadaSpecies[i][DETAILEDIDX];
        speciesData["no_bg_image"] = canadaSpecies[i][RAWIMG];
        speciesData["country"] = "Canada";

        CanadaSpecies.add(speciesData);
        species.add(speciesData);
      }
    }
    return [TaiwanSpecies, CanadaSpecies];
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
}
