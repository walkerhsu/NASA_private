// ignore_for_file: non_constant_identifier_names

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

abstract class ProcessSpecies {
  // static List<Map<LatLng, double>> theta = [];
  // static List<Map<LatLng, double>> phi = [];
  static List<Map<String, dynamic>> species = [];
  static List<Map<String, dynamic>> criticalHabitat = [];

  static Future<List<List<Map<String, dynamic>>>> processCsv(context) async {
    if (species.isNotEmpty) {
      return [species];
    }
    var noFrogSpeciesString = await DefaultAssetBundle.of(context).loadString(
      "assets/data/taiwan_no_frog.csv",
    );
    // var canadaSpeciesString = await DefaultAssetBundle.of(context).loadString(
      // "assets/data/CriticalHabitat_FGP.csv",
    // );

    List<List<dynamic>> noFrogSpecies =
        const CsvToListConverter().convert(noFrogSpeciesString, eol: "\n");
    int LATITUDEIDX = 1;
    int LONGITUDEIDX = 2;
    int SPECIESIDX = 3;
    int COMMONNAMEIDX = 4;

    // int TAXCON = 5;
    // int WATERBODYIDX = 7;
    // int SARA_STATUS_IDX = 8;
    // int AREAIDX = 14;
    // int GEOMETRY_IDX = 17;
    

    // List<List<dynamic>> canadaSpecies =
    //     const CsvToListConverter().convert(canadaSpeciesString, eol: "\n");

    // for (int i = 1; i < canadaSpecies.length; i++) {
    //   Map<String, dynamic> speciesData = {};
    //   // speciesData["image"] = canadaSpecies[i][IMAGEIDX];
    //   speciesData["species"] = canadaSpecies[i][SPECIESIDX];
    //   speciesData["common_name"] = canadaSpecies[i][COMMONNAMEIDX-2];
    //   speciesData["taxon"] = canadaSpecies[i][TAXCON];
    //   speciesData["waterbody"] = canadaSpecies[i][WATERBODYIDX];
    //   speciesData["sara_status"] = canadaSpecies[i][SARA_STATUS_IDX];
    //   speciesData["Area_Km2"] = canadaSpecies[i][AREAIDX];
    //   speciesData["geometry"] = canadaSpecies[i][GEOMETRY_IDX];

    //   criticalHabitat.add(speciesData);
    // }

    for (int i = 1; i < noFrogSpecies.length; i++) {
      Map<String, dynamic> speciesData = {};
      speciesData["image"] = "image$i.png";
      double latitude = noFrogSpecies[i][LATITUDEIDX];
      double longitude = noFrogSpecies[i][LONGITUDEIDX];
      speciesData["location"] = LatLng(latitude, longitude);
      speciesData["species"] = noFrogSpecies[i][SPECIESIDX];
      speciesData["common_name"] = noFrogSpecies[i][COMMONNAMEIDX];
      species.add(speciesData);
    }
    // print(criticalHabitat[0]);
    return [species, criticalHabitat];
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
