import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:spobber/network/networkmanager.dart';

///uploading the image to the datastorage
class TakePictureScreen extends StatefulWidget {
  final String id;
  final String secretId;

  TakePictureScreen({@required this.id, @required this.secretId});

  @override
  _TakePictureScreen createState() => _TakePictureScreen();
}

class _TakePictureScreen extends State<TakePictureScreen> {
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

  upload(String fileN) async {
    String base64Image = base64Encode(
        (await testCompressAndGetFile(new File(fileN), fileN))
            .readAsBytesSync());
    String fileName = fileN.split("/").last;

    HttpClientResponse response =
        await uploadImage(fileName, base64Image, widget.secretId);

    if (response.statusCode == 200) {
      setState(() {
        status = "Het uploaden is voltooid";
      });

      await Future.delayed(Duration(milliseconds: 500));
      Navigator.pop(context);
    } else {
      status = "Error tijdens het uploaden";
    }
  }

//adding a compress so the quality goes down
//100 was to big for base64
//maximum is now 88 you can lower it even more
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
    print(widget.id);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Voeg een foto toe"),
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              OutlineButton(
                onPressed: chooseCamera,
                child: const Text('Maak een foto'),
              ),
              OutlineButton(
                onPressed: chooseImage,
                child: const Text('Kies uit gallerij'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              showImage(),
              const SizedBox(
                height: 20.0,
              ),
              OutlineButton(
                onPressed: () {
                  if (magdrukken) {
                    startUpload();
                    setState(() {
                      magdrukken = false;
                    });
                  } else {}
                },
                color: magdrukken ? Colors.black : Colors.red,
                child: const Text('Upload Foto'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: status.contains("Error") ? Colors.red : Colors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
