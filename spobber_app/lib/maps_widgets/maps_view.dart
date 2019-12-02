import 'dart:async';
import "dart:math" as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spobber_app/data/global_variable.dart';
import 'package:spobber_app/data/place_response.dart';
import '../marker_information/marker_template.dart';
import 'bottom_modal.dart';
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';
import '../helper/location_services.dart';
import 'package:spobber_app/helper/load_markers.dart';
import 'package:spobber_app/maps_widgets/alertdialog_filter.dart';

import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class MapsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MapsViewState();
  }
}

class MapsViewState extends State<MapsView> with TickerProviderStateMixin {
  ///=========================================[Declare]=============================================
  /// Controller for FloatActionButtons
  AnimationController _controller;

  /// Icons List For FloatActionButtons
  List<IconData> icons = [
    Icons.gps_not_fixed,
    Icons.content_copy,
  ];

  // final geolocator = Geolocator()..forceAndroidLocationManager = true;

  // var locationOptions =
  //     LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 0);

  double lat;
  double long;
  double _outZoom = 10.0;
  double _inZoom = 15.0;

  MapController mapController = new MapController();
  final favoritePlaceController = TextEditingController();
  //String placeName;

  /// Is camera Position Lock is enabled default false
  bool isMoving = false;

  ///=========================================[initState]=============================================

  initState() {
    super.initState();
    // if (user == null || lat == null) {
    //   ///checks GPS then call localize
    //   _checkGPS();
    // } else {
    //   /// GPS is Okey just localize
    //   localize();
    // }

    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  _moveCamera(double lati, double longi) {
    //   isMoving = true;
    mapController.move(LatLng(lati, longi), 24);
    // icons[0] = Icons.gps_fixed;
  }

  // String positionName() {
  //   if (globals.weatherResponse != null) {
  //     var weatherData =
  //         new WeatherData.fromJson(jsonDecode(weatherResponse.body));
  //     return weatherData.name.toString();
  //   } else {
  //     return null;
  //   }
  // }

  // _checkGPS() async {
  //   /// when back to this tab should get previous position from libraries
  //   if (globals.lat != null && globals.long != null) {
  //     setState(() {
  //       lat = globals.lat;
  //       long = globals.long;
  //       placeName = positionName();
  //     });
  //   }
  //   var status = await geolocator.checkGeolocationPermissionStatus();
  //   bool isGPSOn = await geolocator.isLocationServiceEnabled();
  //   if (status == GeolocationStatus.granted && isGPSOn) {
  //     /// Localize Position
  //     localize();

  //     _moveCamera();
  //   } else if (isGPSOn == false) {
  //     _showDialog("Turn On Your GPS");
  //     localize();
  //     _moveCamera();
  //   } else if (status != GeolocationStatus.granted) {
  //     await PermissionHandler()
  //         .requestPermissions([PermissionGroup.locationWhenInUse]);
  //     localize();
  //     _moveCamera();
  //   } else {
  //     _showDialog("Turn On Your GPS");
  //     await PermissionHandler()
  //         .requestPermissions([PermissionGroup.locationWhenInUse]);
  //     localize();
  //     _moveCamera();
  //   }
  // }

  // void localize() {
  //   geolocator.getPositionStream(locationOptions).listen((Position position) {
  //     /// To not call setState when this state is not active
  //     if (!mounted) {
  //       return;
  //     }
  //     if (mounted) {
  //       setState(() {
  //         this.lat = position.latitude;
  //         this.long = position.longitude;
  //         globals.long = long;
  //         globals.lat = lat;
  //         if (isMoving == true) {
  //           mapController.move(LatLng(lat, long), _inZoom);
  //           icons[0] = Icons.gps_fixed;
  //         }
  //       });
  //     }
  //   });
  // }

  _favoritePlaces(double lat, double long, String id, String source) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var imageData;
    print(source);
    if (source == "SAP") {
      imageData = "assets/SAP.png";
    } else if (source == "SIGMA") {
      imageData = "assets/SIGMA.png";
      print(imageData);
    } else if (source == "UST02") {
      imageData = "assets/UST02.png";
    } else {
      return;
    }
    print(imageData);

    /// get the favorite position then added to prefs
    //var placeName = favoritePlaceController.text;
    var placeName = id;

    ///convert position to string and concat it
    var placePosition = lat.toString() +
        ',' +
        long.toString() +
        ',' +
        //FavoriteLocationDropDown.currentImage.toString();
        imageData;

    print('Place Name $placeName => $placePosition Captured.');
    await prefs.setString(
      '$placeName',
      '$placePosition',
    );
    favoritePlaceController.clear();
  }

