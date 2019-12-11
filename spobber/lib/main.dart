import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spobber/pages/homescreen_tabs.dart';
import 'theme/theme.dart';





void main() async {
   WidgetsFlutterBinding.ensureInitialized(); 

  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp,DeviceOrientation.portraitDown])
      .then((_) {
    runApp(MyApp());
  });
}

// List<CameraDescription> cameras;

// Future<Null> main() async {
//   try {
//     cameras = await availableCameras();
//   } on CameraException catch (e) {
//     print('Error: $e.code\nError Message: $e.message');
//   }
//   runApp(new MyApp());
// }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //Theme color can be found under theme directory
        //  primarySwatch: myColor,
        primaryColor: myColor,
      ),
      home: Splash(),
    );
  } 
}
