import 'package:camera/new/camera.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_map/flutter_map.dart';
//import 'package:latlong/latlong.dart';
import 'package:spobber/pages/marker_information/marker_template.dart';
//import '../fix/bottom_sheet_fix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SingleDropDown.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class SearchSingleMarker extends StatefulWidget {
  double lat = 0.00;
  double long = 0.00;
  static double favoriteLat;
  static double favoriteLong;
  static bool isFavorite = false;
  static String favoritePlaceName = "Favorite Place";
  static String locationImage;

  @override
  _SearchSingleMarkerState createState() => _SearchSingleMarkerState(lat, long);
}

class _SearchSingleMarkerState extends State<SearchSingleMarker> {
  //changes after declaring the desired location
  Widget _searchView;
  double lat;
  double long;
  String placeName = SearchSingleMarker.favoritePlaceName;
  String placePosition = "";
  final myController = TextEditingController();
  final favoritePlaceController = TextEditingController();

  // Constructor
  _SearchSingleMarkerState(double long, double lat) {
    this.lat = lat;
    this.long = long;
  }
  // _favoritePlaces(String oldPlaceName, double lat, double long) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   /// get the favorite position then added to prefs
  //   placeName = favoritePlaceController.text;

  //   ///convert position to string and concat it
  //   placePosition = lat.toString() +
  //       ',' +
  //       long.toString() +
  //       ',' +
  //       SingleDropDown.currentImage.toString();
  //   print('Place Name $placeName => $placePosition Captured.');
  //   await prefs.setString(
  //     '$placeName',
  //     '$placePosition',
  //   );
  //   if (oldPlaceName != placeName) {
  //     ///remove old record
  //     prefs.remove(oldPlaceName);
  //   }
  // }

  // //declaring Bottom sheet widget
  // Widget buildSheetLogin(BuildContext context) {
  //   favoritePlaceController.text = placeName;
  //   return new Container(
  //     child: Wrap(children: <Widget>[
  //       Container(
  //         padding: new EdgeInsets.only(left: 10.0, top: 10.0),
  //         width: MediaQuery.of(context).size.width / 1.7,
  //         child: Form(
  //           key: _formKey,
  //           child: TextFormField(
  //             controller: favoritePlaceController,
  //             validator: (String val) {
  //               if (val.length == 0) {
  //                 return 'Empty Name';
  //               }
  //               return null;
  //             },
  //             decoration: InputDecoration(
  //               border: OutlineInputBorder(
  //                   borderSide: BorderSide(color: Colors.black)),

  //               /// focused border color (erasing theme default color [teal])
  //               focusedBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.all(Radius.circular(5.0)),
  //                   borderSide: BorderSide(color: Colors.black)),

  //               /// Display Old PlaceName Value
  //               labelText: "$placeName",
  //               prefixIcon: Icon(
  //                 Icons.save_alt,
  //                 color: Theme.of(context).primaryColor,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //       Container(child: SingleDropDown()),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: <Widget>[
  //           Padding(
  //             padding: const EdgeInsets.only(right: 8.0),
  //             child: RaisedButton(
  //               color: Theme.of(context).primaryColor,
  //               textColor: Colors.white,
  //               child: Text("Save"),
  //               onPressed: () {
  //                 if (_formKey.currentState.validate()) {
  //                   _favoritePlaces(placeName, SearchSingleMarker.favoriteLat,
  //                       SearchSingleMarker.favoriteLong);
  //                   Navigator.pop(context);
  //                 }
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     ]),
  //   );
  // }

  

MapType mapType = MapType.normal;

  Widget _mapTypeCycler() {
    final MapType nextType = MapType.values[mapType.index == 2 ? 1 : 2];

    return Padding(
      padding: EdgeInsets.fromLTRB(12, 10, 0, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox.fromSize(
          size: Size(37, 37), // button width and height
          child: ClipRect(
            child: Container(
              decoration: new BoxDecoration(
                color: Color.fromRGBO(51, 216, 178, 1),
                borderRadius: BorderRadius.circular(5),
              ),
              // button color
              child: InkWell(
                splashColor: const Color(0xff004990), // splash color
                onTap: () {
                  setState(() {
                    mapType = nextType;
              
                  });
                }, // button pressed
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.map, color: Colors.white, size: 20), // icon
                    // Text("Call"), // text
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Set<Marker> markers = Set();

  addnewMarker(double lat, double long) {        
    Marker resultMarker = Marker(
        markerId: MarkerId("singleMarker[0].id.toString()"),
        infoWindow: InfoWindow(
            title:  widget.key.toString(),
            snippet: placeName,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MarkerTemplate(
                    type: "singleMarker[0].type",
                    objectUri: "singleMarker[0].objectUri",
                    id: "singleMarker[0].id.toString()",
                    secretId: "singleMarker[0].secretId",
                  ),
                ),
              );
            }),
        position: LatLng(lat, long));

    markers.add(resultMarker);
  }

  _searchedLocation(double lat, double long) {
 
    if (SearchSingleMarker.isFavorite == true) {
      lat = SearchSingleMarker.favoriteLat;
      long = SearchSingleMarker.favoriteLong;

      addnewMarker(lat, long);
      SearchSingleMarker.isFavorite = false;
     // _searchView = 
    }
    return _searchView;
  }
    GoogleMapController controller;
  void _onMapCreated(GoogleMapController mapController) async {
    controller = mapController;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey3 = new GlobalKey<ScaffoldState>();

 // final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {    
    _searchedLocation(this.lat, this.long);
    return  Scaffold(
        backgroundColor: Theme.of(context).primaryColor,        
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text("Marker $placeName"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        //  drawer: HistoryView(),
        body: Stack(
        children: <Widget>[
          GoogleMap(
            key: _scaffoldKey3,
            mapType: mapType,
            markers: markers,
            initialCameraPosition: CameraPosition(target: LatLng(lat, long), zoom: 15),
            onMapCreated: _onMapCreated,
            mapToolbarEnabled: false,
          ),
          _mapTypeCycler()
        ],
      ),

      );
    
  }
}
