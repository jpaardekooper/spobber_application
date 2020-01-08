import 'dart:convert';

import 'package:http/http.dart' as http;

class MarkerDetail {
  String id;
  String secretId;
  String type;
  String description;
  String equipmentId;
  String equipmentStatus;
  String userStatusEquipment;
  String parentEquipKind;
  String datacollection;
  String placement;
  double latitude;
  double longitude;
  String picFileName;
  String runNr;
  String trackVersion;
  String source;
  int year;
  String readableID;
  String objectType;
  // final String image;

  MarkerDetail(
     {this.id,
      this.secretId,
      this.type,
      this.description,
      this.equipmentId,
      this.equipmentStatus,
      this.userStatusEquipment,
      this.parentEquipKind,
      this.datacollection,
      this.placement,
      this.latitude,
      this.longitude,
      this.picFileName,
      this.runNr,
      this.trackVersion,
      this.source,
      this.year,
      this.readableID,
      this.objectType
      //this.image
      });

  MarkerDetail fromJson(Map<String, dynamic> json) {
    return MarkerDetail(
        id: json['id'],
        secretId: json['secret_Id'],
        type: json['type'],
        description: json['description'],
        equipmentId: json['equipment_id'],
        equipmentStatus: json['equipment_Status'],
        parentEquipKind: json['parent_equip_kind'],
        datacollection: json['datacollection'],
        placement: json['placement'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        picFileName: json['pic_file_name'],
        runNr: json['run_nr'],
        trackVersion: json['track_version'],
        source: json['source'],
        year: json['year'],
        readableID: json['readable_ID'],
        objectType: json['object_type']
        //   image: json['image'],
        );
  }

  static const _serviceUrl = 'http://mockbin.org/echo';
  static final _headers = {'Content-Type': 'application/json'};

  Future<MarkerDetail> createContact(MarkerDetail contact) async {
    try {
      String json = _toJson(contact);
     
      final response =
          await http.post(_serviceUrl, headers: _headers, body: json);
      var c = _fromJson(response.body);
      
      return c;
    } catch (e) {
      print('Server Exception!!!');
      print(e);
      return null;
    }
  }

  MarkerDetail _fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    var markerObjectToPush = new MarkerDetail();
    markerObjectToPush.id = map['id'];
    markerObjectToPush.secretId = map['secret_Id'];
    markerObjectToPush.type = map['type'];
    markerObjectToPush.description = map['description'];
    markerObjectToPush.equipmentId = map['equipment_id'];
    markerObjectToPush.equipmentStatus = map['equipment_Status'];
    markerObjectToPush.parentEquipKind = map['parent_equip_kind'];
    markerObjectToPush.datacollection = map['datacollection'];
    markerObjectToPush.placement = map['placement'];
    markerObjectToPush.latitude = map['latitude'];
    markerObjectToPush.longitude = map['longitude'];
    markerObjectToPush.picFileName = map['pic_file_name'];
    markerObjectToPush.runNr = map['run_nr'];
    markerObjectToPush.trackVersion = map['track_version'];
    markerObjectToPush.source = map['source'];
    markerObjectToPush.year = map['year'];
    markerObjectToPush.readableID = map['readable_ID'];
    markerObjectToPush.objectType = map['object_type'];

    return markerObjectToPush;
  }

  String _toJson(MarkerDetail markerObjectToPush) {
    var map = new Map();
    // mapData["name"] = markerObjectToPush.name;
    map['id'] = markerObjectToPush.id;
    map['secret_Id'] = markerObjectToPush.secretId;
    map['type'] = markerObjectToPush.type;
    map['description'] = markerObjectToPush.description;
    map['equipment_id'] = markerObjectToPush.equipmentId;
    map['equipment_Status'] = markerObjectToPush.equipmentStatus;
    map['parent_equip_kind'] = markerObjectToPush.parentEquipKind;
    map['datacollection'] = markerObjectToPush.datacollection;
    map['placement'] = markerObjectToPush.placement;
    map['latitude'] = markerObjectToPush.latitude;
    map['longitude'] = markerObjectToPush.longitude;
    map['pic_file_name'] = markerObjectToPush.picFileName;
    map['run_nr'] = markerObjectToPush.runNr;
    map['track_version'] = markerObjectToPush.trackVersion;
    map['source'] = markerObjectToPush.source;
    map['year'] = markerObjectToPush.year;
    map['readable_ID'] = markerObjectToPush.readableID;
    map['object_type'] = markerObjectToPush.objectType;
    String json = jsonEncode(map);
    return json;
  }
}
