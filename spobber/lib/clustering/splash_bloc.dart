// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:spobber/data/global_variable.dart';
// import 'lat_lang_geohash.dart';

// class SplashBloc {
//   Future<List<LatLngAndGeohash>> getListOfLatLngAndGeohash(
//       BuildContext context) async {
//     print("START GET FAKE DATA");
//     try {
//       // final fakeList = await loadDataFromJson(context);
//       // final fakeList = await loadMarkers(dataSources, url);     
//       List<LatLngAndGeohash> myPoints = List();
//       for (int i = 0; i < places.length; i++) {
       
//         //  final fakePoint = places[i];
//         final p = LatLngAndGeohash(
//           LatLng(places[i].latitude, places[i].longitude),
//           places[i].equipmentId.toString(),
//           places[i].secretId.toString(),
//           places[i].objectUri,
//           places[i].placement,
//           places[i].previewImageUri,
//           places[i].source,
//           places[i].type,
//           places[i].readableID
//         );
//         myPoints.add(p);
//       }
//       print("EXTRACT COMPLETE");
//       return myPoints;
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }

//   // Future<List<dynamic>> loadDataFromJson(BuildContext context) async {
//   //   final fakeData = await DefaultAssetBundle.of(context)
//   //       .loadString('assets/map_point.json');
//   //   return json.decode(fakeData.toString());
//   // }

// }