  //declaring Bottom sheet widget
  // Widget buildSheetLogin(BuildContext context) {
  //   return new Container(
  //     color: Colors.white,
  //     child: Wrap(children: <Widget>[
  //       Container(
  //         padding: new EdgeInsets.only(left: 10.0, top: 10.0),
  //         width: MediaQuery.of(context).size.width / 1.7,
  //         child: TextFormField(
  //           controller: favoritePlaceController,
  //           decoration: InputDecoration(
  //             border: OutlineInputBorder(
  //               borderSide: BorderSide(color: Colors.black),
  //             ),

  //             /// focused border color (erasing theme default color [teal])
  //             focusedBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
  //                 borderSide: BorderSide(color: Colors.black)),
  //             labelText: "Place name",
  //             hintText: "Enter Place Name",
  //             prefixIcon: Icon(
  //               Icons.save_alt,
  //               color: Colors.teal,
  //             ),
  //           ),
  //         ),
  //       ),
  //       Container(child: FavoriteLocationDropDown()),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: <Widget>[
  //           Padding(
  //             padding: const EdgeInsets.only(right: 8.0),
  //             child: RaisedButton(
  //               color: Colors.teal,
  //               textColor: Colors.white,
  //               child: Text("Save"),
  //               onPressed: () {
  //                 // _favoritePlaces();
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     ]),
  //   );
  // }

  Widget _search() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 12, 0),
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

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  Future<void> searchNearby() async {
    setState(() {
      places.clear();
      markers.clear();
    });

    LoadMarkers loadmarkers = LoadMarkers(
        northLatitude: mapController.bounds.north,
        northLongitude: mapController.bounds.east,
        bottomLatitude: mapController.bounds.south,
        bottomLongitude: mapController.bounds.west);
    loadmarkers.searchNearby().then((value) {
      //   _handleResponse();
      _initMarkers();
    });
  }

  String testExample;

  void _initMarkers() async {
    for (PlaceResponse markerLocation in places) {
      //if there is no image found and
      if (markerLocation.source == "SAP") {
        markers.add(
          Marker(
            anchorPos: AnchorPos.align(AnchorAlign.center),
            width: 30,
            height: 30,
            point: LatLng(markerLocation.latitude, markerLocation.longitude),
            builder: (ctx) => IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.yellow,
              ),
              onPressed: () {
                _favoritePlaces(
                    markerLocation.latitude,
                    markerLocation.longitude,
                    markerLocation.id.toString(),
                    markerLocation.source);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MarkerTemplate(
                      type: markerLocation.type,
                      objectUri: markerLocation.objectUri,
                      id: markerLocation.id.toString(),
                      secretId: markerLocation.secretId,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
      if (markerLocation.source == "SIGMA") {
        markers.add(
          Marker(
            anchorPos: AnchorPos.align(AnchorAlign.center),
            width: 30,
            height: 30,
            point: LatLng(markerLocation.latitude, markerLocation.longitude),
            builder: (ctx) => IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.red,
              ),
              onPressed: () {
                _favoritePlaces(
                    markerLocation.latitude,
                    markerLocation.longitude,
                    markerLocation.id.toString(),
                    markerLocation.source);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MarkerTemplate(
                      type: markerLocation.type,
                      objectUri: markerLocation.objectUri,
                      id: markerLocation.id.toString(),
                      secretId: markerLocation.secretId,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
      if (markerLocation.source == "UST02") {
        markers.add(
          Marker(
            anchorPos: AnchorPos.align(AnchorAlign.center),
            width: 30,
            height: 30,
            point: LatLng(markerLocation.latitude, markerLocation.longitude),
            builder: (ctx) => IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.blue,
              ),
              onPressed: () {
                _favoritePlaces(
                    markerLocation.latitude,
                    markerLocation.longitude,
                    markerLocation.id.toString(),
                    markerLocation.source);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MarkerTemplate(
                      type: markerLocation.type,
                      objectUri: markerLocation.objectUri,
                      id: markerLocation.id.toString(),
                      secretId: markerLocation.secretId,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
    }
    setState(() {
      markers = markers = List.from(markers);
    });
  }

  Widget _changeSourceFilter() {
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

  List<String> _mapType = ['mapbox.streets', 'mapbox.satellite'];
  String mapType = 'mapbox.streets';

  Widget _mapTypeCycler(String type) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 10, 0, 0),
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
                  if (type == _mapType[0]) {
                    setState(() {
                      mapType = _mapType[1];
                    });
                  } else {
                    setState(() {
                      mapType = _mapType[0];
                    });
                  }
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

  List<Marker> markers = [];

  ///to show a snackBar after copy
  final GlobalKey<ScaffoldState> mykey = new GlobalKey<ScaffoldState>();

  ///=========================================[BUILD]=============================================

  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);

    Widget _loadBuild() {
      ///[Position Found Render Marker]
      // if (userLocation.latitude != 0.0) {
      if (userLocation != null) {
        lat = userLocation.latitude;
        long = userLocation.longitude;
        print(lat.toString() + " " + long.toString());
        return Container(
          child: new FlutterMap(
            mapController: mapController,
            options: new MapOptions(
              center: new LatLng(lat, long),
              zoom: _inZoom,
              maxZoom: 20,
              minZoom: 8,
              swPanBoundary: LatLng(50.74753, 2.992192),
              nePanBoundary: LatLng(54.01786, 7.230455),
              plugins: [
                MarkerClusterPlugin(),
              ],
            ),
            layers: [
              new TileLayerOptions(
                urlTemplate:
                    "https://atlas.microsoft.com/map/tile/png?api-version=1&layer=hybrid&style=main&tileSize=256&view=Auto&zoom={z}&x={x}&y={y}&subscription-key={subscriptionKey}",
                additionalOptions: {
                  'subscriptionKey':
                      't1riNaH3DwAFoz4mWTXc7AR62E3qUsgzWgfZsjY-NsI'
                          ''
                },
                keepBuffer: 10000,
                // placeholderImage: NetworkImage('https://www.google.com/maps?q=google+maps+api&um=1&ie=UTF-8&sa=X&ved=0ahUKEwiP96WDxezlAhVKblAKHTXCBzcQ_AUIEigB')
                tileProvider: CachedNetworkTileProvider(),
              ),
              new MarkerLayerOptions(
                markers: [
                  new Marker(
                    width: 50.0,
                    height: 50.0,
                    point: new LatLng(lat, long),
                    builder: (ctx) => new Container(
                      child: Column(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.adjust,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: null),
                        ],
                      ),
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(100.0),
                        color: Colors.blue[100].withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
              MarkerClusterLayerOptions(
                maxClusterRadius: 80,
                zoomToBoundsOnClick: true,
                centerMarkerOnClick: true,
                showPolygon: false,
                spiderfySpiralDistanceMultiplier: 2,

                size: Size(40, 40),
                anchor: AnchorPos.align(AnchorAlign.center),
                fitBoundsOptions: FitBoundsOptions(
                  padding: EdgeInsets.all(8),
                  maxZoom: 20
                ),
                markers: markers,
                builder: (context, markers) {
                  return Container(
                    width: 50, height: 50,
                    decoration: new BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    // heroTag: Text("test"),
                    child: Center(
                        child: Text(
                      markers.length.toString(),
                      style: TextStyle(color: Colors.white),
                    )),

                    // onPressed: () {
                    //   print("cluster marker");
                    // },
                  );
                },
              ),
            ],
          ),
        );
      } else {
        setState(() {
          icons[0] = Icons.gps_not_fixed;
        });

        ///[Position Not Found/Not Found yet]
        return Container(
          child: new FlutterMap(
            mapController: mapController,
            options: new MapOptions(
              zoom: _outZoom,
              center: new LatLng(52.0787361, 4.4017707),
              maxZoom: 20,
              minZoom: 8,
              swPanBoundary: LatLng(50.74753, 2.992192),
              nePanBoundary: LatLng(54.01786, 7.230455),
            ),
            layers: [
              new TileLayerOptions(
                urlTemplate:
                    "https://atlas.microsoft.com/map/tile/png?api-version=1&layer=basic&style=main&tileSize=256&view=Auto&zoom={z}&x={x}&y={y}&subscription-key={subscriptionKey}",
                additionalOptions: {
                  'subscriptionKey':
                      't1riNaH3DwAFoz4mWTXc7AR62E3qUsgzWgfZsjY-NsI'
                },
              ),
            ],
          ),
        );
      }
    }

    ///Float Action Button Background Color
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).accentColor;

    /// Show Snack Bar Messages
    _showSnackBar(String message) {
      final snackBar =
          SnackBar(content: Text('$message'), duration: Duration(seconds: 1));
      mykey.currentState.showSnackBar(snackBar);
    }

    /// returned build
    return Scaffold(
      key: mykey,
      body: Stack(
        children: <Widget>[
          _loadBuild(),
          _search(),
          _changeSourceFilter(),
          _mapTypeCycler(mapType),
        ],
      ),

      ///floatingActionButtons
      floatingActionButton: new Column(
        mainAxisSize: MainAxisSize.min,
        children: new List.generate(icons.length, (int index) {
          Widget child = new Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: new ScaleTransition(
              scale: new CurvedAnimation(
                parent: _controller,
                curve: new Interval(0.0, 1.0 - index / icons.length / 2.0,
                    curve: Curves.easeOut),
              ),
              child: new FloatingActionButton(
                heroTag: null,
                backgroundColor: backgroundColor,
                mini: false,
                child: new Icon(icons[index],
                    color: index != 1 ? foregroundColor : foregroundColor),
                onPressed: () {
                  ///onPress LockCamera button
                  if (index == 0) {
                    /// if Camera not locked
                    if (isMoving == false) {
                      /// if position not null [LatLng]
                      if (lat != null && long != null) {
                        setState(() {
                          ///change icon to lockedCamera
                          icons[index] = Icons.gps_fixed;
                          isMoving = true;
                        });
                        mapController.move(LatLng(lat, long), _inZoom);
                        _showSnackBar("Camera Lock Enabled!");
                      } else {
                        _showSnackBar("Locatie kon niet worden vastgesteld!");
                      }
                    } else {
                      setState(() {
                        icons[index] = Icons.gps_not_fixed;
                        isMoving = false;
                      });

                      _showSnackBar("Camera Lock Disabled!");
                    }

                    ///OnPress Favorite Button
                  }
                  // else if (index == 1) {
                  //   // Calling bottom sheet Widget
                  //   showModalBottomSheetApp(
                  //       context: context,
                  //       builder: (builder) {
                  //         return buildSheetLogin(context);
                  //       });
                  // }

                  ///OnPress CopyPosition button
                  else if (index == 1) {
                    ///Copy Current Position
                    Clipboard.setData(new ClipboardData(text: "$lat,$long"));
                    _showSnackBar("Location Copied!");
                  }
                },
              ),
            ),
          );
          return child;
        }).toList()
          ..add(
            new FloatingActionButton(
              heroTag: null,
              child: new AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget child) {
                  return new Transform(
                    transform: new Matrix4.rotationZ(
                        _controller.value * 0.5 * math.pi),
                    alignment: FractionalOffset.center,
                    child: new Icon(
                        _controller.isDismissed ? Icons.add : Icons.close),
                  );
                },
              ),
              onPressed: () {
                if (_controller.isDismissed) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
            ),
          ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          if (places.length <= 0 || places.length > 30) {
            return;
          } else {
            print(
                "Locatie van het drukken ${userLocation.latitude}, ${userLocation.longitude} ");
            showBottomSheet<void>(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                return BottomSheetSwitch(
                  //places: places,
                  latitude: userLocation.latitude,
                  longitude: userLocation.longitude,
                  gotoLocation: _moveCamera,
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
                  icon: places.length <= 0 || places.length > 30
                      ? Icon(Icons.not_listed_location)
                      : Icon(Icons.touch_app),
                  onPressed: () {}),
              bottomApptext(),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomApptext() {
    Text text;
    if (places.length <= 0) {
      text = Text("Er zijn geen objecten gevonden klik op zoeken");
    } else {
      text = Text(
        "Er zijn ${places.length.toString()} objecten gevonden",
        textAlign: TextAlign.center,
      );
    }
    return text;
  }
}
