class MarkerDetail {
  final String id;
  final String secretId;
  final String type;
  final String description;
  final String equipmentStatus;
  final String userStatusEquipment;
  final String parentEquipKind;
  final String datacollection;
  final String placement;
  final double latitude;
  final double longitude;
  final String picFileName;
  final String runNr;
  final String trackVersion;
  final String source;
  final int year;
  final String readableID;
 // final String image;

  MarkerDetail(
      {this.id,
      this.secretId,
      this.type,
      this.description,
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
      this.readableID
      //this.image
      });

   MarkerDetail fromJson(Map<String, dynamic> json) {
    return MarkerDetail(
      id: json['id'],
      secretId: json['secret_Id'],
      type: json['type'],
      description: json['description'],
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
      readableID: json['readable_ID']
   //   image: json['image'],
    );
  }
}
