import 'package:flutter/material.dart';
import 'services.dart';
import 'album.dart';
import 'gridcell.dart';
import 'details.dart';
import 'dart:async';
import 'package:spobber_release/marker_information/upload_image.dart';

class GridViewDemo extends StatefulWidget {
  // GridViewDemo() : super();
  final String id;
  // final String title = "Photos";
  final String secretId;
  GridViewDemo({@required this.id, @required this.secretId});

  @override
  GridViewDemoState createState() => GridViewDemoState();
}

class GridViewDemoState extends State<GridViewDemo> {
  //
  StreamController<int> streamController = new StreamController<int>();

  gridview(AsyncSnapshot<List<Album>> snapshot) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: snapshot.data.map(
          (album) {
            return GestureDetector(
              child: GridTile(
                child: AlbumCell(album),
              ),
              onTap: () {
                goToDetailsPage(context, album);
              },
            );
          },
        ).toList(),
      ),
    );
  }

  goToDetailsPage(BuildContext context, Album album) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) => GridDetails(
            curAlbum: album,
            imageProvider: NetworkImage(album.uri),
            minScale: 0.2,
            maxScale: 1.1,
            //  initialScale: 0.1,
            ),
      ),
    );
  }

  circularProgress() {
    return Center(
      child: const CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StreamBuilder(
            // initialData: 0,
            stream: streamController.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Text("aantal gevonden foto's ${snapshot.data}");
            },
          ),
          Flexible(
            child: FutureBuilder<List<Album>>(
              future: Services.getPhotos(widget.secretId),
              builder: (context, snapshot) {
                // not setstate here
                //
                // if (snapshot.hasError) {
                //   return Text('Error ${snapshot.error}');
                // }
                //
                if (snapshot.hasData) {
                  streamController.sink.add(snapshot.data.length);
                  // gridview
                  return gridview(snapshot);
                } else {
                  return circularProgress();
                }
              },
            ),
          ),
        ],
      ),
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

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }
}
