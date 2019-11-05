import 'package:spobber_app/data/global_variable.dart';
import 'package:spobber_app/data/place_response.dart';

import '../data/global_variable.dart';
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../marker_information/marker_template.dart';
import 'bottom_modal.dart';

import 'package:toast/toast.dart';
import 'package:provider/provider.dart';
import '../helper/location_services.dart';
import 'package:spobber_app/helper/load_markers.dart';

import 'package:fluster/fluster.dart';
import 'package:spobber_app/helper/map_helper.dart';
import 'package:spobber_app/helper/map_marker.dart';

import 'package:spobber_app/maps_widgets/alertdialog_filter.dart';

class PlacesSearchMapSample extends StatefulWidget {
  PlacesSearchMapSample();

  @override
  State<PlacesSearchMapSample> createState() {
    return _PlacesSearchMapSample();
  }
}

typedef Marker MarkerUpdateAction(Marker marker);

class _PlacesSearchMapSample extends State<PlacesSearchMapSample> {
  bool currentWidget = true;

  //Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;

  bool loading = true;

  @override
  void initState() {
    super.initState();
  }

  //When clicked function is performed on a marker
  // void _onMarkerTapped(MarkerId markerId) {
  //   final Marker tappedMarker = markers[markerId];
  //   if (tappedMarker != null) {
  //     setState(() {
  //       // if (markers.containsKey(selectedMarker)) {
  //       //   final Marker resetOld = markers[selectedMarker]
  //       //       .copyWith(iconParam: BitmapDescriptor.defaultMarker);
  //       //   markers[selectedMarker] = resetOld;
  //       // }

  //       selectedMarker = markerId;
  //       // final Marker newMarker = tappedMarker.copyWith(
  //       //   iconParam: BitmapDescriptor.defaultMarkerWithHue(
  //       //     BitmapDescriptor.hueGreen,
  //       //   ),
  //       // );
  //       // markers[markerId] = newMarker;
  //     });
  //   }
  // }

  //   void _onNewMarkerTapped(MarkerId markerId) {
  //   final Marker tappedMarker = markers[markerId];
  //   if (tappedMarker != null) {
  //     setState(() {
  //       selectedMarker = markerId;
  //     });
  //   }
  // }

  void _add(double userlat, double userlong) {
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(userlat, userlong),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*', onTap: () {}),
      onTap: () {
        // _onMarkerTapped(markerId);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => MarkerTemplate(
        //               markerDetail: new MarkerDetail(
        //             markerId.toString(),
        //             widget.keyword,
        //             currentLocation.latitude.toString(),
        //             currentLocation.longitude.toString(),
        //             "-",
        //             "-",
        //             "-",
        //           ))),
        // );
      },
    );

    setState(() {
      _markers.add(marker);
      //  markers[markerId] = marker;
    });
  }

  static double latitude = 52.051968;
  static double longitude = 4.5121536;

  //List<Marker> markers2 = <Marker>[];

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

// void searchNearby(){
// places.add(PlaceResponse(id: 1, type: "es-las", latitude: currentLocation.latitude, longitude: currentLocation.longitude, status: 1, preview_image_uri: "12", object_uri: "dsa"));
// places.add(PlaceResponse(id: 2, type: "es-las", latitude: currentLocation.latitude + 0.0000000005, longitude: currentLocation.longitude + 0.0000000005, status: 1, preview_image_uri: "12", object_uri: "dsa"));

