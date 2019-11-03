class UpperObject {
  final String id;
  final String railcode;
  final String railside;
  final double mean;
  final double minimum;
  final double maximum;
  final List<Content> content;

  UpperObject({this.id, this.railcode, this.railside, this.mean, this.minimum, this.maximum, this.content});

  factory UpperObject.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['content'] as List; 
    List<Content> contentList = list.map((i) => Content.fromJson(i)).toList();

    return UpperObject(
      id: parsedJson['id'],
      railcode: parsedJson['railcode'],
      railside: parsedJson['railside'],
      mean: parsedJson['average'],
      minimum: parsedJson['minimum'],
      maximum: parsedJson['maximum'],
      content: contentList,   

    );
  }
}

class Content{
  final String id;
  final double value;
  final double latitude;
  final double longitude;
  final String previewImage;
  final String measurePoint;

  Content({this.id, this.value, this.latitude, this.longitude, this.measurePoint, this.previewImage});

  factory Content.fromJson(Map<String, dynamic> parsedJson) {      

    return new Content(   
      id: parsedJson['id'],
      value: parsedJson['value'],
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
      previewImage: parsedJson['previewImage'],
      measurePoint: parsedJson['measurePoint'],       
    );
  }
}




