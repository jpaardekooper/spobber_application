import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong/latlong.dart';
import 'package:spobber_app/data/place_response.dart';
import 'package:spobber_app/helper/load_markers.dart';
import 'package:user_location/user_location.dart';
import '../data/global_variable.dart';
import 'alertdialog_filter.dart';
//import '../widgets/drawer.dart';

class AnimatedMapControllerPage extends StatefulWidget {
  // static const String route = 'map_controller_animated';

  @override
  AnimatedMapControllerPageState createState() {
    return AnimatedMapControllerPageState();
  }
}

class AnimatedMapControllerPageState extends State<AnimatedMapControllerPage>
    with TickerProviderStateMixin {
  StreamController<LatLng> markerlocationStream = StreamController();
  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
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
                    //  places.clear();
                    //  markers.clear();
                    //    _markers.clear();
                    // circles.clear();
                    // polylines.clear();
                  });

                  // if (setDataSource.length <= 0) {
                  //   showToast("Selecteer minimaal één databron.",
                  //       gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
                  // } else {
                  searchNearby();
                  //   showToast("Data wordt ingeladen",
                  //       gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
                  // }
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

  Future<void> searchNearby() async {
    setState(() {
      //  places.clear();
      //  _markers.clear();
      //  markers.clear();
      markers.clear();
    });

    final bounds = mapController.bounds;
    LoadMarkers loadmarkers = LoadMarkers(
      northLatitude: bounds.north,
      bottomLatitude: bounds.south,
      northLongitude: bounds.east,
      bottomLongitude: bounds.west,
    );
    loadmarkers.searchNearby().then((value) {
      //   _handleResponse();
      _initMarkers();
    });
  }

  List<Marker> markers = [];

  void _initMarkers() async {
    for (PlaceResponse markerLocation in places) {
      //if there is no image found and

      markers.add(Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: LatLng(markerLocation.latitude, markerLocation.longitude),
        builder: (ctx) => Icon(
          Icons.close,
          color: Colors.red,
        ),
      ));
    }

    setState(() {
      markers = markers = List.from(markers);
    });
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

  // void _animatedMapMove(LatLng destLocation, double destZoom) {
  //   // Create some tweens. These serve to split up the transition from one location to another.
  //   // In our case, we want to split the transition be<tween> our current map center and the destination.
  //   final _latTween = Tween<double>(
  //       begin: mapController.center.latitude, end: destLocation.latitude);
  //   final _lngTween = Tween<double>(
  //       begin: mapController.center.longitude, end: destLocation.longitude);
  //   final _zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

  //   // Create a animation controller that has a duration and a TickerProvider.
  //   var controller = AnimationController(
  //       duration: const Duration(milliseconds: 500), vsync: this);
  //   // The animation determines what path the animation will take. You can try different Curves values, although I found
  //   // fastOutSlowIn to be my favorite.
  //   Animation<double> animation =
  //       CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

  //   controller.addListener(() {
  //     mapController.move(
  //         LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
  //         _zoomTween.evaluate(animation));
  //   });

  //   animation.addStatusListener((status) {
  //     if (status == AnimationStatus.completed) {
  //       controller.dispose();
  //     } else if (status == AnimationStatus.dismissed) {
  //       controller.dispose();
  //     }
  //   });

  //   controller.forward();
  // }

  //List<Marker> userLoc = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          FlutterMap(
            options: new MapOptions(
              //   center: points[0],
              zoom: 7,
              plugins: [
                MarkerClusterPlugin(),
                UserLocationPlugin(),
              ],
            ),
            layers: [
              TileLayerOptions(
                // urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                // subdomains: ['a', 'b', 'c'],
                urlTemplate: "https://api.tiles.mapbox.com/v4/"
                    "{id}/{z}/{x}/{y}@2x.png?access_token=pk.eyJ1IjoibG9hc3RoIiwiYSI6ImNrMm5icjVmbzAwZTczbWw5NXhldnNweHoifQ.kD3ajaJptOWa9pbRmbOIrg",
                additionalOptions: {
                  'accessToken':
                      'pk.eyJ1IjoibG9hc3RoIiwiYSI6ImNrMm5icjVmbzAwZTczbWw5NXhldnNweHoifQ.kD3ajaJptOWa9pbRmbOIrg',
                  'id': 'mapbox.streets',
                },
              ),
              MarkerLayerOptions(markers: markers),
              UserLocationOptions(
                  context: context,
                  mapController: mapController,
                  markers: markers,
                  markerlocationStream: markerlocationStream,
                  updateMapLocationOnPositionChange: false,
                  showMoveToCurrentLocationFloatingActionButton: true),
              MarkerClusterLayerOptions(
                maxClusterRadius: 120,
                size: Size(40, 40),
                anchor: AnchorPos.align(AnchorAlign.center),
                fitBoundsOptions: FitBoundsOptions(
                  padding: EdgeInsets.all(50),
                ),
                markers: markers,
                polygonOptions: PolygonOptions(
                    borderColor: Colors.blueAccent,
                    color: Colors.black12,
                    borderStrokeWidth: 3),
                builder: (context, markers) {
                  return FloatingActionButton(
                    heroTag: Text("test"),
                    child: Text(markers.length.toString()),
                    onPressed: () {},
                  );
                },
              ),
            ],
            mapController: mapController,
          ),
          _search(),
          _changeSourceFilter(),
        ],
      ),
    );
  }
}
