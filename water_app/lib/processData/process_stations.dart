// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:csv/csv.dart';
import 'package:water_app/Storage/cloud_storage.dart';
import 'package:water_app/processData/calculate_distance.dart';
import 'package:water_app/processData/process_species.dart';

abstract class ProcessStations {
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
    "temperature",
    "RPI_unit",
    "DO(Electrode)_unit",
    "BOD5_unit",
    "SS_unit",
    "NH3-N_unit",
    "pH_unit",
    "temperature_unit",
    "species1",
    "species2",
    "species3",
  ];

  static List<Map<String, dynamic>> taiwanStationData = [];
  static List<Map<String, dynamic>> CanadaStationData = [];
  static List<Map<String, dynamic>> AmericaStationData = [];

  static Future<List<Map<String, dynamic>>> processCsv(
      context, String country) async {
    if (country == "Taiwan") {
      if (taiwanStationData.isNotEmpty) {
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
          stationData[dataName[j]] = taiwanRiverData[i][j + 1];
        }
        LatLng latLng =
            LatLng(stationData["latitude"], stationData["longitude"]);
        stationData["location"] = latLng;
        // remove latitude and longitude from stationData
        stationData.remove("latitude");
        stationData.remove("longitude");
        stationData["waterbody"] = stationData["river"];
        taiwanStationData.add(stationData);
      }
      // print(taiwanStationData[1]);
      return taiwanStationData;
    } else if (country == "Canada") {
      if (CanadaStationData.isEmpty) {
        String CanadaStationsCSV = await CloudStorage.getCanadaStationsCSV();
        int CANADACOMMONNAMEIDX = 1;
        int SCIENCIFICNAMEIDX = 2;
        int WATERBODYIDX = 3;
        int SARA_STATUS_IDX = 4;
        int LATIDX = 5;
        int LNGIDX = 6;
        int DETAILEDIDX = 7;
        int RAWIMG = 8;

        List<List<dynamic>> CanadaStations =
            const CsvToListConverter().convert(CanadaStationsCSV, eol: "\n");
        for (int i = 1; i < CanadaStations.length; i++) {
          Map<String, dynamic> CanadaStation = {};
          CanadaStation["common_name"] = CanadaStations[i][CANADACOMMONNAMEIDX];
          CanadaStation["scientific_name"] =
              CanadaStations[i][SCIENCIFICNAMEIDX];
          CanadaStation["waterbody"] = CanadaStations[i][WATERBODYIDX];
          CanadaStation["station"] = CanadaStations[i][WATERBODYIDX];
          CanadaStation["sara_status"] = CanadaStations[i][SARA_STATUS_IDX];
          double latitude = CanadaStations[i][LATIDX];
          double longitude = CanadaStations[i][LNGIDX];
          CanadaStation["location"] = LatLng(latitude, longitude);
          CanadaStation["image"] = CanadaStations[i][DETAILEDIDX];
          CanadaStation["no_bg_image"] = CanadaStations[i][RAWIMG];
          CanadaStation["country"] = "Canada";

          CanadaStationData.add(CanadaStation);

          ProcessSpecies.species.add(CanadaStation);
          ProcessSpecies.CanadaSpecies.add(CanadaStation);
        }
      }
      return CanadaStationData;
    } else if (country == "America") {
      if (AmericaStationData.isNotEmpty) {
        return AmericaStationData;
      }
      var AmericaStationDataString =
          await DefaultAssetBundle.of(context).loadString(
        "assets/data/America_river_data.csv",
      );
      List<List<dynamic>> AmericaRiverData = const CsvToListConverter()
          .convert(AmericaStationDataString, eol: "\n");
      for (int i = 1; i < AmericaRiverData.length; i++) {
        Map<String, dynamic> stationData = {};
        for (int j = 0; j < dataName.length; j++) {
          stationData[dataName[j]] = AmericaRiverData[i][j + 1];
        }
        LatLng latLng =
            LatLng(stationData["latitude"], stationData["longitude"]);
        stationData["location"] = latLng;
        // remove latitude and longitude from stationData
        stationData.remove("latitude");
        stationData.remove("longitude");
        stationData["waterbody"] = stationData["river"];
        AmericaStationData.add(stationData);
      }
      return AmericaStationData;
    } else {
      return [];
    }
  }

  static List<int> sortStations(LatLng currentPosition, String country) {
    List<int> argsort = [];
    if (country == "Taiwan") {
      for (int i = 0; i < taiwanStationData.length; i++) {
        argsort.add(i);
      }
      argsort.sort((a, b) => CalculateDistance.calculateDistance(
              currentPosition, taiwanStationData[a]["location"])
          .compareTo(CalculateDistance.calculateDistance(
              currentPosition, taiwanStationData[b]["location"])));
    } else if (country == "Canada") {
      for (int i = 0; i < CanadaStationData.length; i++) {
        argsort.add(i);
      }
      argsort.sort((a, b) => CalculateDistance.calculateDistance(
              currentPosition, CanadaStationData[a]["location"])
          .compareTo(CalculateDistance.calculateDistance(
              currentPosition, CanadaStationData[b]["location"])));
    } else if (country == "America") {
      for (int i = 0; i < AmericaStationData.length; i++) {
        argsort.add(i);
      }
      argsort.sort((a, b) => CalculateDistance.calculateDistance(
              currentPosition, AmericaStationData[a]["location"])
          .compareTo(CalculateDistance.calculateDistance(
              currentPosition, AmericaStationData[b]["location"])));
    }
    return argsort;
  }
}
