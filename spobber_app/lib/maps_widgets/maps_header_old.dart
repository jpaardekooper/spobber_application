

// class GoogleMapsApp extends StatefulWidget {
//   static String tag = 'Maps';
//   @override
//   State<StatefulWidget> createState() {
//     return _GoogleMapsApp();
//   }
// }

// class _GoogleMapsApp extends State<GoogleMapsApp> {
//   //static String keyword = "Es-las";

//   // void updateKeyWord(String newKeyword) {
//   //   print(newKeyword);
//   //   // setState(() {
//   //   keyword = newKeyword;
//   //   //  });
//   // }

//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<UserLocation>(
//       builder: (context) => LocationService().locationStream,
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         // resizeToAvoidBottomPadding: false,
//         key: _scaffoldKey,
//         // title: 'Spobber',
//         // home: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(100),
//           child: AppBar(
//             centerTitle: true,
//             // iconTheme: IconThemeData(color: Colors.white),
//             elevation: 4,
//             // backgroundColor: Colors.blue,
//             // centerTitle: false,
//             flexibleSpace: Container(
//                 decoration: BoxDecoration(
//                   // Box decoration takes a gradient
//                   gradient: LinearGradient(
//                     // Where the linear gradient begins and ends
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     // Add one stop for each color. Stops should increase from 0 to 1
//                     stops: [0.5, 0.9],
//                     colors: [
//                       // Colors are easy thanks to Flutter's Colors class.
//                       Color(0xff0066C6),
//                       Color(0xff004990),
//                     ],
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   //     crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.max,
//                   children: <Widget>[
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         SingleObject(),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[SingleMarker()],
//                     ),
//                     // SingleObject(),
//                     // SingleMarker()
//                   ],
//                 )),
//           ),
//         ),

//     //    drawer: DrawerView(),
//         //_buildDrawer(context),
//         body: MyLocationView(),
//         //PlacesSearchMapSample(),
//         //  endDrawer: SearchFilter(updateKeyWord),
//         //    endDrawer: ObjectFilter(),
//         //     ),
//       ),
//     );
//   }
// }

// Widget _buildDrawer(context) {
//   return Drawer(
//     // column holds all the widgets in the drawer
//     child: Container(
//       color: Colors.white,
//       child: Column(
//         children: <Widget>[
//           Expanded(
//             // ListView contains a group of widgets that scroll inside the drawer
//             child: ListView(
//               children: <Widget>[
//                 //         UserAccountsDrawerHeader(),
//                 ListTile(
//                     title: Text(
//                       "Spobber",
//                       style: TextStyle(fontSize: 30),
//                     ),
//                     leading: ConstrainedBox(
//                       constraints: BoxConstraints(
//                         minWidth: 44,
//                         minHeight: 44,
//                         maxWidth: 44,
//                         maxHeight: 44,
//                       ),
//                       child: Image.asset('assets/ic_launcher.jpg'),
//                     )),
//                 Divider(),

//                 // ListTile(
//                 //   leading: Icon(Icons.map),
//                 //   title: Text('Maps'),
//                 //   onTap: () {
//                 //     // Update the state of the app
//                 //     // ...
//                 //     // Then close the drawer
//                 //     Navigator.pop(context);
//                 //   },
//                 // ),
//                 // Divider(),
//                 // ListTile(
//                 //   leading: Icon(Icons.show_chart),
//                 //   title: Text('Statistiek'),
//                 //   onTap: () {
//                 //     // Update the state of the app
//                 //     // ...
//                 //     // Then close the drawer
//                 //     print("pressed item 2");
//                 //     // Navigator.pop(context);
//                 //     //  showModalBottomSheet<void>(
//                 //     //       context: context,
//                 //     //       builder: (BuildContext context) {
//                 //     //         return BottomSheetSwitch(
//                 //     //           switchValue: switchValue1,
//                 //     //           valueChanged: (value) {
//                 //     //             switchValue1 = value;
//                 //     //           },
//                 //     //         );
//                 //     //       },
//                 //     //  );
//                 //   },
//                 // ),
//                 // Divider(),
//                 // ListTile(
//                 //   leading: Icon(Icons.history),
//                 //   title: Text('Geschiedenis'),
//                 //   onTap: () {
//                 //     // Update the state of the app
//                 //     // ...
//                 //     // Then close the drawer
//                 //     // Navigator.pop(context);
//                 //     //        showDialog<void>(
//                 //     //   context: context,
//                 //     //   builder: (BuildContext context) {
//                 //     //     return BottomSheetSwitch2(
//                 //     //       switchValue: switchValue2,
//                 //     //                   valueChanged: (value) {
//                 //     //                     switchValue2 = value;
//                 //     //                   },

//                 //     //     );
//                 //     //   },
//                 //     // );
//                 //   },
//                 // ),
//                 // Divider(),
//                 // ListTile(
//                 //   leading: Icon(Icons.settings),
//                 //   title: Text('Account'),
//                 //   onTap: () {
//                 //     // Update the state of the app
//                 //     // ...
//                 //     // Then close the drawer
//                 //     print("pressed item 2");
//                 //     Navigator.pop(context);
//                 //   },
//                 // ),
//                 // Divider(),
//               ],
//             ),
//           ),
//           // This container holds the align
//           Container(
//             // This align moves the children to the bottom
//             child: Align(
//               alignment: FractionalOffset.bottomCenter,
//               // This container holds all the children that will be aligned
//               // on the bottom and should not scroll with the above ListView
//               child: Container(
//                 child: Column(
//                   children: <Widget>[
//                     Divider(),
//                     ListTile(
//                         leading: Icon(Icons.settings), title: Text('Settings')),
//                     ListTile(
//                         leading: Icon(Icons.help),
//                         title: Text('Help and Feedback')),
//                     ListTile(
//                         //leading: Icon(Icons.help),
//                         title: Text(
//                       'Versie 2.0.4',
//                       style: TextStyle(fontWeight: FontWeight.w200),
//                     ))
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
