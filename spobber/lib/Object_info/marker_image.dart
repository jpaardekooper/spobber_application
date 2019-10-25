import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:spobber/data/marker_detail.dart';
import 'package:spobber/helper/load_images.dart';

import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

import '../data/lower_object.dart';
import 'dart:convert';

import 'upload_image.dart';
import 'package:spobber/helper/load_images.dart';

class MarkerImage extends StatefulWidget {
  final String id;
  final String secretId;
  // final String imageUrl;

  // // In the constructor, require a Person
  MarkerImage({@required this.id, @required this.secretId});

  @override
  _MarkerImage createState() => _MarkerImage();
}

class _MarkerImage extends State<MarkerImage> {
  List<LoadImages> _images;
  bool loading = true;

  String url = "https://spobber.azurewebsites.net/api/image/";
  @override
  void initState() {
    super.initState();

  //  _fetchData();
    // print(widget.imageUrl);
    //   print(widget.imageId);
  }

  void _fetchData() async {
    String correctUrl = url + widget.secretId;
     print(correctUrl);
    final response = await http.get(correctUrl);
   
    if (response.statusCode == 200) {
      _images = (json.decode(response.body) as List)
          .map((data) => new LoadImages.fromJson(data))
          .toList();

      setState(() {
        loading = false;
      });

      for (int i = 0; i < _images.length; i++) {
        print("Object id is: " + _images[i].image.toString());
      }

      // if (mounted) {
      //   setState(() {
      //     loading = false;
      //   });
      // }

    } else {
      print("error geen foto's gevonden");
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (loading == true) {
    //   return Scaffold(
    //     body: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //     // floatingActionButton: FloatingActionButton(
    //     //   child: Icon(Icons.ac_unit),
    //     //   onPressed: () {
    //     //     // _fetchData();
    //     //   },
    //     // ),
    //   );
    // } else {

    return Scaffold(
      body: loading ? noimageFound() : timelineModel(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () {
          print("u pressed me");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TakePictureScreen(
                        id: widget.id,
                        secretId: widget.secretId,
                      )));
        },
      ),
    );
  }
  // }

  Widget noimageFound() {
    return Center(
        child: Container(
      child: Text("Geen foto's gevonden van "),
    ));
  }

  Widget timelineModel() => Timeline.builder(
        itemBuilder: centerTimelineBuilder,
        itemCount: _images.length,
      );

  TimelineModel centerTimelineBuilder(BuildContext context, int i) {
    final doodle = _images[i];
    // final textTheme = Theme.of(context).textTheme;
    return TimelineModel(
        Card(
          margin: EdgeInsets.symmetric(vertical: 16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //  Image.network(doodle.id.toString()),
                Image.network(doodle.image),
                ExampleButtonNode(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenWrapper(
                        imageProvider: NetworkImage(doodle.image),
                        minScale: 0.8,
                        maxScale: 1.1,
                        initialScale: 1.1,
                      ),
                    ),
                  );
                }),
                const SizedBox(
                  height: 8.0,
                ),
                Text(doodle.image.toString()),
                const SizedBox(
                  height: 8.0,
                ),
                // Text(
                //   doodle.image.toString(),
                //   textAlign: TextAlign.center,
                // ),
                const SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          ),
        ),
        position:
            i % 2 == 0 ? TimelineItemPosition.right : TimelineItemPosition.left,
        isFirst: i == 0,
        isLast: i == _images.length,
        iconBackground: Colors.cyan,
        icon: Icon(Icons.star, color: Colors.white));
  }
}

class ExampleButtonNode extends StatelessWidget {
  const ExampleButtonNode({
    this.title,
    this.onPressed,
  });

  // final String title;
  final Function onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(
          vertical: 20.0,
        ),
        child: Container(
            margin: const EdgeInsets.only(
              top: 10.0,
            ),
            child: RaisedButton(
              onPressed: onPressed,
              child: const Text(
                "Foto weergeven",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            )));
  }
}

class FullScreenWrapper extends StatelessWidget {
  const FullScreenWrapper(
      {this.imageProvider,
      this.loadingChild,
      this.backgroundDecoration,
      this.minScale,
      this.maxScale,
      this.initialScale,
      this.basePosition = Alignment.center});

  final ImageProvider imageProvider;
  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final dynamic initialScale;
  final Alignment basePosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("test"),
        ),
        body: Container(
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: Stack(children: <Widget>[
              PhotoView(
                imageProvider: imageProvider,
                loadingChild: loadingChild,
                backgroundDecoration: backgroundDecoration,
                minScale: minScale,
                maxScale: maxScale,
                initialScale: initialScale,
                basePosition: basePosition,
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child:
                          Text("Foto", style: TextStyle(color: Colors.white))))
            ])));
  }
}
