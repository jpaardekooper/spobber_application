import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:latlong/latlong.dart';
import 'package:spobber/clustering/clustering_helper.dart';

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:spobber/data/place_response.dart';
import 'package:spobber/pages/marker_information/marker_template.dart';
import 'package:http/http.dart' as http;
import '../data/global_variable.dart';
import 'dart:async';
import '../data/place_response.dart';
import 'package:toast/toast.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  //to retrieve position from TextField
  final myController = TextEditingController();
  final favoritePlaceController = TextEditingController();

  ClusteringHelper clusteringHelper;

  ///changes after declaring the desired location
  // Widget _searchView;
  double lat = 0.00;
  double long = 0.00;
  bool _empty = false;
  String placeName = "";
  String placePosition = "";

  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  Set<Marker> markers = Set();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(singleMarker[0].latitude, singleMarker[0].longitude),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    if ((lat == 0.00 || long == 0.00))
    //&& SearchSingleMarker.isFavorite == false )
    {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.black,
                    controller: myController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(
                        Icons.location_searching,
                        //      color: Colors.teal,
                      ),

                      //border color
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      // focused border color (erasing theme default color [teal])
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.black)),
                      errorText: _empty ? 'Invalid Position' : null,
                      hintText: 'Enter Latitude,Longitude or ID',
                      hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
                    ),
                    style: TextStyle(fontSize: 20.00, color: Colors.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Text("Search"),
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                      onPressed: () async {
                        myController.text.isEmpty
                            ? _empty = true
                            : _empty = false;

                        //TexField not empty
                        if (_empty == false) {
                          singleMarker.clear();
                          String url =
                              "https://spobber.azurewebsites.net/api/objects/${myController.text}";
                          print(url);
                          final response = await http.get(url);
                          fillMarkerList(response).then((value) {
                            if (value) {
                              if (singleMarker.first.id == 0) {
                                showToast("Geen geldige equipment gevonden",
                                    gravity: Toast.CENTER,
                                    duration: Toast.LENGTH_LONG);
                              } else {
                                // showToast(
                                //     "Object id: ${myController.text} wordt geladen",
                                //     gravity: Toast.CENTER,
                                //     duration: Toast.LENGTH_SHORT);

                                setState(() {
                                  this.lat = singleMarker[0].latitude;
                                  this.long = singleMarker[0].longitude;
                                });

                                addnewMarker();
                              }
                            }
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          GoogleMap(
            key: _scaffoldKey2,
            mapType: mapType,
            markers: markers,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: _onMapCreated,
            mapToolbarEnabled: false,
          ),
          _mapTypeCycler()
        ],
      );
    }
  }

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

  final GlobalKey<ScaffoldState> _scaffoldKey2 = new GlobalKey<ScaffoldState>();
  addnewMarker() {
    Marker resultMarker = Marker(
        markerId: MarkerId(singleMarker[0].id.toString()),
        infoWindow: InfoWindow(
            title: singleMarker[0].id.toString(),
            snippet: singleMarker[0].secretId.toString(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MarkerTemplate(
                    type: singleMarker[0].type,
                    objectUri: singleMarker[0].objectUri,
                    id: singleMarker[0].id.toString(),
                    secretId: singleMarker[0].secretId,
                  ),
                ),
              );
            }),
        position: LatLng(singleMarker[0].latitude, singleMarker[0].longitude));

    markers.add(resultMarker);
  }

  GoogleMapController controller;
  void _onMapCreated(GoogleMapController mapController) async {
    controller = mapController;
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
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
