import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:water_app/OceanData/ocean_data.dart';
import 'package:water_app/HTTP/http_request.dart';
import 'package:water_app/Details/ocean_detail_data.dart';

class GetDetailData extends StatelessWidget {
  const GetDetailData({Key? key, required this.location}) : super(key: key);
  final LatLng location;

// OceanData currenntOceanData = await
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: HttpRequest.getJsonData(
          location,
          "http://api.geonames.org/oceanJSON?lat=${location.latitude}&lng=${location.longitude}&username=walkerhsu",
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            OceanData currentOceanData = snapshot.data as OceanData;
            return OceanDetailData(oceanData: currentOceanData);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}