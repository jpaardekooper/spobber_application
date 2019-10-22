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
import 'dart:io';

import 'package:flutter/material.dart' as prefix0;

import 'data/global_variable.dart';
import 'package:geolocator/geolocator.dart' as prefix2;
import 'package:spobber/search_filter.dart';

import 'dart:async';

import 'dart:ui';
import 'dart:math' show cos, sqrt, asin;
import 'dart:convert';

import 'data/place_response.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:location_permissions/location_permissions.dart';
import 'Object_info/marker_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'data/marker_detail.dart';
import 'data/upper_object.dart';

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
    prefix2.GeolocationStatus geolocationStatus =
        await prefix2.Geolocator().checkGeolocationPermissionStatus();
    prefix2.Position position = await prefix2.Geolocator()
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

  // String baseUrl =
  //     "https://spobberapi20190919041857.azurewebsites.net/api/objects/?nelatitude=${_visibleRegion.northeast.latitude}&swlatitude=${_visibleRegion.southwest.latitude}&nelongitude=${_visibleRegion.northeast.longitude}&swlongitude=${_visibleRegion.southwest.longitude}";

  List<Marker> markers2 = <Marker>[];

  List<PlaceResponse> places = new List<PlaceResponse>();

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

  void searchNearby(
      bool isSap, bool isSigma, bool isUST02, bool isVideo) async {
    print(_visibleRegion.southwest.latitude);
    print(_visibleRegion.southwest.longitude);
    print(_visibleRegion.northeast.latitude);
    print(_visibleRegion.northeast.longitude);
    setState(() {
      markers.clear();
      //  formWidget.clear();
      places.clear();
      polylines.clear();

      circles.clear();
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
        padding: EdgeInsets.fromLTRB(12, 70, 0, 0),
        child: Align(
            alignment: Alignment.topLeft,
            child: Container(
                alignment: Alignment.centerRight,
                width: 37,
                height: 37,
                color: Colors.white.withOpacity(0.7),
                child: IconButton(
                  color: Colors.black54,
                  icon: Icon(Icons.map),
                  onPressed: () {
                    setState(() {
                      _mapType = nextType;
                      print("test map");
                    });
                  },
                ))));
  }

  Widget _search() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 70, 12, 0),
        child: Align(
            alignment: Alignment.topRight,
            child: Container(
                width: 37,
                height: 37,
                color: Colors.white.withOpacity(0.7),
                child: IconButton(
                  color: Colors.black54,
                  icon: Icon(Icons.search),
                  // child: Text("test"),
                  onPressed: () async {
                    final GoogleMapController controller =
                        await _controller.future;
                    final LatLngBounds visibleRegion =
                        await controller.getVisibleRegion();

                    setState(() {
                      _visibleRegion = visibleRegion;
                    });
                    searchNearby(isSap, isSigma, isUST02, isVideo);
                  },
                ))));
  }

  Widget _addMarker() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 130, 12, 0),
        child: Align(
            alignment: Alignment.topRight,
            child: Container(
                alignment: Alignment.centerRight,
                width: 37,
                height: 37,
                color: Colors.white.withOpacity(0.7),
                child: IconButton(
                  color: Colors.black54,
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    _add();
                  },
                ))));
  }

  Widget _addPolyLine() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 190, 12, 0),
        child: Align(
            alignment: Alignment.topRight,
            child: Container(
                alignment: Alignment.centerRight,
                width: 37,
                height: 37,
                color: Colors.white.withOpacity(0.7),
                child: IconButton(
                  color: Colors.black54,
                  icon: Icon(Icons.linear_scale),
                  onPressed: () async {
                    loadPolyline();
//_add();
                  },
                ))));
  }

  List<LatLng> pointsRed = <LatLng>[];
  List<LatLng> pointsOrange = <LatLng>[];
  List<LatLng> pointsGreen = <LatLng>[];
  List<LatLng> pointsAll = <LatLng>[];

  Future loadPolyline() async {
    polylines.clear();
    pointsAll.clear();
    pointsOrange.clear();
    pointsGreen.clear();
    pointsRed.clear();

    // List<UpperObject> objects;
    String uri =
        "https://spobberapi20190919041857.azurewebsites.net/api/measure/?nlat=90&blat=-90&nlon=90&blon=-90";

    print(uri);
    
    final response = await http.get(Uri.encodeFull(uri));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      UpperObject upperObject = new UpperObject.fromJson(jsonResponse);
      print(upperObject.content.length);

      print(upperObject.id.toString());
      print(upperObject.content[6].latitude.toString());

      //List<Content> words = new List<Content>();
      // for (var word in jsonResponse['content']) {
      //   words.add(new Content());

      // }

      for (int i = 0; i < upperObject.content.length; i++) {
        print(upperObject.content[i].latitude);
        pointsAll.add(_createLatLng(
            upperObject.content[i].latitude, upperObject.content[i].longitude));

        if (upperObject.content[i].value < 1600) {
          pointsRed.add(_createLatLng(upperObject.content[i].latitude,
              upperObject.content[i].longitude));
        } else if (upperObject.content[i].value < 1800 &&
            upperObject.content[i].value >= 1600) {
          pointsOrange.add(_createLatLng(upperObject.content[i].latitude,
              upperObject.content[i].longitude));
        } else if (upperObject.content[i].value >= 1800) {
          pointsGreen.add(_createLatLng(upperObject.content[i].latitude,
              upperObject.content[i].longitude));
        }
      }
      final String polylineIdVal = 'polyline_id_ALL';
      final PolylineId polylineId = PolylineId(polylineIdVal);

      final Polyline polylineAll = Polyline(
        polylineId: polylineId,
        consumeTapEvents: true,
        color: Colors.blue,
        width: 5,
        points: pointsAll,
        zIndex: 0,
        onTap: () {
          _onPolylineTapped(polylineId);
        },
      );

      setState(() {
        polylines[polylineId] = polylineAll;
      });

      final String polylineIdValRed = 'polyline_id_Red';
      final PolylineId polylineIdRed = PolylineId(polylineIdValRed);

      final Polyline polylineRed = Polyline(
          polylineId: polylineIdRed,
          consumeTapEvents: false,
          color: Colors.red,
          width: 4,
          points: pointsRed,
          zIndex: 1);

      setState(() {
        polylines[polylineIdRed] = polylineRed;
      });

      final String polylineIdValOrange = 'polyline_id_Orange';
      final PolylineId polylineIdOrange = PolylineId(polylineIdValOrange);

      final Polyline polylineOrange = Polyline(
          polylineId: polylineIdOrange,
          consumeTapEvents: false,
          color: Colors.orange,
          width: 4,
          points: pointsOrange,
          zIndex: 2);

      setState(() {
        polylines[polylineIdOrange] = polylineOrange;
      });

      final String polylineIdValGreen = 'polyline_id_Green';
      final PolylineId polylineIdGreen = PolylineId(polylineIdValGreen);

      final Polyline polylineGreen = Polyline(
          polylineId: polylineIdGreen,
          consumeTapEvents: false,
          color: Colors.green,
          width: 4,
          points: pointsGreen,
          zIndex: 3);

      setState(() {
        polylines[polylineIdGreen] = polylineGreen;
      });
    }
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

  void _handleResponse(List data) {
    if(Platform.isIOS){
      _emptyList = false;
      for (int i = 0; i < places.length; i++) {
        MarkerId markerId = MarkerId(places[i].id.toString());
        Marker marker = Marker(
          markerId: MarkerId(places[i].id.toString()),
         // icon: BitmapDescriptor.fromAsset('assets/marker.png'),        
          icon: BitmapDescriptor.fromAsset('assets/2.0x/marker_yellow.png'),       
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

        setState(() {
          markers[markerId] = marker;
        });
      }
    }

    else if(Platform.isAndroid){
      _emptyList = false;
      for (int i = 0; i < places.length; i++) {
        MarkerId markerId = MarkerId(places[i].id.toString());
        Marker marker = Marker(
          markerId: MarkerId(places[i].id.toString()),
         // icon: BitmapDescriptor.fromAsset('assets/marker.png'),        
          icon: BitmapDescriptor.fromAsset('assets/2.0x/marker_yellow.png'),       
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

        setState(() {
          markers[markerId] = marker;
        });
      }
    }
    else{
      print("platform");
    }



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
          // if (controller == null) {
          //   _controller.complete(controller);
          // } else {
          //   print("Do nothing");
          // }
        },
        mapType: _mapType,
        initialCameraPosition: _myLocation,
        compassEnabled: true,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        markers: Set<Marker>.of(markers.values),
        circles: Set<Circle>.of(circles.values),
        polylines: Set<Polyline>.of(polylines.values),
      ),
    );
  }

  bool _emptyList = true;






  Widget _buildContainer() {
    return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.blue[100],
          padding: EdgeInsets.symmetric(vertical: 15.0),
          height: 175.0,
          //  child:  ListView(scrollDirection: Axis.horizontal, children: formWidget),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: places.length,
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      _onSelected(index);
                      _gotoLocation(
                          places[index].latitude, places[index].longitude);

                      Navigator.pop(context);
                      // _onMarkerTapped(places[index].);
                    },
                    // child: Container(
                    //   width: MediaQuery.of(context).size.width * 0.6,
                    //   child: Card(
                    //     color: _selectedIndex != null && _selectedIndex == index
                    //         ? Colors.red
                    //         : Colors.white,
                    //     child: Container(
                    //       child: Center(
                    //           child: Text(
                    //         places[index].id.toString(),
                    //         style: TextStyle(color: Colors.white, fontSize: 36.0),
                    //       )),
                    //     ),
                    child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Container(
                             color: Colors.white,
                          child: FittedBox(
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 5,
                                    color: _selectedIndex != null &&
                                            _selectedIndex == index
                                        ? Colors.red
                                        : Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ),

                                //elevation: 14.0,

                                //  borderRadius: BorderRadius.circular(5.0),
                                // shadowColor: Color(0x802196F3),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    // Container(
                                    //   width: 100,
                                    //   height: 150,
                                    //   child: ClipRRect(
                                    //     borderRadius:
                                    //         new BorderRadius.circular(5.0),
                                    //     child: Image(
                                    //       fit: BoxFit.fitHeight,
                                    //       image: NetworkImage(
                                    //           places[index].preview_image_uri),
                                    //     ),
                                    //     child: Image(
                                    //       fit: BoxFit.fill,
                                    //       image: AssetImage("assets/spoor.jpg"),
                                    //     ),
                                    //   ),
                                    // ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: myDetailsContainer1(
                                            places[index].id.toString(),
                                            places[index].type.toString(),
                                            places[index].status.toString(),
                                            places[index]
                                                .preview_image_uri
                                                .toString(),
                                            places[index].latitude,
                                            places[index].longitude),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        )),
                  )),
        ));

    //  }
  }

  int _selectedIndex = 0;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget myDetailsContainer1(String id, String type, String status,
      String imginfo, double lat, double long) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Padding(
        //   padding: const EdgeInsets.all(15.0),
        //   child:
        Container(
            child: Text(
          type,
          style: TextStyle(
              color: Colors.blue,
              fontSize: 20.0,
              fontWeight: FontWeight.normal),
        )),
     //   Divider(),
      SizedBox(height: 5.0),
        Container(
          child: Text("Equipment:", style: TextStyle(fontSize: 18.0,)),
        ),
        // ),
     
        // Container(
        //     child: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: <Widget>[
        //     Container(
        //         child: Text(
        //       "Status ",
        //       style: TextStyle(
        //         color: Colors.black54,
        //         fontSize: 18.0,
        //       ),
        //     )),
        //     Container(
        //       child: Icon(
        //         FontAwesomeIcons.solidStar,
        //         color: Colors.amber,
        //         size: 15.0,
        //       ),
        //     ),
        //     Container(
        //       child: Icon(
        //         FontAwesomeIcons.solidStar,
        //         color: Colors.amber,
        //         size: 15.0,
        //       ),
        //     ),
        //     Container(
        //       child: Icon(
        //         FontAwesomeIcons.solidStar,
        //         color: Colors.amber,
        //         size: 15.0,
        //       ),
        //     ),
        //     Container(
        //       child: Icon(
        //         FontAwesomeIcons.solidStar,
        //         color: Colors.amber,
        //         size: 15.0,
        //       ),
        //     ),
        //     Container(
        //       child: Icon(
        //         FontAwesomeIcons.solidStarHalf,
        //         color: Colors.amber,
        //         size: 15.0,
        //       ),
        //     ),
        //   ],
        // )),
        
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
    //print(_loading);
    //print(currentLocation.latitude);
    if (_loading) {
      return new Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      return Scaffold(
          body: Stack(
            children: <Widget>[
              _buildGoogleMap(context),

              // _zoomminusfunction(),
              // _zoomplusfunction(),
              _mapTypeCycler(),

// _buildContainer(),
              _search(),
              _addMarker(),
              _addPolyLine(),
            ],
          ),
          bottomNavigationBar: BottomAppBar(          
            child: new Row(            
              mainAxisSize: MainAxisSize.max,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      _showModal();
                    }),
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: text(places.length),
                ),
              ],
            ),
          ));
    }
  }

  Widget text(int value) {
    Text text;
    if (value <= 0) {
      text = Text("Er zijn geen objecten gevonden klik op zoeken");
    } else {
      text = Text("Er zijn $value objecten gevonden");
    }
    return text;
  }

  void _showModal() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildContainer(),
            ],
          );
        });
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
      zoom: 20,
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
    circles.clear();
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
  //////////////////////////
  ///
  ///
  ///

  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};

  PolylineId selectedPolyline;

  void _onPolylineTapped(PolylineId polylineId) {
    setState(() {
      selectedPolyline = polylineId;
    });
  }
}