// }

  Future<void> searchNearby() async {
    setState(() {
      places.clear();
      _markers.clear();
      //  markers.clear();
    });
    final GoogleMapController controller = await _controller.future;
    final LatLngBounds visibleRegion = await controller.getVisibleRegion();

    setState(() {
      _visibleRegion = visibleRegion;
      print("setting visible region: $visibleRegion");
    });
    LoadMarkers loadmarkers = LoadMarkers(
      northLatitude: _visibleRegion.northeast.latitude,
      northLongitude: _visibleRegion.northeast.longitude,
      bottomLatitude: _visibleRegion.southwest.latitude,
      bottomLongitude: _visibleRegion.southwest.longitude,
    );
    loadmarkers.searchNearby().then((value) {
      //   _handleResponse();
      _initMarkers();
    });
  }

  MapType _mapType = MapType.satellite;

  Widget _mapTypeCycler() {
    final MapType nextType = MapType.values[_mapType.index == 2 ? 1 : 2];

    return Padding(
      padding: EdgeInsets.fromLTRB(12, 70, 0, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox.fromSize(
          size: Size(37, 37), // button width and height
          child: ClipRect(
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(5),
              ),
              // button color
              child: InkWell(
                splashColor: const Color(0xff004990), // splash color
                onTap: () {
                  setState(() {
                    _mapType = nextType;
                  });
                }, // button pressed
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.map), // icon
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

  Widget _search() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 70, 12, 0),
      child: Align(
        alignment: Alignment.topRight,
        child: SizedBox.fromSize(
          size: Size(37, 37), // button width and height
          child: ClipRect(
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(5),
              ),
              child: InkWell(
                splashColor: const Color(0xff004990),
                onTap: () {
                  setState(() {
                    places.clear();
                    //  markers.clear();
                    _markers.clear();
                    // circles.clear();
                    // polylines.clear();
                  });

                  if (setDataSource.length <= 0) {
                    showToast("Selecteer minimaal één databron.",
                        gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
                  } else {
                    searchNearby();
                    showToast("Data wordt ingeladen",
                        gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.search), // icon
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

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  Widget _addMarker(double lat, double long) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 130, 12, 0),
      child: Align(
        alignment: Alignment.topRight,
        child: SizedBox.fromSize(
          size: Size(37, 37), // button width and height
          child: ClipRect(
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(5),
              ), // button color
              child: InkWell(
                splashColor: const Color(0xff004990),
                onTap: () {
                  _add(lat, long);
                }, // button pressed
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add), // icon
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

  Widget _changeSourceFilter() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 190, 12, 0),
      child: Align(
        alignment: Alignment.topRight,
        child: SizedBox.fromSize(
          size: Size(37, 37), // button width and height
          child: ClipRect(
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(5),
              ),
              child: InkWell(
                splashColor: const Color(0xff004990),
                onTap: () {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialogFilter(
                        switchValueisSap: isSap,
                        valueChangedisSap: (value) {
                          isSap = value;
                        },
                        switchValueisSigma: isSigma,
                        valueChangedisSigma: (value) {
                          isSigma = value;
                        },
                        switchValueisUST02: isUST02,
                        valueChangedisUST02: (value) {
                          isUST02 = value;
                        },
                      );
                    },
                  );
                }, // button pressed
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    getIcon(setDataSource.length), // icon
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

  Icon getIcon(int selector) {
    if (selector <= 0) {
      return Icon(Icons.filter);
    } else if (selector == 1) {
      return Icon(Icons.filter_1);
    } else if (selector == 2) {
      return Icon(Icons.filter_2);
    } else if (selector == 3) {
      return Icon(Icons.filter_3);
    } else {
      return Icon(Icons.filter_9_plus);
    }
  }

  Widget _buildGoogleMap(BuildContext context) {
    return GestureDetector(
      child: Container(
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
          mapToolbarEnabled: false,
          onCameraMove: (position) => _updateMarkers(position.zoom),
          // onCameraIdle: _onCameraIdle,
          mapType: _mapType,
          initialCameraPosition: _myLocation,
          compassEnabled: true,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          markers: _markers,

          // markers: Set<Marker>.of(markers.values),
          // circles: Set<Circle>.of(circles.values),
          // polylines: Set<Polyline>.of(polylines.values),
        ),
      ),
    );
  }

  // Future _mapIdleSubscription() async{

  // }
  static LatLngBounds _visibleRegion;

  //var userLocation;
  @override
  Widget build(BuildContext context) {
    //print(_loading);
    //print(currentLocation.latitude);
    // if (_loading) {
    //   return new Scaffold(body: Center(child: CircularProgressIndicator()));
    // } else {
    var userLocation = Provider.of<UserLocation>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        child: userLocation == null
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: <Widget>[
                  _buildGoogleMap(context),
                  _mapTypeCycler(),
                  _search(),
                  _addMarker(userLocation.latitude, userLocation.longitude),
                  _changeSourceFilter(),
                  // Map markers loading indicator
                  _areMarkersLoading
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Card(
                              elevation: 2,
                              color: Colors.grey.withOpacity(0.9),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  'Er wordt geclusterd',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                          ),
                        ),
                ],
              ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          if (places.length <= 0 || places.length > 30) {
            return;
          } else {
            print(
                "Locatie van het drukken ${userLocation.latitude}, ${userLocation.longitude} ");
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return BottomSheetSwitch(
                  //places: places,
                  latitude: userLocation.latitude,
                  longitude: userLocation.longitude,
                  gotoLocation: gotoLocation,
                );
              },
            );
          }
        },
        child: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: <Widget>[
              IconButton(
                  icon: places.length <= 0
                      ? Icon(Icons.not_listed_location)
                      : Icon(Icons.touch_app),
                  onPressed: () {}),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: bottomApptext(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // }

  Widget bottomApptext() {
    Text text;
    if (places.length <= 0) {
      text = Text("Er zijn geen objecten gevonden klik op zoeken");
    } else {
      text = Text("Er zijn ${places.length.toString()} objecten gevonden");
    }
    return text;
  }

  Future<void> gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, long),
          zoom: 21,
          // tilt: 50.0,
          // bearing: 45.0,
        ),
      ),
    );
    _showLocationMarker(lat, long);

    //_add(lat, long);
  }

  Marker lastmarker;
  Marker currentMarker;

  void _showLocationMarker(double lat, double long) {
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, long),
    );

    setState(() {
      _markers.remove(lastmarker);
      currentMarker = marker;
      lastmarker = currentMarker;
      _markers.add(currentMarker);
    });
  }

  // _addMarkerOnScreen(double lat, double long){
  //   MarkerId lookingId;
  //   Marker lookingAt = new Marker(
  //     markerId: lookingId,
  //     position: LatLng(lat,long)
  //     );

  // }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  ///google maps clustering
  ///
  ////// Set of displayed markers and cluster markers on the map
  final Set<Marker> _markers = Set();

  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 18;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker> _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 15;

  /// Map loading flag
  bool _isMapLoading = true;

  /// Markers loading flag
  bool _areMarkersLoading = false;

  /// Url image used on normal markers sap (yellow)
  final String _markerImageUrlSap =
      'https://spobberstorageaccount.dfs.core.windows.net/marker/sap2.png?sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2021-07-13T22:18:33Z&st=2019-10-24T14:18:33Z&spr=https&sig=W%2BMVqLEyoZmIRE3aj9147RJ%2FYrsbl0uEcjuPVNsNYU4%3D';

  /// Url image used on cluster markers (red)
  final String _markerImageUrlSigma =
      'https://spobberstorageaccount.dfs.core.windows.net/marker/SIGMA.png?sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2021-07-13T22:18:33Z&st=2019-10-24T14:18:33Z&spr=https&sig=W%2BMVqLEyoZmIRE3aj9147RJ%2FYrsbl0uEcjuPVNsNYU4%3D';

  /// Url image used on cluster markers (blue)
  final String _markerImageUrlMeetTrein =
      'https://spobberstorageaccount.dfs.core.windows.net/marker/ust02.png?sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2021-07-13T22:18:33Z&st=2019-10-24T14:18:33Z&spr=https&sig=W%2BMVqLEyoZmIRE3aj9147RJ%2FYrsbl0uEcjuPVNsNYU4%3D';

  /// Url image used on cluster markers (cluster itself)
  final String _clusterImageUrl =
      "https://spobberstorageaccount.dfs.core.windows.net/marker/place-marker.png?sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2021-07-13T22:18:33Z&st=2019-10-24T14:18:33Z&spr=https&sig=W%2BMVqLEyoZmIRE3aj9147RJ%2FYrsbl0uEcjuPVNsNYU4%3D";

  /// Url image used on cluster markers
  final String _clusterImageUrl2 =
      'https://img.icons8.com/officel/80/000000/place-marker.png';

  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  void _initMarkers() async {
    final List<MapMarker> markers = [];

    markers.clear();

    for (PlaceResponse markerLocation in places) {
      //if there is no image found and
      if (markerLocation.source == "SAP") {
        final BitmapDescriptor markerImage =
            await MapHelper.getMarkerImageFromUrl(_markerImageUrlSap);

        markers.add(
          MapMarker(
            id: places.indexOf(markerLocation),
            equipment: markerLocation.id.toString(),
            secretId: markerLocation.secretId,
            objectUri: markerLocation.objectUri,
            onTapFunction: openMarkerInfo,
            placement: markerLocation.placement,
            position:
                new LatLng(markerLocation.latitude, markerLocation.longitude),
            icon: markerImage,
          ),
        );
      } else if (markerLocation.source == "SIGMA") {
        final BitmapDescriptor markerImage2 =
            await MapHelper.getMarkerImageFromUrl(_markerImageUrlSigma);

        markers.add(
          MapMarker(
            id: places.indexOf(markerLocation),
            secretId: markerLocation.secretId,
            equipment: markerLocation.id.toString(),
            objectUri: markerLocation.objectUri,
            onTapFunction: openMarkerInfo,
            placement: markerLocation.placement,
            position:
                new LatLng(markerLocation.latitude, markerLocation.longitude),
            icon: markerImage2,
          ),
        );
      } else {
        final BitmapDescriptor markerImage3 =
            await MapHelper.getMarkerImageFromUrl(_markerImageUrlMeetTrein);

        markers.add(
          MapMarker(
            id: places.indexOf(markerLocation),
            secretId: markerLocation.secretId,
            equipment: markerLocation.id.toString(),
            objectUri: markerLocation.objectUri,
            onTapFunction: openMarkerInfo,
            placement: markerLocation.placement,
            position:
                new LatLng(markerLocation.latitude, markerLocation.longitude),
            icon: markerImage3,
          ),
        );
      }
    }

    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
      _clusterImageUrl,
    );

    _updateMarkers();
  }

  openMarkerInfo() {
    print("HALO test function activated");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarkerTemplate(
          type: "ES-LAS",
          objectUri: currentSelectedMarkerObjectUri,
          id: int.parse(currentSelectedMarkerID),
          secretId: currentSelectedMarkerSecretID,
        ),
      ),
    );
  }

// double updatedZoomToCal;

//   void _onCameraIdle() {
//     print(_currentZoom);
//     print(updatedZoomToCal);
//     if (places.length > 0 && _currentZoom != updatedZoomToCal) {

  // setState(() {
  //   _areMarkersLoading = true;
  // });
//       _markers
//         ..clear()
//         ..addAll(MapHelper.getClusterMarkers(_clusterManager, _currentZoom));

//       Future.delayed(const Duration(seconds: 1), () {
//         setState(() {
//           _areMarkersLoading = false;
//         });
//       });
//     }
//   }

  bool _mayILoadMarkers = true;

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  void _updateMarkers([double updatedZoom]) {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }
    print(_mayILoadMarkers);

    if (_mayILoadMarkers) {
      //  print("HALOOO " + _mayILoadMarkers.toString());
      _markers
        ..clear()
        ..addAll(MapHelper.getClusterMarkers(_clusterManager, _currentZoom));

      setState(() {
        _areMarkersLoading = true;
        _mayILoadMarkers = false;
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _mayILoadMarkers = true;
          _areMarkersLoading = false;
        });
      });
    } else {
      return;
    }
  }
}
