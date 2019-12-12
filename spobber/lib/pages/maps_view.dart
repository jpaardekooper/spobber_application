//import 'package:example/fake_point.dart';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spobber/clustering/splash_bloc.dart';

import '../clustering/aggregation_setup.dart';
import '../clustering/clustering_helper.dart';
import '../clustering/lat_lang_geohash.dart';
import 'package:provider/provider.dart';
import 'package:spobber/network/location_services.dart';

class MapView extends StatefulWidget {
// List<LatLngAndGeohash> list;

//   HomeScreen({this.list}) ;

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  List<LatLngAndGeohash> list = new List<LatLngAndGeohash>();

  ClusteringHelper clusteringHelper;
  final CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(0.000000, 0.000000), zoom: 0.0);

  Set<Marker> markers = Set();

  void _onMapCreated(GoogleMapController mapController) async {
    print("onMapCreated");
    clusteringHelper.mapController = mapController;
    // if (widget.list == null) {
    //   clusteringHelper.database = await AppDatabase.get().getDb();
    // }
    clusteringHelper.updateMap();
  }

  updateMarkers(Set<Marker> markers) {
    setState(() {
      this.markers = markers;
    });
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
    );
  }

  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);

    return SafeArea(
      // appBar: AppBar(
      //   title: Text("Clustering Example"),
      // ),
      child: Scaffold(
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: initialCameraPosition,
          markers: markers,
          onCameraMove: (newPosition) =>
              clusteringHelper.onCameraMove(newPosition, forceUpdate: false),
          onCameraIdle: clusteringHelper.onMapIdle,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.update),
          onPressed: () {
            loadDataToMaps();
          },
        ),
      ),
    );
  }

  loadDataToMaps() async {
    List<LatLngAndGeohash> fakeList =
        await SplashBloc().getListOfLatLngAndGeohash(context);

    clusteringHelper.list = fakeList;
    clusteringHelper.updateMap();
  }
}
