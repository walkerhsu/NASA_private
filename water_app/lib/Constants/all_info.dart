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
}
