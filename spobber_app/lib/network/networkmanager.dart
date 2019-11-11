import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:spobber_app/network/loginmodel.dart';
import 'package:spobber_app/network/commentmodel.dart';
import '../data/place_response.dart';
import 'package:spobber_app/gridview/album.dart';

String _spobberEndpoint = "http://spobber.azurewebsites.net/api/";

String _username;
String _password;
String _token;

Future<bool> _ping() async {
  return true;
  HttpClient provider = new HttpClient();
  HttpClientRequest request =
      await provider.postUrl(Uri.parse(_spobberEndpoint + "ping"));
  request.headers.set('content-type', 'application/json');
  Map data = {
    "username": _username,
    "token": _token,
  };
  request.add(utf8.encode(json.encode(data)));
  HttpClientResponse response = await request.close();
  if (response.statusCode == 200) {
    return true;
  } else {
    if (await _login()) {
      return true;
    } else {
      return false;
    }
  }
}

Future<bool> _login() async {
  Map data = {
    "username": _username,
    "password": _password,
  };
  HttpClientRequest request =
      await _prepareGetPackage(_spobberEndpoint + "authentication", data);
  HttpClientResponse response = await request.close();
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<HttpClientRequest> _preparePostPackage(String endpoint, Map data) async {
  HttpClient provider = new HttpClient();
  HttpClientRequest request = await provider.postUrl(Uri.parse(endpoint));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(data)));
  return request;
}

Future<HttpClientRequest> _prepareGetPackage(String endpoint, Map data) async {
  HttpClient provider = new HttpClient();
  HttpClientRequest request = await provider.getUrl(Uri.parse(endpoint));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(data)));
  return request;
}

Future<HttpClientResponse> uploadImage(String fileName, String base64Image, String secretId) async {
  if (!await _ping()) {
    return null;
  }

  Map data = {
    "filename": fileName,
    "image": base64Image,
  };
  HttpClientRequest request =
      await _preparePostPackage(_spobberEndpoint + "image/upload/" + secretId, data);
  HttpClientResponse response = await request.close();
  return response;
}

Future<bool> login(String username, String password) async {
  Map<String, String> data = {
    "username": _username,
    "password": _password,
  };
  Response response =
      await get(_spobberEndpoint + "authentication", headers: data);
  if (response.statusCode == 200) {
    LoginModel model = json.decode(response.body);
    _token = model.token;
    return true;
  } else {
    response = await get(_spobberEndpoint + "authentication", headers: data);
    if (response.statusCode == 200) {
      LoginModel model = json.decode(response.body);
      _token = model.token;
      return true;
    } else {
      return false;
    }
  }
}

Future<List<PlaceResponse>> loadMarkers(List<String> dataSources, String url) async {
  if(!await _ping()){
    return new List<PlaceResponse>();
  }
  for (int i = 0; i < dataSources.length; i++) {
    url += dataSources[i] + ",";
  }
  Map<String, String> data = {
    "username": _username,
    "token": _token
  };
  Response response = await get(url, headers: data);

  if (response.statusCode == 200) {
    return (json.decode(response.body) as List)
        .map((data) => new PlaceResponse().fromJson(data))
        .toList();
  } else {
    return new List<PlaceResponse>();
  }
}

Future<List<Album>> loadImages(String secretId) async {
  if (!await _ping()) {
    return new List<Album>();
  }
  try {
    Map<String, String> data = {
      "username" : _username,
      "token": _token
    };
    final response = await get(_spobberEndpoint + "image/" + secretId, headers: data);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Album>((json) => Album.fromJson(json)).toList();
    } else {
      return new List<Album>();
    }
  } catch (e) {
    return new List<Album>();
  }
}

Future<bool> register(String email, String username, String password) async {
  Map data = {
    "email": email,
    "username": username,
    "password": password
  };
  HttpClientRequest request = await _preparePostPackage(_spobberEndpoint + "authentication/register", data);
  HttpClientResponse response = await request.close();
  if(response.statusCode == 200){
    return true;
  }
  else{
    response = await request.close();
    if(response.statusCode == 200){
      return true;
    }
    else{
      return false;
    }
  }
}

Future<List<ObjectComment>> loadComments(String secretId) async {
  if(!await _ping()){
    return new List<ObjectComment>();
  }
  Map<String, String> data = {
    "username": _username,
    "token": _token
  };
  Response response = await get(_spobberEndpoint + "comments/" + secretId, headers: data);
  if(response.statusCode == 200){
    return (json.decode(response.body) as List);
  }
  else{
    return new List<ObjectComment>();
  }
}

Future<bool> addComment(String secretId, String content) async {
  if(!await _ping()){
    return false;
  }
  Map<String, String> data = {
    "username": _username,
    "token": _token,
    "content": content
  };
  HttpClientRequest request = await _preparePostPackage(_spobberEndpoint + "comments/" + secretId, data);
  HttpClientResponse response = await request.close();
  
  if(response.statusCode == 200){
    return true;
  }
  else{
    return false;
  }
}