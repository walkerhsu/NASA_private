import 'package:csv/csv.dart';
import 'package:water_app/Storage/cloud_storage.dart';
import 'package:water_app/processData/process_species.dart';
import 'package:water_app/processData/process_stations.dart';

class AllInfo {
  static Map<String, dynamic> allSpecies = {
    "Taiwan": ProcessSpecies.TaiwanSpecies,
    "Canada": ProcessSpecies.CanadaSpecies,
    "America": ProcessSpecies.AmericaSpecies,
  };

  static Map<String, dynamic> allStations = {
    "Taiwan": ProcessStations.taiwanStationData,
    "Canada": ProcessStations.CanadaStationData,
    "America": ProcessStations.AmericaStationData,
  };
  
  // static Future<List<Map<String, dynamic>>> getMenus(context, String country) async {
  //   String menuCSVString = await CloudStorage.getRawtxtData("ill_book.csv");
  //   List<List<dynamic>> processMenuData = CsvToListConverter().convert(menuCSVString, eol: "\n");
  //   List<Map<String, dynamic>> menuData = [];
  // } 
}
