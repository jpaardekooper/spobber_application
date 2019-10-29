import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spobber/data/place_response.dart';
import 'package:spobber/marker_information/marker_template.dart';
import 'maps_body.dart';
import 'search_filter.dart';
import 'package:http/http.dart' as http;
import '../data/global_variable.dart';

import '../helper/location_services.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../data/place_response.dart';

class GoogleMapsApp extends StatefulWidget {
  static String tag = 'Maps';
  @override
  State<StatefulWidget> createState() {
    return _GoogleMapsApp();
  }
}

class _GoogleMapsApp extends State<GoogleMapsApp> {
  static String keyword = "Es-las";

  void updateKeyWord(String newKeyword) {
    print(newKeyword);
    setState(() {
      keyword = newKeyword;
    });
  }

  // final searchMarker = TextFormField(
  //   textAlign: TextAlign.center,
  //   keyboardType: TextInputType.number,
  //   autofocus: false,
  //   initialValue: '',
  //   decoration: InputDecoration(
  //     fillColor: Colors.black,
  //     hintText: 'equipment',
  //     contentPadding: EdgeInsets.fromLTRB(12, 5, 12, 5),
  //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0)),
  //   ),

  // );

  // Widget searchMarker() {
  //   return new TextFormField(
  //     decoration: InputDecoration(
  //       // icon: Icon(Icons.check_box_outline_blank),
  //       fillColor: Colors.black,
  //       hintText: 'equipment',
  //       contentPadding: EdgeInsets.fromLTRB(12, 5, 12, 5),
  //       //  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0)),
  //     ),
  //     controller: TextEditingController(text: ''),
  //     onSaved: (value) {
  //       setState(() {
  //         singleMarkerObject = value;
  //       });
  //     },
  //   );
  // }

// TextFormField(
//           enabled: false,
//           controller: TextEditingController(
//               text: markerDetailandInformation[0].year.toString()),
//           decoration: InputDecoration(
//               labelText: "bron datum:",
//               hintText: 'bron datum',
//               icon: Icon(Icons.date_range)),
//           validator: (value) {
//             if (value.isEmpty) {
//               return 'Please enter a datum';
//             }
//           },
//           onSaved: (value) {
//             setState(() {
//               age = value;
//             });
//           },
//         ))
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocation>(
      builder: (context) => LocationService().locationStream,
      child: Scaffold(
        key: _scaffoldKey,
        // title: 'Spobber',
        // home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          // iconTheme: IconThemeData(color: Colors.white),
          elevation: 10,
          // backgroundColor: Colors.blue,
          // centerTitle: false,
          title: Container(
            alignment: Alignment.center,
            color: Theme.of(context).primaryColor,
            constraints: BoxConstraints.expand(height: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 32),
                  child: Container(
                    width: 180,
                    height: 25,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, top: 6),
                      child: Text(
                        "Gefilterd op: $keyword",
                        style: TextStyle(fontSize: 14.0, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            child: Container(
                alignment: Alignment.center,
                color: Theme.of(context).primaryColor,
                constraints: BoxConstraints.expand(height: 50),
                child: MyStatefulWidget()),
            preferredSize: Size(50, 25),
          ),

          actions: <Widget>[
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                    icon: Icon(Icons.filter_list),
                    tooltip: 'Filter Search',
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    });
              },
            ),
          ],
        ),
        drawer: _buildDrawer(context),
        body: PlacesSearchMapSample(keyword),
        endDrawer: SearchFilter(updateKeyWord),
        //     ),
      ),
    );
  }
}

