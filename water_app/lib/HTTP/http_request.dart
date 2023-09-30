import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'dart:convert';

import 'package:water_app/OceanData/ocean_data.dart';

abstract class HttpRequest {
  static Future<OceanData> getJsonData(LatLng position, String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return OceanData.fromJson(position, jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
