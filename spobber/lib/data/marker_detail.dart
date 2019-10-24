class MarkerDetail {
  final int id;
  final String type;
  final String description;
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
  final String image;

  MarkerDetail(
      {this.id,
      this.type,
      this.description,
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
      this.image});


  //      MarkerDetail fromJson(Map<String, dynamic> json) {
  //   return MarkerDetail(
  //       // htmlAttributions: List<String>.from(json['html_attributions']),
  //       // nextPageToken: json['next_page_token'],
  //       // results: parseResults(json['results']),
  //       // status: json['status']);
  //       secretId: json['secret_Id'],
  //       id: json['id'],
  //       type: json['type'],      
  //       placement: json['placement'],
  //       latitude: json['latitude'],
  //       longitude: json['longitude'],    
  //       source: json['source'],
  //       previewImageUri: json['preview_image_url'],
  //       objectUri: json['object_uri']);
  // }
}
