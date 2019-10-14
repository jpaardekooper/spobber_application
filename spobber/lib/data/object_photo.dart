import 'package:flutter/material.dart';

class ObjectPhoto {
  final int id;
  final String type;
  final double latitude;
  final double longitude;
  final int status;
  final String image;

  ObjectPhoto({this.id, this.type, this.latitude, this.longitude, this.status, this.image});

  factory ObjectPhoto.fromJson(Map<String, dynamic> json) {
    return ObjectPhoto(
      id: json['id'],
      type: json['type'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      status: json['status'],
      image: json['image'],
    );
  }
}

