class PlaceResponse {
 final String secretId;
 final String equipmentId;
 final String type;
 final String placement;
 final double latitude;
 final double longitude;
 final String source;
 final String previewImageUri;
 final String objectUri;
 final String readableID;

  PlaceResponse(
      {this.secretId,
      this.equipmentId,
      this.type,
      this.placement,
      this.latitude,
      this.longitude,
      this.source,
      this.previewImageUri,
      this.objectUri,
      this.readableID});
 
  PlaceResponse fromJson(Map<String, dynamic> json) {
    return PlaceResponse(      
        secretId: json['secret_id'],
        equipmentId: json['equipment_id'],
        type: json['type'],
        placement: json['placement'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        source: json['source'],
        previewImageUri: json['preview_image_uri'],
        objectUri: json['object_uri'],
        readableID: json['readable_id']);
  }
}
