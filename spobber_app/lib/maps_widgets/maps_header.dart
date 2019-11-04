import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'maps_body.dart';
import 'search_filter.dart';
import '../helper/location_services.dart';
import 'package:provider/provider.dart';
import 'single_marker.dart';

// class GoogleMapsApp extends StatefulWidget {
//   static String tag = 'Maps';
//   @override
//   State<StatefulWidget> createState() {
//     return _GoogleMapsApp();
//   }
// }

class GoogleMapsApp extends StatelessWidget {
  static String keyword = "Es-las";
   static String tag = 'Maps';

  void updateKeyWord(String newKeyword) {
    print(newKeyword);
   // setState(() {
      keyword = newKeyword;
  //  });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocation>(
      builder: (context) => LocationService().locationStream,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        // title: 'Spobber',
        // home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          // iconTheme: IconThemeData(color: Colors.white),
          elevation: 4,
          // backgroundColor: Colors.blue,
          // centerTitle: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              // Box decoration takes a gradient
              gradient: LinearGradient(
                // Where the linear gradient begins and ends
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                // Add one stop for each color. Stops should increase from 0 to 1
                stops: [0.1, 0.9],
                colors: [
                  // Colors are easy thanks to Flutter's Colors class.
                  Color(0xff004990),
                  Color(0xff0066C6),
                ],
              ),
            ),
          ),
          title: Container(
            alignment: Alignment.center,
            // color: Theme.of(context).primaryColor,           
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
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, top: 6),
                      child: Text(
                        "U zoekt op: $keyword",
                        style: TextStyle(fontSize: 15.0, color: Colors.black),
                      ),
                    ),
                  ),
               
              ],
            ),
          ),
          bottom: PreferredSize(
            child: Container(
              padding: EdgeInsets.only(left: 50, bottom: 20),
              alignment: Alignment.center,
              // color: Theme.of(context).primaryColor,
           //   constraints: BoxConstraints.expand(height: 50),
              child: SingleMarker(),        
            ),
            preferredSize: Size(50, 50),
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
    child: Container(color: Colors.white,child: Column(
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
                      maxWidth: 44,
                      maxHeight: 44,
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
                      'Versie 2.0.4',
                      style: TextStyle(fontWeight: FontWeight.w200),
                    ))
                  ],
                ))))
      ],
    ),
  ),);
}
