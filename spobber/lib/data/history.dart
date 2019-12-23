import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserHistory {
  String id;
  String source;
  String latitude;
  String longitude;
  String imageName;

  UserHistory();

  UserHistory.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        source = json['source'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        imageName = json['imageName'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'source': source,
        'latitude': latitude,
        'longitude': longitude,
        'imageName': imageName,
      };
}

class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key));
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}