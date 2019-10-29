class LoadImages {
  final String image;

  LoadImages({this.image});

  factory LoadImages.fromJson(Map<String, dynamic> json) {
    return LoadImages(    
      image: json['image'],
    );
  }
}

