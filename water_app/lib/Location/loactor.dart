// import 'dart:isolate';

// import 'package:background_locator/background_locator.dart';
// import 'package:background_locator/settings/android_settings.dart';
// import 'package:background_locator/settings/ios_settings.dart';
// import 'package:background_locator/settings/locator_settings.dart';
// import 'package:flutter/material.dart';
// // import 'package:location_permissions/location_permissions.dart';
// import 'package:water_app/Location/location_callback_handler.dart';

// class BackLocator {
//   ReceivePort port = ReceivePort();

//   void startLocationService() {
//     Map<String, dynamic> data = {'countInit': 1};
//     print("here");
//     BackgroundLocator.registerLocationUpdate(LocationCallbackHandler.callback,
//         initCallback: LocationCallbackHandler.initCallback,
//         initDataCallback: data,
//         disposeCallback: LocationCallbackHandler.disposeCallback,
//         autoStop: false,
//         iosSettings: const IOSSettings(
//             accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 0),
//         androidSettings: const AndroidSettings(
//             accuracy: LocationAccuracy.NAVIGATION,
//             interval: 5,
//             distanceFilter: 0,
//             androidNotificationSettings: AndroidNotificationSettings(
//                 notificationChannelName: 'Location tracking',
//                 notificationTitle: 'Start Location Tracking',
//                 notificationMsg: 'Track location in background',
//                 notificationBigMsg:
//                     'Background location is on to keep the app up-to-date with your location. This is required for main features to work properly when the app is not running.',
//                 notificationIcon: '',
//                 notificationIconColor: Colors.grey,
//                 notificationTapCallback:
//                     LocationCallbackHandler.notificationCallback)));
//   }
// }
