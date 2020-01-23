import 'dart:async';
import 'dart:io';

import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spobber/clustering/map_marker.dart';
import 'package:spobber/clustering/map_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spobber/data/load_markers.dart';
import 'package:spobber/data/place_response.dart';
import 'package:spobber/network/location_services.dart';
import 'package:spobber/pages/marker_information/marker_template.dart';
import 'package:spobber/data/global_variable.dart';
import 'package:spobber/pages/widgets/alertdialog_filter.dart';
import 'package:spobber/pages/widgets/animated_fab.dart';
import 'package:spobber/pages/widgets/bottom_modal.dart';
import 'package:spobber/pages/widgets/show_toast.dart';
import 'package:spobber/pages/widgets/stackingMapWidget.dart';
import 'package:toast/toast.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView>
    with AutomaticKeepAliveClientMixin<MapView> {
  @override
  bool get wantKeepAlive => true;

  GoogleMapController _mapController;

  @override
  void dispose() {
    super.dispose();
  }

  /// Set of displayed markers and cluster markers on the map
  final Set<Marker> _markers = Set();

  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 17;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker> _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 7;

  /// Markers loading flag
  bool _areMarkersLoading = true;

  // /// Url image used on normal markers
  // final String _markerImageUrl =
  //     'https://img.icons8.com/office/80/000000/marker.png';

  /// Color of the cluster circle
  final Color _clusterColor = Colors.blue;

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;

  @override
  void initState() {
    super.initState();
  }

  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  Widget _search() {
    return StackingMapWidget(
      alignment: Alignment.topRight,
      padding: const EdgeInsets.fromLTRB(0, 70, 12, 0),
      onpressedFunction: loadDataToMaps,
      mapIcon: const Icon(Icons.search, size: 20),
    );
  }

  LatLngBounds _visibleRegion;

  Future loadDataToMaps() async {
    loadmarkers = true;
    currentUpdate = 0;
    if (setDataSource.length <= 0) {
      showToast("Selecteer minimaal één databron.", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);

      return;
    } else {
      //searchNearby();
      // loadDataToMaps();
      showToast("Data wordt ingeladen", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);

      places.clear();
      markers.clear();

      final LatLngBounds visibleRegion =
          await _mapController.getVisibleRegion();

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
  }

  MapType mapType = MapType.terrain;
  void changeMapType() {
    final MapType nextType = MapType.values[mapType.index == 2 ? 1 : 2];
    mapType = nextType;
    setState(() {});
  }

  _mapTypeCycler() {
    return StackingMapWidget(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.fromLTRB(12, 10, 0, 0),
      onpressedFunction: changeMapType,
      mapIcon: const Icon(Icons.map, size: 20),
    );
  }

  BitmapDescriptor decideWhichImage(String source) {
    if (source == "SAP") {
      return markerSap;
    } else if (source == "SIGMA") {
      return markerSigma;
    } else if (source == "UST02") {
      return markerUst02;
    } else if (source == "SPOBBER") {
      return markerSpobber;
    } else {
      return BitmapDescriptor.defaultMarker;
    }
  }

  final List<MapMarker> markers = [];
  void loadThisDataSet() async {
    for(int i =0; i< places.length; i++){
       final markerLocation = places[i];
       
       markers.add(
        MapMarker(
          readableId: markerLocation.readableID,
          secretId: markerLocation.secretId,
          equipment: markerLocation.equipmentId.toString(),
          objectUri: markerLocation.objectUri,
          onTapFunction: openMarkerInfo,
          placement: markerLocation.placement,
          position: LatLng(markerLocation.latitude, markerLocation.longitude),
          // LatLng(dp(markerLocation.latitude,6), dp(markerLocation.longitude,6)),
          icon: decideWhichImage(markerLocation.source),
          type: markerLocation.type,
          source: markerLocation.source,
        ),
      );
    }
    // for (PlaceResponse markerLocation in places) {
    //   //if there is no image found and
    //   markers.add(
    //     MapMarker(
    //       readableId: markerLocation.readableID,
    //       secretId: markerLocation.secretId,
    //       equipment: markerLocation.equipmentId.toString(),
    //       objectUri: markerLocation.objectUri,
    //       onTapFunction: openMarkerInfo,
    //       placement: markerLocation.placement,
    //       position: LatLng(markerLocation.latitude, markerLocation.longitude),
    //       // LatLng(dp(markerLocation.latitude,6), dp(markerLocation.longitude,6)),
    //       icon: decideWhichImage(markerLocation.source),
    //       type: markerLocation.type,
    //       source: markerLocation.source,
    //     ),
    //   );
    // }
    places.clear();

    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers().then((onValue) {
      _updateMarkerOnMap();
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

  void addPolyline() {
    final String polylineIdVal = 'polyline_id_1';
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      color: Colors.blueGrey,
      width: 1,
      points: points,
    );
    if (mounted) {
      polylines[polylineId] = polyline;
      setState(() {});
    }
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

  Widget _changeSourceFilter() {
    return StackingMapWidget(
      alignment: Alignment.topRight,
      padding: const EdgeInsets.fromLTRB(0, 130, 12, 0),
      onpressedFunction: getDataSourcePopUp,
      mapIcon: getIcon(setDataSource.length),
    );
  }

  getDataSourcePopUp() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogFilter(
          switchValueisSap: isSap,
          valueChangedisSap: (value) {
            if (mounted) {
              isSap = value;
              setState(() {});
            }
          },
          switchValueisSigma: isSigma,
          valueChangedisSigma: (value) {
            if (mounted) {
              isSigma = value;
              setState(() {});
            }
          },
          switchValueisUST02: isUST02,
          valueChangedisUST02: (value) {
            if (mounted) {
              isUST02 = value;
              setState(() {});
            }
          },
          switchValueisSpobber: isSpobber,
          valueChangedisSpobber: (value) {
            if (mounted) {
              isSpobber = value;
              setState(() {});
            }
          },
        );
      },
    );
  }

  Icon getIcon(int selector) {
    if (selector <= 0) {
      return const Icon(Icons.filter, size: 20);
    } else if (selector == 1) {
      return const Icon(Icons.filter_1, color: Colors.white, size: 20);
    } else if (selector == 2) {
      return const Icon(Icons.filter_2, color: Colors.white, size: 20);
    } else if (selector == 3) {
      return const Icon(Icons.filter_3, color: Colors.white, size: 20);
    } else if (selector == 4) {
      return const Icon(Icons.filter_4, color: Colors.white, size: 20);
    } else {
      return const Icon(Icons.filter_9_plus, color: Colors.white, size: 20);
    }
  }

  Future openMarkerInfo() async {
    print("HALO test function activated");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarkerTemplate(
          type: "ES-LAS",
          readableId: currentSelectedMarkerID,
          secretId: currentSelectedMarkerSecretID,
          source: currentSelectedMarkerSource,
        ),
      ),
    );
  }

  Timer iosMapStopped;
  double currentUpdate;
  bool loadmarkers;

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  Future<void> _updateMarkers([double updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    setState(() {
      _areMarkersLoading = false;
    });

    if (Platform.isIOS) {
      iosMapStopped?.cancel();
      iosMapStopped =
          Timer(const Duration(milliseconds: 400), _updateMarkerOnMap);
    }
  }

  //when the camera is Idle for Android or IOS update the markers
  Future<void> _updateMarkerOnMap() async {
    print(currentUpdate);
    print(_currentZoom);
    if (_clusterManager == null ||
        _currentZoom == currentUpdate && loadmarkers == false) return;
    loadmarkers = false;
    currentUpdate = _currentZoom;
    print("kom ik nu huier");
    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);

    setState(() {
      _areMarkersLoading = true;
    });
  }

  Widget createGoogleMapsMap() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: mylocation,
        zoom: _currentZoom,
      ),
      markers: _markers,
      polylines: Set<Polyline>.of(polylines.values),
      onCameraMove: (position) => _updateMarkers(position.zoom),
      onCameraIdle: _updateMarkerOnMap,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      mapType: mapType,
      mapToolbarEnabled: false,
      minMaxZoomPreference: const MinMaxZoomPreference(7, 21),
      cameraTargetBounds: CameraTargetBounds(
        LatLngBounds(
          northeast: const LatLng(54.01786, 7.230455),
          southwest: const LatLng(50.74753, 2.992192),
        ),
      ),
    );
  }

  /// Called when the Google Map widget is created. Updates the map loading state
  /// and inits the markers.
  ///
  void _onMapCreated(GoogleMapController controller) async {
    // _mapController.complete(controller);
    _mapController = controller;
    //  _initMarkers();
  }

  Widget _location() {
    return StackingMapWidget(
      alignment: Alignment.topRight,
      padding: const EdgeInsets.fromLTRB(0, 10, 12, 0),
      onpressedFunction: _goToCurrentLocation,
      mapIcon: const Icon(
        Icons.location_searching,
        size: 20,
      ),
    );
  }

  _goToCurrentLocation() async {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          //  bearing: 270.0,
          target: LatLng(mylocation.latitude, mylocation.longitude),
          //  tilt: 30.0,
          zoom: 17.0,
        ),
      ),
    );
  }

  Widget _bottomAppBar(double lat, double long) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: bottomNavigatorInformation(lat, long),
      //
    );
  }

  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);
    userLocation == null
        ? const Center(child: CircularProgressIndicator())
        : mylocation = LatLng(userLocation.latitude, userLocation.longitude);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          //maps changer
          createGoogleMapsMap(),
          _mapTypeCycler(),

          _location(),
          // Map markers loading indicator
          _loadingIndicator(),
          _search(),
          //filter
          _changeSourceFilter(),
          _bottomAppBar(mylocation.latitude, mylocation.longitude),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: FancyFab(),
      ),
      //  bottomNavigationBar: b;
    );
  }

  Widget bottomNavigatorInformation(double lat, double long) {
    return GestureDetector(
        onTap: () {
          if (markers.length <= 0 || markers.length > 30) {
            return;
          } else {
            showModalBottomSheet<void>(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                return BottomSheetSwitch(
                  markers: markers,
                  latitude: lat,
                  longitude: long,
                  gotoLocation: goToMarkerLocation,
                  openMarkerInfo: openMarkerInfo,
                );
              },
            );
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(60),
            topLeft: Radius.circular(60),
          ),
          child: BottomAppBar(
            color: markers.length <= 0 || markers.length > 30
                ? Theme.of(context).primaryColor
                : Theme.of(context).accentColor,
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    icon: markers.length <= 0 || markers.length > 30
                        ? const Icon(
                            Icons.filter,
                            color: Colors.white,
                          )
                        : const Icon(Icons.touch_app, color: Colors.white),
                    onPressed: () {}),
                bottomApptext(),
              ],
            ),
          ),
        ));
  }

  int _markerIdCounter = 0;
  Marker lastmarker;
  Marker currentMarker;
  goToMarkerLocation(double lat, double long) {
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

    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          //  bearing: 270.0,
          target: LatLng(lat, long),
          // tilt: 30.0,
          zoom: 21.0,
        ),
      ),
    );
  }

  goToMarkerZoomLocation(double lat, double long, currentzoom) {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          //  bearing: 270.0,
          target: LatLng(lat, long),
          // tilt: 30.0,
          zoom: currentzoom + 2.5,
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
    } else if (markers.length <= 0) {
      text = Text(
        "Er zijn geen objecten gevonden klik op zoeken",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      );
    } else if (markers.length > 30) {
      text = Text(
        "Er zijn ${markers.length.toString()} objecten gevonden.",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      );
    } else {
      text = Text(
        "Er zijn ${markers.length.toString()} objecten gevonden. \nKlik hier voor meer informatie",
        style: TextStyle(color: Colors.white),
      );
    }
    return text;
  }

  _loadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: _areMarkersLoading
            ? const Text('')
            : Card(
                elevation: 2,
                color: Colors.grey.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: const Text(
                    'Laden',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
      ),
    );
  }
}
