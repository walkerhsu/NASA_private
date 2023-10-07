// import 'dart:async';

// import 'package:background_locator/location_dto.dart';
// import 'package:water_app/Location/location_service.dart';

// class LocationCallbackHandler {
//   static Future<void> initCallback(Map<dynamic, dynamic> params) async {
//     LocationService myLocationCallbackRepository =
//         LocationService();
//     await myLocationCallbackRepository.init(params);
//   }

//   static Future<void> disposeCallback() async {
//     LocationService myLocationCallbackRepository =
//         LocationService();
//     await myLocationCallbackRepository.dispose();
//   }

//   static Future<void> callback(LocationDto locationDto) async {
//     LocationService myLocationCallbackRepository =
//         LocationService();
//     await myLocationCallbackRepository.callback(locationDto);
//   }

//   static Future<void> notificationCallback() async {
//     print('***notificationCallback');
//   }
// }