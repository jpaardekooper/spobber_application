import 'dart:async';
import 'dart:convert';
import 'package:spobber_app/data/global_variable.dart';
import '../data/place_response.dart';
import 'package:spobber_app/network/networkmanager.dart'

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spobber_app/data/place_response.dart';

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

  Future<bool> searchNearby(String objectype) async {
    String url = "https://spobber.azurewebsites.net/api/objects/?nlat=$northLatitude&blat=$bottomLatitude&nlon=$northLongitude&blon=$bottomLongitude&source=";
    places = await loadMarkers(setDataSource, url);
    return true;
  }
}
