import 'dart:async';
import 'dart:convert';
import 'package:spobber/data/global_variable.dart';
import '../data/place_response.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spobber/data/place_response.dart';

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

    for (int i = 0; i < setDataSource.length; i++) {
      url += setDataSource[i] + ",";
    }
    print(url);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // final data = json.decode(response.body);
      places = (json.decode(response.body) as List)
          .map((data) => new PlaceResponse().fromJson(data))
          .toList();   
    
    } else {
      print("url is niet gevonden");
      //throw Exception('An error occurred getting places nearby');
    }

    return true;
  }
}
