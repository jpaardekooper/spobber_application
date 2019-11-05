import 'album.dart';
import 'package:spobber_app/network/networkmanager.dart';

class Services {
  static const String url = "https://spobber.azurewebsites.net/api/image/";

  static Future<List<Album>> getPhotos(String secretId) async {
    return await loadImages(secretId);
  }
}