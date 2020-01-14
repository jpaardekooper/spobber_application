import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:spobber/data/global_variable.dart';
import 'package:spobber/pages/history_view.dart';
import 'package:spobber/pages/tflite/home.dart';
import 'package:spobber/pages/widgets/page.dart';
import 'add_object.dart';

// //Represents the Homepage widget
// class DrawerFilter extends StatefulWidget {
//   //`createState()` will create the mutable state for this widget at
//   //a given location in the tree.
//   @override
//   _DrawerFilter createState() => _DrawerFilter();
// }

// //Our Home state, the logic and internal state for a StatefulWidget.
// class _DrawerFilter extends State<DrawerFilter> {
//   //A controller for an editable text field.
//   //Whenever the user modifies a text field with an associated
//   //TextEditingController, the text field updates value and the
//   //controller notifies its listeners.
//   var _searchview = new TextEditingController();

//   bool _firstSearch = true;
//   String _query = "";

//   List<String> _nebulae;
//   List<String> _filterList;

//   @override
//   void initState() {
//     super.initState();
//     _nebulae = new List<String>();
//     _nebulae = [
//       'Lijmlas Edilon-NS',
//       'Lijmlas Edilon-TC',
//       'Lijmlas BWG-S',
//       'Lijmlas BWG-S versterkt',
//       'Lijmlas Kloos HB600',
//       'Lijmlas Kloos HB480',
//       'Lijmlas ETS PF1/BN2 - oud',
//       'Lijmlas ETS PF1/BN2 - nieuw',
//       'Geconstr. las NS',
//       'Geconstr. las Tenconi-4 gats',
//       'Geconstr. las Tenconi-6 gats',
//       'Geconstr. las Exel',
//       'Geconstr. las BWG-MT',
//       'Geconstr. las BWG-MT versterkt',
//       'Lijmlas type onbekend',
//       'Geconstr. las type onbekend',
//       'Lijmlas Railpro-HIRD'
//     ];
//     _nebulae.sort();
//   }

//   _DrawerFilter() {
//     //Register a closure to be called when the object changes.
//     _searchview.addListener(() {
//       if (_searchview.text.isEmpty) {
//         //Notify the framework that the internal state of this object has changed.
//         setState(() {
//           _firstSearch = true;
//           _query = "";
//         });
//       } else {
//         setState(() {
//           _firstSearch = false;
//           _query = _searchview.text;
//         });
//       }
//     });
//   }

// //Build our Home widget
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(child: Drawer(child:
//       new Container(
//         color: Colors.white,
//         padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
//         child: new Column(
//           children: <Widget>[
//             _createSearchView(),
//             _firstSearch ? _createListView() : _performSearch()
//           ],
//         ),
//       ),
//     ));
//   }

//   //Create a SearchView
//   Widget _createSearchView() {
//     return new Container(
//       decoration: BoxDecoration(border: Border.all(width: 1.0)),
//       child: new TextField(
//         controller: _searchview,
//         decoration: InputDecoration(
//           hintText: "Zoeken naar..",
//           hintStyle: new TextStyle(color: Colors.grey[300]),
//         ),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }

//   //Create a ListView widget
//   Widget _createListView() {
//     return new Flexible(
//       child: new ListView.builder(
//           itemCount: _nebulae.length,
//           itemBuilder: (BuildContext context, int index) {
//             return new GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     searchObject = _nebulae[index];
//                     print(searchObject);
//                   });
//                 },
//                 child: new Card(
//                   color: Colors.white,
//                   elevation: 5.0,
//                   child: new Container(
//                     margin: EdgeInsets.all(15.0),
//                     child: new Text("${_nebulae[index]}"),
//                   ),
//                 ));
//           }),
//     );
//   }

//   //Perform actual search
//   Widget _performSearch() {
//     _filterList = new List<String>();
//     for (int i = 0; i < _nebulae.length; i++) {
//       var item = _nebulae[i];

//       if (item.toLowerCase().contains(_query.toLowerCase())) {
//         _filterList.add(item);
//       }
//     }
//     return _createFilteredListView();
//   }

//   //Create the Filtered ListView
//   Widget _createFilteredListView() {
//     return new Flexible(
//       child: new ListView.builder(
//           itemCount: _filterList.length,
//           itemBuilder: (BuildContext context, int index) {
//             return GestureDetector(
//               onTap: () {
//                 setState(() {
//                   searchObject = _filterList[index];
//                   print(searchObject);
//                 });
//               },
//               child: new Card(
//                 color: Colors.white,
//                 elevation: 5.0,
//                 child: new Container(
//                   margin: EdgeInsets.all(15.0),
//                   child: new Text("${_filterList[index]}"),
//                 ),
//               ),
//             );
//           }),
//     );
//   }
// }
class DrawerFilter extends StatefulWidget {
  @override
  _DrawerFilter createState() => _DrawerFilter();
}

class _DrawerFilter extends State<DrawerFilter> {
  bool showUserDetails = false;
  List<CameraDescription> cameras;
  Widget _buildDrawerList() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("Nieuw Object toevoegen"),
          // subtitle: Text("-"),
          leading: Icon(Icons.add),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).accentColor,
            size: 18,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => (PlaceMarkerBody()),
              ),
            );
          },
        ),
        ListTile(
          title: Text("TensorFlow"),
          //subtitle: Text("-"),
          leading: Icon(Icons.camera_alt),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).accentColor,
            size: 18,
          ),
          onTap: () async {
            try {
              cameras = await availableCameras();
            } on CameraException catch (e) {
              print('Error: $e.code\nError Message: $e.message');
            }

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => (HomePage(cameras)),
                ));
          },
        ),
        ListTile(
          title: Text("Geschiedenis:"),
          // subtitle: Text("date"),
          leading: Icon(Icons.history),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).accentColor,
            size: 18,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryView()),
            );
          },
        ),
        ListTile(
          title: Text("Info:"),
          //  subtitle: Text("date"),
          leading: Icon(Icons.info),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).accentColor,
            size: 18,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TutorialSpot()),
            );
          },
        ),
        Divider(),
        ListTile(
          title: Text('Versie 3.0.1'),
          enabled: false,
          leading: Icon(Icons.system_update),
        )
      ],
    );
  }

  Widget _buildUserDetail() {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          ListTile(
            title: Text("User details"),
            leading: Icon(Icons.info_outline),
          ),
          Divider(),
          ListTile(
            title: Text("Device"),
            subtitle: Theme.of(context).platform == TargetPlatform.iOS
                ? Text("IOS Device")
                : Text("Android Device"),
            leading: Icon(Icons.device_unknown),
          ),
          ListTile(
            title: Text("Account is gemaakt op:"),
            subtitle: Text("date"),
            leading: Icon(Icons.question_answer),
          ),
          Divider(),
          ListTile(
            title: Text("Uitloggen"),
            //  leading: Icon(Icons.settings_power),
            trailing: Icon(
              Icons.settings_power,
              color: Colors.red,
            ),
            onTap: () {
              print("Uitgelogd");
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        UserAccountsDrawerHeader(
          margin: EdgeInsets.all(0),
          accountName: Text(userInformation.username),
          accountEmail: Text(userInformation.email),
          onDetailsPressed: () {
            setState(() {
              showUserDetails = !showUserDetails;
            });
          },
          currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? Text("I", style: TextStyle(fontSize: 40.0))
                  : Text("A", style: TextStyle(fontSize: 40.0))),
        ),
        Expanded(
            child: showUserDetails ? _buildUserDetail() : _buildDrawerList())
      ]),
    );
  }
}