Widget _buildDrawer(context) {
  return Drawer(
    // column holds all the widgets in the drawer
    child: Column(
      children: <Widget>[
        Expanded(
          // ListView contains a group of widgets that scroll inside the drawer
          child: ListView(
            children: <Widget>[
              //         UserAccountsDrawerHeader(),
              ListTile(
                  title: Text(
                    "Spobber",
                    style: TextStyle(fontSize: 30),
                  ),
                  leading: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 44,
                      minHeight: 44,
                      maxWidth: 64,
                      maxHeight: 64,
                    ),
                    child: Image.asset('assets/ic_launcher.png'),
                  )),
              Divider(),

              // ListTile(
              //   leading: Icon(Icons.map),
              //   title: Text('Maps'),
              //   onTap: () {
              //     // Update the state of the app
              //     // ...
              //     // Then close the drawer
              //     Navigator.pop(context);
              //   },
              // ),
              // Divider(),
              // ListTile(
              //   leading: Icon(Icons.show_chart),
              //   title: Text('Statistiek'),
              //   onTap: () {
              //     // Update the state of the app
              //     // ...
              //     // Then close the drawer
              //     print("pressed item 2");
              //     // Navigator.pop(context);
              //     //  showModalBottomSheet<void>(
              //     //       context: context,
              //     //       builder: (BuildContext context) {
              //     //         return BottomSheetSwitch(
              //     //           switchValue: switchValue1,
              //     //           valueChanged: (value) {
              //     //             switchValue1 = value;
              //     //           },
              //     //         );
              //     //       },
              //     //  );
              //   },
              // ),
              // Divider(),
              // ListTile(
              //   leading: Icon(Icons.history),
              //   title: Text('Geschiedenis'),
              //   onTap: () {
              //     // Update the state of the app
              //     // ...
              //     // Then close the drawer
              //     // Navigator.pop(context);
              //     //        showDialog<void>(
              //     //   context: context,
              //     //   builder: (BuildContext context) {
              //     //     return BottomSheetSwitch2(
              //     //       switchValue: switchValue2,
              //     //                   valueChanged: (value) {
              //     //                     switchValue2 = value;
              //     //                   },

              //     //     );
              //     //   },
              //     // );
              //   },
              // ),
              // Divider(),
              // ListTile(
              //   leading: Icon(Icons.settings),
              //   title: Text('Account'),
              //   onTap: () {
              //     // Update the state of the app
              //     // ...
              //     // Then close the drawer
              //     print("pressed item 2");
              //     Navigator.pop(context);
              //   },
              // ),
              // Divider(),
            ],
          ),
        ),
        // This container holds the align
        Container(
            // This align moves the children to the bottom
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                // This container holds all the children that will be aligned
                // on the bottom and should not scroll with the above ListView
                child: Container(
                    child: Column(
                  children: <Widget>[
                    Divider(),
                    ListTile(
                        leading: Icon(Icons.settings), title: Text('Settings')),
                    ListTile(
                        leading: Icon(Icons.help),
                        title: Text('Help and Feedback')),
                    ListTile(
                        //leading: Icon(Icons.help),
                        title: Text(
                      'Versie 2.0.3-5-2',
                      style: TextStyle(fontWeight: FontWeight.w200),
                    ))
                  ],
                ))))
      ],
    ),
  );
}

// Define a custom Form widget.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 180,
            height: 25,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: TextFormField(
                decoration: InputDecoration(
                  // icon: Icon(Icons.check_box_outline_blank),
                  fillColor: Colors.black,
                  hintText: 'equipment',
                  contentPadding: EdgeInsets.fromLTRB(12, 5, 12, 5),
                  //  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0)),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  } else {
                    singleMarkerObject = value;
                  }
                  //    return null;
                },
              ),
            ),
          ),
          SizedBox.fromSize(
            size: Size(24, 24), // buton width and height
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.blue[600], // splash color
                onTap: () async {
                  if (_formKey.currentState.validate()) {
                    print(singleMarkerObject);
                    String url =
                        "https://spobber.azurewebsites.net/api/objects/$singleMarkerObject";
                    print(url);
                    final response = await http.get(url);
                    fillMarkerList(response).then((value) {
                      print(singleMarker[0].type.runtimeType);
                      print(singleMarker[0].objectUri.runtimeType);
                      print(singleMarker[0].id.runtimeType);
                      print(singleMarker[0].secretId.runtimeType);
                      if (value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MarkerTemplate(
                              type: singleMarker[0].type,
                              objectUri: singleMarker[0].objectUri,
                              id: singleMarker[0].id,
                              secretId: singleMarker[0].secretId,
                            ),
                          ),
                        );
                      } else {
                        print("fuck off");
                      }
                    });
                    // Process data.
                  }
                }, // button pressed
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> fillMarkerList(http.Response response) async {
    setState(() {
     singleMarker.clear(); 
    });
    if (response.statusCode == 200) {
      // final data = json.decode(response.body);
      singleMarker = (json.decode(response.body) as List)
          .map((data) => new PlaceResponse().fromJson(data))
          .toList();
      return true;
    } else {
      print("url is niet gevonden");
      //throw Exception('An error occurred getting places nearby');
      return false;
    }
  }
}
