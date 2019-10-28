class Album {   
  String uri;
  String year;

  Album({this.uri, this.year});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(     
      uri: json['uri'] as String,   
      year: json['year'] as String,
    );
  }
}
