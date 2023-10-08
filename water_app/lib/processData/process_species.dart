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

  static Future<void> processCsv(context) async {
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
    if (AmericaSpecies.isEmpty) {
      var AmericaSpeciesString =
          await DefaultAssetBundle.of(context).loadString(
        "assets/data/America_species.csv",
      );

      List<List<dynamic>> AmericaSpeciesData =
          const CsvToListConverter().convert(AmericaSpeciesString, eol: "\n");

      int IMAGEIDX = 0;
      int LATITUDEIDX = 1;
      int LONGITUDEIDX = 2;
      int SPECIESIDX = 3;
      int COMMONNAMEIDX = 4;
      for (int i = 1; i < AmericaSpeciesData.length; i++) {
        Map<String, dynamic> speciesData = {};
        speciesData["image"] = AmericaSpeciesData[i][IMAGEIDX];
        double latitude = AmericaSpeciesData[i][LATITUDEIDX];
        double longitude = AmericaSpeciesData[i][LONGITUDEIDX];
        speciesData["location"] = LatLng(latitude, longitude);
        speciesData["scientific_name"] = AmericaSpeciesData[i][SPECIESIDX];
        speciesData["common_name"] = AmericaSpeciesData[i][COMMONNAMEIDX];
        speciesData["country"] = "America";

        AmericaSpecies.add(speciesData);
        species.add(speciesData);
      }
    }
    return;
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
      argsort.sort((a, b) => CalculateDistance.calculateDistance(
              currentPosition, TaiwanSpecies[a]["location"])
          .compareTo(CalculateDistance.calculateDistance(
              currentPosition, TaiwanSpecies[b]["location"])));
    } else if (country == "Canada") {}

    // print(argsort);
    return argsort;
  }
}
