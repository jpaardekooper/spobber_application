import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';

import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

import '../data/object_photo.dart';
import 'dart:convert';

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import 'package:image_picker/image_picker.dart';

class MarkerImage extends StatefulWidget {
  final String imageUrl;
  // In the constructor, require a Person
  MarkerImage(this.imageUrl);
  @override
  _MarkerImage createState() => _MarkerImage();
}

class _MarkerImage extends State<MarkerImage> {
  static List<ObjectPhoto> _objectPhoto;
  bool loading = true;

  var test;

  Future<void> _camera() async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;
    test = firstCamera;
  }

  @override
  void initState() {
    super.initState();
    _camera();
    _fetchData();
    print(widget.imageUrl);
  }

  void _fetchData() async {
    if (widget.imageUrl == null || widget.imageUrl == "-") {
      return;
    } else {
      final response = await http.get(
          // "http://objectlabeler.azurewebsites.net/api/marker/?latitude=$latitude&longitude=$longtitude&zoomlevel=$zoom");
          widget.imageUrl);
      if (response.statusCode == 200) {
        _objectPhoto = (json.decode(response.body) as List)
            .map((data) => new ObjectPhoto.fromJson(data))
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
    if (loading == true) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.ac_unit),
          onPressed: () {
            // _fetchData();
          },
        ),
      );
    } else if (loading == false) {
      return Scaffold(
        body: timelineModel(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera_alt),
          onPressed: () {
            print("u pressed me");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TakePictureScreen(
                        // Pass the appropriate camera to the TakePictureScreen widget.
                        camera: test)));
          },
        ),
      );
    } else {}
  }

  // @override
  // void dispose() {
  //   print("Disposing second route");
  //   super.dispose();
  // }

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
        body: Container(
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: PhotoView(
              imageProvider: imageProvider,
              loadingChild: loadingChild,
              backgroundDecoration: backgroundDecoration,
              minScale: minScale,
              maxScale: maxScale,
              initialScale: initialScale,
              basePosition: basePosition,
            )));
  }
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  //Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.veryHigh,
    );

    // Next, initialize the controller. This returns a Future.
    //  _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      // body: FutureBuilder<void>(
      //   future: _initializeControllerFuture,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       // If the Future is complete, display the preview.
      //       return CameraPreview(_controller);
      //     }
      //     else {
      //       // Otherwise, display a loading indicator.
      //       return Center(child: CircularProgressIndicator());
      //     }
      //   },
      // ),
      body: Center(
        child: _image == null ? Text('No image selected.') : Image.file(_image),
      ),
      bottomNavigationBar: BottomAppBar(
        //shape: CircularNotchedRectangle(),
        child: new Row(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              height: 50.0,
              child: FlatButton(
                onPressed: () {
                  getCameraImage();
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.camera_roll,
                      color: Colors.blue,
                    ),
                    Text(
                      'Bladeren',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50.0,
              child: FlatButton(
                onPressed: () async {
                  getImage();
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.camera_roll,
                      color: Colors.blue,
                    ),
                    Text(
                      'Maak Foto',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50.0,
              child: FlatButton(
                onPressed: () {
                  _upload(context);  
                //   ObjectPhoto uploadImage = new ObjectPhoto();
                 

                //  _MarkerImage._objectPhoto.add(uploadImage)          ;
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.cloud_upload,
                      color: Colors.blue,
                    ),
                    Text(
                      'Uploaden',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future getCameraImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }
}

Future<void> _upload(context) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                GestureDetector(
                  child: new Text(''),
                  //      onTap: _askPermission,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                Image.network(
                    'https://thumbs.gfycat.com/HarmfulRemoteConey-size_restricted.gif'),
                GestureDetector(
                  child: Text(""),
                  //         onTap: imageSelectorGallery,
                ),
              ],
            ),
          ),
        );
      });
}
