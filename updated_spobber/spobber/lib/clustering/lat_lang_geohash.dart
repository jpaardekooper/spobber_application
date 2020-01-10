import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:geohash/geohash.dart';

class LatLngAndGeohash {
  final String id;
  final String secretId;
  final String type;
  final String placement;
  final String source;
  final String previewImageUri;
  final String objectUri;
  final LatLng location;
  final String readableID;
  String geohash;

  LatLngAndGeohash(
      this.location,
      this.id,
      this.secretId,
      this.objectUri,
      this.placement,
      this.previewImageUri,
      this.source,
      this.type,
      this.readableID) {
    geohash = Geohash.encode(location.latitude, location.longitude);
  }

  LatLngAndGeohash.fromMap(Map<String, dynamic> map)
      : location = LatLng(map['lat'], map['long']),
        id = map['id'],
        secretId = map['secretId'],
        type = map['type'],
        placement = map['placement'],
        source = map['source'],
        previewImageUri = map['previewImageUri'],
        objectUri = map['objectUri'],
        readableID = map['readable_Id'] {
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
