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
import 'dart:ui' as prefix1;

import 'package:flutter/material.dart' as prefix0;
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as prefix2;

import 'dart:async';

import 'dart:ui';
import 'dart:math' show cos, sqrt, asin;
import 'dart:convert';
import 'data/error.dart';
import 'data/place_response.dart';
import 'data/result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:location_permissions/location_permissions.dart';
import 'Object_info/marker_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'data/marker_detail.dart';

class PlacesSearchMapSample extends StatefulWidget {
  final String keyword;
  PlacesSearchMapSample(this.keyword);

  @override
  State<PlacesSearchMapSample> createState() {
    return _PlacesSearchMapSample();
  }
}

typedef Marker MarkerUpdateAction(Marker marker);

class _PlacesSearchMapSample extends State<PlacesSearchMapSample> {
  LocationData currentLocation;

  bool currentWidget = true;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;

  @override
  void initState() {
    super.initState();

    _getLocation();
  }

  //When clicked function is performed on a marker

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        // if (markers.containsKey(selectedMarker)) {
        //   final Marker resetOld = markers[selectedMarker]
        //       .copyWith(iconParam: BitmapDescriptor.defaultMarker);
        //   markers[selectedMarker] = resetOld;
        // }
        selectedMarker = markerId;
        // final Marker newMarker = tappedMarker.copyWith(
        //   iconParam: BitmapDescriptor.defaultMarkerWithHue(
        //     BitmapDescriptor.hueGreen,
        //   ),
        // );
        // markers[markerId] = newMarker;
      });
    }
  }

  //   void _onNewMarkerTapped(MarkerId markerId) {
  //   final Marker tappedMarker = markers[markerId];
  //   if (tappedMarker != null) {
  //     setState(() {
  //       selectedMarker = markerId;
  //     });
  //   }
  // }

  void _add() {
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }

    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(currentLocation.latitude, currentLocation.longitude),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*', onTap: () {}),
      onTap: () {
        // _onMarkerTapped(markerId);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MarkerTemplate(
                      markerDetail: new MarkerDetail(
                    markerId.toString(),
                    widget.keyword,
                    currentLocation.latitude.toString(),
                    currentLocation.longitude.toString(),
                    "-",
                    "-",
                    "-",
                  ))),
        );
      },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  _getLocation() async {
    PermissionStatus permission =
        await LocationPermissions().requestPermissions();
    print(permission);
    var location = new Location();
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: prefix2.LocationAccuracy.best);
    try {
      currentLocation = await location.getLocation();
      if (position != null) {
        setState(() {
          print(_loading);

          _loading = false;
          print(_loading);
        });
      }

      print(geolocationStatus);

      //rebuild the widget after getting the current location of the user
    } on PlatformException {
      currentLocation = null;
    }
  }

  //static const String _API_KEY = 'AIzaSyB-lQhSEggPBYQlqxxtie9otYVzU53X6is';

  static double latitude = 52.051968;
  static double longitude = 4.5121536;
  // static const String baseUrl =
  //     "https://maps.googleapis.com/maps/api/place/nearbysearch/json";

  String baseUrl =
      "https://spobberapi20190919041857.azurewebsites.net/api/objects/?nelatitude=${_visibleRegion.northeast.latitude}&swlatitude=${_visibleRegion.southwest.latitude}&nelongitude=${_visibleRegion.northeast.longitude}&swlongitude=${_visibleRegion.southwest.longitude}";

  List<Marker> markers2 = <Marker>[];
  Error error;
  List<PlaceResponse> places;
  bool searching = true;
  String keyword;

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _myLocation = CameraPosition(
      target: LatLng(latitude, longitude), zoom: 15, bearing: 0.0, tilt: 0.0);

  // void _setStyle(GoogleMapController controller) async {
  //   String value = await DefaultAssetBundle.of(context)
  //       .loadString('assets/maps_style.json');
  //   controller.setMapStyle(value);
  // }

  void searchNearby() async {
    print(_visibleRegion.southwest.latitude);
    print(_visibleRegion.southwest.longitude);
    print(_visibleRegion.northeast.latitude);
    print(_visibleRegion.northeast.longitude);
    setState(() {
      markers.clear();
      formWidget.clear();
    });
    String url =
        "https://spobberapi20190919041857.azurewebsites.net/api/objects/?nelatitude=${_visibleRegion.northeast.latitude}&swlatitude=${_visibleRegion.southwest.latitude}&nelongitude=${_visibleRegion.northeast.longitude}&swlongitude=${_visibleRegion.southwest.longitude}";
    ;
    print(url);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // final data = json.decode(response.body);
      places = (json.decode(response.body) as List)
          .map((data) => new PlaceResponse().fromJson(data))
          .toList();
      _handleResponse(places);
    } else {
      //throw Exception('An error occurred getting places nearby');
    }

    // make sure to hide searching
    setState(() {
      searching = false;
    });
  }

  MapType _mapType = MapType.satellite;
  Widget _mapTypeCycler() {
    final MapType nextType =
        MapType.values[(_mapType.index + 1) % MapType.values.length];

    return Padding(
        padding: EdgeInsets.fromLTRB(10, 50, 10, 50),
        child: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              color: Colors.white,
              icon: Icon(Icons.map),
              onPressed: () {
                setState(() {
                  _mapType = nextType;
                  print("test");
                });
              },
            )));
  }

  void _handleResponse(List data) {
    setState(() {
      for (int i = 0; i < places.length; i++) {
        MarkerId markerId = MarkerId(places[i].id.toString());
        Marker marker = Marker(
          markerId: MarkerId(places[i].id.toString()),
          icon: BitmapDescriptor.fromAsset('assets/marker.png'),
          position: LatLng(places[i].latitude, places[i].longitude),
          infoWindow: InfoWindow(
              title: places[i].type,
              snippet: "lat: " +
                  places[i].latitude.toString() +
                  " long: " +
                  places[i].longitude.toString(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MarkerTemplate(
                              markerDetail: new MarkerDetail(
                            places[i].id.toString(),
                            places[i].type.toString(),
                            places[i].latitude.toString(),
                            places[i].longitude.toString(),
                            places[i].status.toString(),
                            places[i].preview_image_uri.toString(),
                            places[i].object_uri.toString(),
                          ))),
                );
              }),
          onTap: () {
            _onMarkerTapped(markerId);
          },
        );
        getFormWidget(
            places[i].id.toString(),
            places[i].type,
            places[i].status.toString(),
            places[i].preview_image_uri,
            places[i].object_uri,
            places[i].latitude,
            places[i].longitude,
            markerId);

        setState(() {
          markers[markerId] = marker;
        });
      }
    });
    // } else {
    //   print(data);
    // }
  }

