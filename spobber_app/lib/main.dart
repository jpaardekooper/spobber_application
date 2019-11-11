/*
 * Copyright (c) 2019 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spobber_app/maps_widgets/maps_header.dart';
import 'login/login_page.dart';

// import 'package:appcenter/appcenter.dart';
// import 'package:appcenter_analytics/appcenter_analytics.dart';
// import 'package:appcenter_crashes/appcenter_crashes.dart';


// final ios = debugDefaultTargetPlatformOverride == TargetPlatform.iOS;
// var app_secret = ios ? "f912231d-88c7-49ff-b670-f3a75c8b8c9d" : "f37d89bc-13d6-4ca5-b280-e8cb375eb3cb";

void main() async {
   WidgetsFlutterBinding.ensureInitialized(); 
  // await AppCenter.start(app_secret, [AppCenterAnalytics.id, AppCenterCrashes.id]);
  // await AppCenter.setEnabled(true);
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp,DeviceOrientation.portraitDown])
      .then((_) {
    runApp(MyApp());
  });
}
// void main() {
//   // add this, and it should be the first line in main method
 

//   // rest of your app code
//  runApp(MyApp());
// }


class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    //  HomePage.tag: (context) => HomePage(),
    GoogleMapsApp.tag: (context) => GoogleMapsApp(),
  };

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.top]);
    return MaterialApp(
      title: 'Spobber',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          hintColor: Color(0xFFC0F0E8),
          primaryColor: Color(0xFF004990),
          fontFamily: "Montserrat",
        //  canvasColor: Colors.transparent
          ),
      home: LoginPage(),
      routes: routes,
    );
  }
}
