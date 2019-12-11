import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'lat_lang_geohash.dart';

class SplashBloc {
  Future<List<LatLngAndGeohash>> getListOfLatLngAndGeohash(
      BuildContext context) async {
    print("START GET FAKE DATA");
    try {
      final fakeList = await loadDataFromJson(context);
      List<LatLngAndGeohash> myPoints = List();
      for (int i = 0; i < fakeList.length; i++) {
        final fakePoint = fakeList[i];
        final p = LatLngAndGeohash(
          LatLng(fakePoint["LATITUDE"], fakePoint["LONGITUDE"]),
        );
        myPoints.add(p);
      }
      print("EXTRACT COMPLETE");
      return myPoints;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<dynamic>> loadDataFromJson(BuildContext context) async {
    final fakeData = await DefaultAssetBundle.of(context)
        .loadString('assets/map_point.json');
    return json.decode(fakeData.toString());
  }

}
