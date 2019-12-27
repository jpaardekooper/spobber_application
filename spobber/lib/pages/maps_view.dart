import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spobber/clustering/splash_bloc.dart';
import 'package:spobber/data/global_variable.dart';
import 'package:spobber/data/load_markers.dart';
import 'package:spobber/pages/widgets/alertdialog_filter.dart';
import 'package:spobber/pages/widgets/animated_fab.dart';
import 'package:spobber/pages/widgets/bottom_modal.dart';
import 'package:spobber/pages/widgets/show_toast.dart';
import 'package:toast/toast.dart';

import '../clustering/aggregation_setup.dart';
import '../clustering/clustering_helper.dart';
import '../clustering/lat_lang_geohash.dart';
import 'package:provider/provider.dart';
import 'package:spobber/network/location_services.dart';

import 'marker_information/marker_template.dart';

import 'dart:ui';

class MapView extends StatefulWidget {
// List<LatLngAndGeohash> list;

//   HomeScreen({this.list}) ;

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView>
//   with AutomaticKeepAliveClientMixin<MapView>
{
  // @override
  // bool get wantKeepAlive => true;

  List<LatLngAndGeohash> list = new List<LatLngAndGeohash>();

  ClusteringHelper clusteringHelper;
  final CameraPosition initialCameraPosition =
      //    CameraPosition(target: LatLng(0.000000, 0.000000), zoom: 0.0);
      CameraPosition(target: LatLng(52.3667, 4.8945), zoom: 7.0);

  Set<Marker> markers = Set();

  void _onMapCreated(GoogleMapController mapController) async {
    print("onMapCreated");
    clusteringHelper.mapController = mapController;
    clusteringHelper.updateMap();
  }

  double lastzoom;
  updateMarkers(Set<Marker> markers, double zoom) {
    if (lastzoom != zoom) {
      lastzoom = zoom;

      setState(() {
        this.markers = markers;
      });
    } else {
      return;
    }
  }

  @override
  void initState() {
    initMemoryClustering();

    super.initState();
  }

  // For memory solution
  initMemoryClustering() {
    clusteringHelper = ClusteringHelper.forMemory(
      list: list,
      updateMarkers: updateMarkers,
      aggregationSetup: AggregationSetup(markerSize: 150),
      showMarkerInformation: _showMarkerInformation,
      goToMarkerLocation: goToMarkerLocation,
    );
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
                    Icon(
                      Icons.map,
                    ), // icon
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

  Widget createGoogleMapsMap() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        polylines: Set<Polyline>.of(polylines.values),
        onCameraMove: (newPosition) =>
            clusteringHelper.onCameraMove(newPosition, forceUpdate: false),
        onCameraIdle: clusteringHelper.updateMap(),
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        mapType: mapType,
        mapToolbarEnabled: false,
        minMaxZoomPreference: MinMaxZoomPreference(7, 21),
        cameraTargetBounds: new CameraTargetBounds(
          new LatLngBounds(
            northeast: LatLng(54.01786, 7.230455),
            southwest: LatLng(50.74753, 2.992192),
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
                color: Color.fromRGBO(51, 216, 178, 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: InkWell(
                splashColor: const Color(0xff004990),
                onTap: () {
                  if (setDataSource.length <= 0) {
                    showToast("Selecteer minimaal één databron.", context,
                        gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
                  } else {
                    //searchNearby();
                    loadDataToMaps();
                    showToast("Data wordt ingeladen", context,
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

  Widget _changeSourceFilter() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 130, 12, 0),
      child: Align(
        alignment: Alignment.topRight,
        child: SizedBox.fromSize(
          size: Size(37, 37), // button width and height
          child: ClipRect(
            child: Container(
              decoration: new BoxDecoration(
                color: Color.fromRGBO(51, 216, 178, 1),
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
      return Icon(Icons.filter_1, color: Colors.white, size: 20);
    } else if (selector == 2) {
      return Icon(Icons.filter_2, color: Colors.white, size: 20);
    } else if (selector == 3) {
      return Icon(Icons.filter_3, color: Colors.white, size: 20);
    } else {
      return Icon(Icons.filter_9_plus, color: Colors.white, size: 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);
    mylocation = LatLng(userLocation.latitude, userLocation.longitude);
    if (userLocation == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
          body: Stack(
            children: <Widget>[
              //creating the google maps app
              createGoogleMapsMap(),
              //changing map
              _mapTypeCycler(),
              //searching the data source
              _search(),
              //filter
              _changeSourceFilter(),
            ],
          ),
          floatingActionButton: FancyFab(test: testthisfunc),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          bottomNavigationBar: bottomNavigatorInformation(
              userLocation.latitude, userLocation.longitude));
    }
  }

  void testthisfunc() {
    setState(() {
      clusteringHelper.list.clear();
    });
  }

  void _showMarkerInformation(
      String type, String objectUri, String id, String secret) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarkerTemplate(
          type: type,
          //   objectUri: objectUri,
          readableId: id,
          secretId: secret,
        ),
      ),
    );
  }

  void addPolyline() {
    final String polylineIdVal = 'polyline_id_1';
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      color: Colors.blueGrey,
      width: 1,
      points: points,
      // onTap: () {
      //   _onPolylineTapped(polylineId);
      // },
    );

    setState(() {
      polylines[polylineId] = polyline;
    });
  }

  Widget bottomNavigatorInformation(double lat, double long) {
    return GestureDetector(
      onTap: () {
        if (clusteringHelper.list.length <= 0 ||
            clusteringHelper.list.length > 30) {
          return;
        } else {
          print("Locatie van het drukken $lat, $long ");
          showBottomSheet<void>(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return BottomSheetSwitch(
                //places: places,
                latitude: lat,
                longitude: long,
                gotoLocation: goToMarkerLocation,
              );
            },
          );
        }
      },
      child: BottomAppBar(
        color: Theme.of(context).primaryColor,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                icon: clusteringHelper.list.length <= 0 ||
                        clusteringHelper.list.length > 30
                    ? Icon(
                        Icons.not_listed_location,
                        color: Colors.white,
                      )
                    : Icon(Icons.touch_app, color: Colors.white),
                onPressed: () {}),
            bottomApptext(),
          ],
        ),
      ),
    );
  }

  Widget bottomApptext() {
    Text text;
    if (setDataSource.length == 0) {
      text = Text(
        "Selecteer een databron",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      );
    } else if (clusteringHelper.list.length <= 0) {
      text = Text(
        "Er zijn geen objecten gevonden klik op zoeken",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      );
    } else {
      text = Text(
        "Er zijn ${clusteringHelper.list.length.toString()} objecten gevonden",
        style: TextStyle(color: Colors.white),
      );
    }
    return text;
  }

  LatLngBounds _visibleRegion;

  loadDataToMaps() async {
    clusteringHelper.list.clear();

    final LatLngBounds visibleRegion =
        await clusteringHelper.mapController.getVisibleRegion();

    _visibleRegion = visibleRegion;
    print("setting visible region: $visibleRegion");

    LoadMarkers loadmarkers = LoadMarkers(
      northLatitude: _visibleRegion.northeast.latitude,
      northLongitude: _visibleRegion.northeast.longitude,
      bottomLatitude: _visibleRegion.southwest.latitude,
      bottomLongitude: _visibleRegion.southwest.longitude,
    );

    addPolyLines(
        _visibleRegion.northeast.latitude,
        _visibleRegion.northeast.longitude,
        _visibleRegion.southwest.latitude,
        _visibleRegion.southwest.longitude);

    loadmarkers.searchNearby().then((value) {
      loadThisDataSet();
    });
  }

  List<LatLng> points = <LatLng>[];

  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  void addPolyLines(
      double northlat, double northlong, double southlat, double southlong) {
    points.clear();

    points.add(_createLatLng(northlat, northlong));
    points.add(_createLatLng(northlat, southlong));
    points.add(_createLatLng(southlat, southlong));
    points.add(_createLatLng(southlat, northlong));
    points.add(_createLatLng(northlat, northlong));

    addPolyline();
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

  loadThisDataSet() async {
    List<LatLngAndGeohash> fakeList =
        await SplashBloc().getListOfLatLngAndGeohash(context);

    clusteringHelper.list = fakeList;
    clusteringHelper.updateMap();
  }

  goToMarkerLocation(double lat, double long) {
    clusteringHelper.mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          //  bearing: 270.0,
          target: LatLng(lat, long),
          // tilt: 30.0,
          zoom: 20.0,
        ),
      ),
    );
  }
}
