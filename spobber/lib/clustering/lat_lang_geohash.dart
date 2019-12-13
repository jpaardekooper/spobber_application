import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:geohash/geohash.dart';

class LatLngAndGeohash {
  final String id;
  final LatLng location;
  String geohash;

  LatLngAndGeohash(this.location, this.id) {
    geohash = Geohash.encode(location.latitude, location.longitude);
  }

  LatLngAndGeohash.fromMap(Map<String, dynamic> map)
      : location = LatLng(map['lat'], map['long']), 
      id = "test" {
    this.geohash =
        Geohash.encode(this.location.latitude, this.location.longitude);
  }

  getId() {
    return location.latitude.toString() +
        "_" +
        location.longitude.toString() +
        "_${Random().nextInt(10000)}";
  }
}
