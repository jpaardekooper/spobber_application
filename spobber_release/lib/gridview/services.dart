import 'dart:convert';
import 'package:http/http.dart' as http;
import 'album.dart';

class Services {
  static const String url = "https://spobber.azurewebsites.net/api/image/";

  static Future<List<Album>> getPhotos(String secretId) async {
    try {
      final response = await http.get(url+secretId);
      if (response.statusCode == 200) {
        List<Album> list = parsePhotos(response.body);
        return list;
      } else {
        throw Exception("Error");        
      }
    } 
    catch (e) {
    throw Exception("Er zijn geen foto's gevonden");
    }
  }

  static List<Album> parsePhotos(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Album>((json) => Album.fromJson(json)).toList();
  }
}
