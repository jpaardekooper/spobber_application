class LowerObject {
  final int id;
  final String type;
  final double latitude;
  final double longitude;
  final int status;
  final String image;

  LowerObject({this.id, this.type, this.latitude, this.longitude, this.status, this.image});

  factory LowerObject.fromJson(Map<String, dynamic> json) {
    return LowerObject(
      id: json['id'],
      type: json['type'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      status: json['status'],
      image: json['image'],
    );
  }
}

