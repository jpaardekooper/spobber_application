import 'dart:async';
import 'package:spobber/data/global_variable.dart';
import 'package:spobber/network/networkmanager.dart';

import 'package:flutter/material.dart';

class LoadMarkers {
  final double northLatitude;
  final double bottomLatitude;
  final double northLongitude;
  final double bottomLongitude;

  LoadMarkers(
      {@required this.northLatitude,
      @required this.northLongitude,
      @required this.bottomLatitude,
      @required this.bottomLongitude});

  Future<bool> searchNearby() async {
    String url = "https://spobber.azurewebsites.net/api/objects/?nlat=$northLatitude&blat=$bottomLatitude&nlon=$northLongitude&blon=$bottomLongitude&source=";
    places = await loadMarkers(setDataSource, url);
    return true;
  }
}
