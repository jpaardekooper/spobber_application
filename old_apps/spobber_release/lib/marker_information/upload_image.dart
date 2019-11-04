import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:spobber_release/data/global_variable.dart';
import 'package:spobber_release/data/marker_detail.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class TakePictureScreen extends StatefulWidget {
  final String id;
  final String secretId;

  TakePictureScreen({@required this.id, @required this.secretId});

  @override
  _TakePictureScreen createState() => _TakePictureScreen();
}

class _TakePictureScreen extends State<TakePictureScreen> {
  String correctUrl;

  //
  final String uploadEndPoint =
      'http://spobber.azurewebsites.net/api/image/upload/';

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
    //   correctUrl = uploadEndPoint + widget.id;
    //  print(correctUrl);
  }

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
    // correctUrl = uploadEndPoint + widget.id;
    //   print(correctUrl);
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
    // String fileName = tmpFile.path.split('/').last;
    upload(tmpFile.path);
  }

  // upload(String fileName) {
  //   print(correctUrl);
  //   http.post(correctUrl, body: {
  //      "filename": fileName,
  //     "image": base64Image,
  //   }).then((result) {
  //     setStatus(result.statusCode == 200 ? result.body : errMessage);
  //   }).catchError((error) {
  //     setStatus(error);
  //   });
  //   print(base64Image);
  // }

  upload(String fileN) async {
    correctUrl = uploadEndPoint + widget.secretId;
    String base64Image = base64Encode(
        (await testCompressAndGetFile(new File(fileN), fileN))
            .readAsBytesSync());
    String fileName = fileN.split("/").last;
    HttpClient provider = new HttpClient();
    HttpClientRequest request = await provider.postUrl(Uri.parse(correctUrl));
    print(correctUrl);
    request.headers.set('content-type', 'application/json');
    Map data = {
      "filename": fileName,
      "image": base64Image,
    };
    request.add(utf8.encode(json.encode(data)));
    HttpClientResponse response = await request.close();

    if (response.statusCode == 200) {
      setState(() {
        status = "Het uploaden is voltooid";
      });
    } else {
      status = "error tijdens het uploaden";
    }
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 88,
    );
    return result;
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
              fit: BoxFit.cover,
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

  bool magdrukken = true;

  @override
  Widget build(BuildContext context) {
    print(widget.secretId);
    return Scaffold(
      appBar: AppBar(
        title: Text("Voeg een foto toe"),
      ),
      body: Container(
         color: Colors.white,
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
              onPressed: () {
                if (magdrukken) {
                  startUpload();
                  setState(() {
                    magdrukken = false;
                  });
                } else {
                  print("mag niet drukken");
                }
              },
              color: magdrukken ? Colors.black : Colors.red,
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
