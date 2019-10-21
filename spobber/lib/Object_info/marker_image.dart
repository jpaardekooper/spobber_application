import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:spobber/data/marker_detail.dart';

import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

import '../data/lower_object.dart';
import 'dart:convert';

import 'upload_image.dart';

class MarkerImage extends StatefulWidget {
  final String imageId;
  final String imageUrl;
  
  // In the constructor, require a Person
  MarkerImage(this.imageId, this.imageUrl);

  @override
  _MarkerImage createState() => _MarkerImage();
}

class _MarkerImage extends State<MarkerImage> {
  static List<LowerObject> _objectPhoto;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    _fetchData();
    print(widget.imageUrl);
      print(widget.imageId);
  }

  void _fetchData() async {
    if (widget.imageUrl == null || widget.imageUrl == "-") {
      return;
    } else {
      final response = await http.get(   
          widget.imageUrl);
      if (response.statusCode == 200) {
        _objectPhoto = (json.decode(response.body) as List)
            .map((data) => new LowerObject.fromJson(data))
            .toList();

        for (int i = 0; i < _objectPhoto.length; i++) {
          print("Object id is: " + _objectPhoto[i].id.toString());
        }

        if (mounted) {
          setState(() {
            loading = false;
          });
        }
      }
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
        body: loading ? noimageFound() : timelineModel() ,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera_alt),
          onPressed: () {
            print("u pressed me");
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TakePictureScreen(imageId: widget.imageId)));
          },
        ),
      );
    }
 // }


  Widget noimageFound(){
    return Center(child: 
        Container(child: Text("Geen foto's gevonden van " + widget.imageId),));
  }

  Widget timelineModel() => Timeline.builder(
        itemBuilder: centerTimelineBuilder,
        itemCount: _objectPhoto.length,
      );

  TimelineModel centerTimelineBuilder(BuildContext context, int i) {
    final doodle = _objectPhoto[i];
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
                Text(doodle.id.toString()),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  doodle.status.toString(),
                  textAlign: TextAlign.center,
                ),
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
        isLast: i == _objectPhoto.length,
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
        appBar: AppBar(title: Text("test"),),
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