//widget building

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          // _setStyle(controller);
          _controller.complete(controller);
        },
        mapType: _mapType,
        initialCameraPosition: _myLocation,
        compassEnabled: true,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        markers: Set<Marker>.of(markers.values),
        circles: Set<Circle>.of(circles.values),
      ),
    );
  }

  Widget _buildContainer() {
    if (formWidget.length <= 0) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          height: 150.0,
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              child: new FittedBox(
                child: Material(
                    color: Colors.white,
                    elevation: 14.0,
                    borderRadius: BorderRadius.circular(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 200,
                          height: 200,
                          child: ClipRRect(
                            borderRadius: new BorderRadius.circular(5.0),
                            child: Image(
                              fit: BoxFit.fitHeight,
                              image: AssetImage("assets/location-loader.gif"),
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Container(
                                        child: Text(
                                      "Er zijn geen objecten gevonden",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                  SizedBox(height: 5.0),
                                  Container(
                                      child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                          child: Text(
                                        "(huidige locatie)",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 18.0,
                                        ),
                                      )),
                                    ],
                                  )),
                                  SizedBox(height: 5.0),
                                  Container(
                                      child: Text(
                                    "Latitude: " +
                                        currentLocation.latitude.toString(),
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                  SizedBox(height: 5.0),
                                  Container(
                                      child: Text(
                                    "Longitude: " +
                                        currentLocation.longitude.toString(),
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ],
                              )),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          height: 150.0,
          child:
              ListView(scrollDirection: Axis.horizontal, children: formWidget),
        ),
      );
    }
  }

  List<Widget> formWidget = new List();

  getFormWidget(String id, String type, String status, String imgurl,
      String imginfo, double lat, double long, MarkerId markerid) {
    formWidget.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: _boxes(id, type, status, imgurl, imginfo, lat, long, markerid),
      ),
    );
  }

  Widget _boxes(String id, String type, String status, String imgurl,
      String imginfo, double lat, double long, MarkerId markerid) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat, long);
        _onMarkerTapped(markerid);
      },
      child: Container(
        child: new FittedBox(
          child: Material(
              color: Colors.white,
              //elevation: 14.0,
              borderRadius: BorderRadius.circular(5.0),
              // shadowColor: Color(0x802196F3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(5.0),
                      child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(imgurl),
                      ),
                      // child: Image(
                      //   fit: BoxFit.fill,
                      //   image: AssetImage("assets/spoor.jpg"),
                      // ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: myDetailsContainer1(
                          id, type, status, imginfo, lat, long),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget myDetailsContainer1(String id, String type, String status,
      String imginfo, double lat, double long) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
              child: Text(
            type,
            style: TextStyle(
                color: Colors.blue,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(height: 5.0),
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                child: Text(
              status,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStarHalf,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            // Container(
            //     child: Text(
            //   "(946)",
            //   style: TextStyle(
            //     color: Colors.black54,
            //     fontSize: 18.0,
            //   ),
            // )),
          ],
        )),
        SizedBox(height: 5.0),
        Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
              Container(
                  child: Text(
                "Afstand ",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                ),
              )),
              Container(
                  child: Text(
                calculateDistance(lat, long, currentLocation.latitude,
                        currentLocation.longitude) +
                    " km",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                ),
              )),
            ])),
        SizedBox(height: 5.0),
        Container(
            child: Text(
          "Id: " + id,
          style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        )),
      ],
    );
  }

  static LatLngBounds _visibleRegion = LatLngBounds(
    southwest: LatLng(0, 0),
    northeast: LatLng(0, 0),
  );

  bool _loading = true;
  @override
  Widget build(BuildContext context) {
    // print(_loading);
    //print(currentLocation.latitude);
    if (_loading) {
      return new Scaffold(
          body: Container(
        alignment: FractionalOffset.center,
        child: Image.asset('assets/result_data.png'),
      ));
    } else {
    return new Scaffold(
      body: Stack(
              children: <Widget>[
                _buildGoogleMap(context),
                // _zoomminusfunction(),
                // _zoomplusfunction(),
                _mapTypeCycler(),
                _buildContainer(),
              ],
            ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: () {
      //     _add();
      //   },
      // ),
      bottomNavigationBar: BottomAppBar(
        //shape: CircularNotchedRectangle(),
        //    notchMargin: 4.0,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 50.0,

              // color: Colors.black,
              child: FlatButton(
                onPressed: () async {
                  final GoogleMapController controller =
                      await _controller.future;
                  final LatLngBounds visibleRegion =
                      await controller.getVisibleRegion();

                  setState(() {
                    _visibleRegion = visibleRegion;
                  });

                  searchNearby();
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.refresh,
                      color: Colors.blue,
                    ),
                    Text(
                      'Zoeken',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50.0,
              child: FlatButton(
                onPressed: () async {
                  _add();
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.blue,
                    ),
                    Text(
                      'Object toevoegen',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50.0,
              child: FlatButton(
                onPressed: () {
                  _mapTypeCycler();
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.scanner,
                      color: Colors.blue,
                    ),
                    Text(
                      'Scannen',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    }
  }

  String calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

    var value = 12742 * asin(sqrt(a));
    return value.toStringAsFixed(3);
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 18,
      // tilt: 50.0,
      // bearing: 45.0,
    )));

    _add2(lat, long);
  }

  Map<CircleId, Circle> circles = <CircleId, Circle>{};
  int _circleIdCounter = 1;
  CircleId selectedCircle;

  void _onCircleTapped(CircleId circleId) {
    setState(() {
      selectedCircle = circleId;
      _remove();
    });
  }

  void _remove() {
    setState(() {
      circles.clear();
      if (circles.containsKey(selectedCircle)) {
        circles.remove(selectedCircle);
      }
      selectedCircle = null;
    });
  }

  void _add2(double lat, double long) {
    final int circleCount = circles.length;

    if (circleCount == 12) {
      return;
    }

    final String circleIdVal = 'circle_id_$_circleIdCounter';
    _circleIdCounter++;
    final CircleId circleId = CircleId(circleIdVal);

    final Circle circle = Circle(
      circleId: circleId,
      consumeTapEvents: true,
      strokeColor: Colors.red,
      fillColor: Colors.red[100].withOpacity(0.1),
      strokeWidth: 2,
      center: LatLng(lat, long),
      radius: 2,
      onTap: () {
        _onCircleTapped(circleId);
      },
    );

    setState(() {
      circles[circleId] = circle;
    });
  }

  // LatLng _createCenter() {
  //   final double offset = _circleIdCounter.ceilToDouble();
  //   return _createLatLng(51.4816 + offset * 0.2, -3.1791);
  // }

  // LatLng _createLatLng(double lat, double lng) {
  //   return LatLng(lat, lng);
  // }
}
