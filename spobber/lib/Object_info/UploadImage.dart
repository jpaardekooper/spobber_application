// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:path/path.dart' show join;
// import 'package:path_provider/path_provider.dart';

// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/material.dart';

// import 'package:http/http.dart' as http;

// // A screen that allows users to take a picture using a given camera.
// class TakePictureScreen extends StatefulWidget {
//   // final CameraDescription camera;

//   // const TakePictureScreen({
//   //   Key key,
//   //   @required this.camera,
//   // }) : super(key: key);

//   @override
//   TakePictureScreenState createState() => TakePictureScreenState();
// }

// class TakePictureScreenState extends State<TakePictureScreen> {
//     CameraDescription camera;

//     var test;

//     Future<void> _camera() async {
//     // Obtain a list of the available cameras on the device.
//     final cameras = await availableCameras();

//     // Get a specific camera from the list of available cameras.
//     final firstCamera = cameras.first;
//     test = firstCamera;
//   }

//   CameraController _controller;
//   //Future<void> _initializeControllerFuture;

//   @override
//   void initState() {
//     super.initState();
//     _camera();
//     // To display the current output from the Camera,
//     // create a CameraController.
//     _controller = CameraController(
//       // Get a specific camera from the list of available cameras.
//       camera,
//       // Define the resolution to use.
//       ResolutionPreset.veryHigh,
//     );

//     // Next, initialize the controller. This returns a Future.
//     //  _initializeControllerFuture = _controller.initialize();
//   }

//   @override
//   void dispose() {
//     // Dispose of the controller when the widget is disposed.
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Take a picture')),
//       // Wait until the controller is initialized before displaying the
//       // camera preview. Use a FutureBuilder to display a loading spinner
//       // until the controller has finished initializing.
//       // body: FutureBuilder<void>(
//       //   future: _initializeControllerFuture,
//       //   builder: (context, snapshot) {
//       //     if (snapshot.connectionState == ConnectionState.done) {
//       //       // If the Future is complete, display the preview.
//       //       return CameraPreview(_controller);
//       //     }
//       //     else {
//       //       // Otherwise, display a loading indicator.
//       //       return Center(child: CircularProgressIndicator());
//       //     }
//       //   },
//       // ),
//       body: Center(
//         child: _image == null ? Text('No image selected.') : Image.file(_image),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         //shape: CircularNotchedRectangle(),
//         child: new Row(
//           //mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: <Widget>[
//             Container(
//               height: 50.0,
//               child: FlatButton(
//                 onPressed: () {
//                   getCameraImage();
//                 },
//                 child: Column(
//                   children: <Widget>[
//                     Icon(
//                       Icons.camera_roll,
//                       color: Colors.blue,
//                     ),
//                     Text(
//                       'Bladeren',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               height: 50.0,
//               child: FlatButton(
//                 onPressed: () async {
//                   getImage();
//                 },
//                 child: Column(
//                   children: <Widget>[
//                     Icon(
//                       Icons.camera_roll,
//                       color: Colors.blue,
//                     ),
//                     Text(
//                       'Maak Foto',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               height: 50.0,
//               child: FlatButton(
//                 onPressed: () {
//                   _upload(context);
//                 //   ObjectPhoto uploadImage = new ObjectPhoto();

//                 //  _MarkerImage._objectPhoto.add(uploadImage)          ;
//                 },
//                 child: Column(
//                   children: <Widget>[
//                     Icon(
//                       Icons.cloud_upload,
//                       color: Colors.blue,
//                     ),
//                     Text(
//                       'Uploaden',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   File _image;

//   Future getImage() async {
//     var image = await ImagePicker.pickImage(source: ImageSource.camera);

//     setState(() {
//       _image = image;
//     });
//   }

//   Future getCameraImage() async {
//     var image = await ImagePicker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       _image = image;
//     });
//   }
// }

// Future<void> _upload(context) {
//   return showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: new SingleChildScrollView(
//             child: new ListBody(
//               children: <Widget>[
//                 GestureDetector(
//                   child: new Text(''),
//                   //      onTap: _askPermission,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(8.0),
//                 ),
//                 Image.network(
//                     'https://thumbs.gfycat.com/HarmfulRemoteConey-size_restricted.gif'),
//                 GestureDetector(
//                   child: Text(""),
//                   //         onTap: imageSelectorGallery,
//                 ),
//               ],
//             ),
//           ),
//         );
//       });
// }

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class TakePictureScreen extends StatefulWidget {
  // // MarkerImage() : super();

  // final String imageUrl;
  // // In the constructor, require a Person
  // TakePictureScreen(this.imageUrl);

  @override
  _TakePictureScreen createState() => _TakePictureScreen();
}

class _TakePictureScreen extends State<TakePictureScreen> {
  //
  static final String uploadEndPoint =
      'http://localhost/flutter_test/upload_image.php';
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  chooseCamera() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.camera);
    });
    setStatus('');
  }

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
   // upload(fileName);
  }

  upload(String fileName) {    
    http.post(uploadEndPoint, body: {
      "image": base64Image,
      "name": fileName,
    }).then((result) {
      setStatus(result.statusCode == 200 ? result.body : errMessage);
    }).catchError((error) {
      setStatus(error);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'Geen foto geselecteerd',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voeg een foto toe"),
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            OutlineButton(
              onPressed: chooseCamera,
              child: Text('Maak een foto'),
            ),
            OutlineButton(
              onPressed: chooseImage,
              child: Text('Kies uit gallerij'),
            ),
            SizedBox(
              height: 20.0,
            ),
            showImage(),
            SizedBox(
              height: 20.0,
            ),
            OutlineButton(
              onPressed: startUpload,
              child: Text('Upload Foto'),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
