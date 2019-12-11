//import 'package:example/fake_point.dart';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spobber/clustering/splash_bloc.dart';

import '../clustering/aggregation_setup.dart';
import '../clustering/clustering_helper.dart';
import '../clustering/lat_lang_geohash.dart';
import '../clustering/aggregated_points.dart';

class HomeScreen extends StatefulWidget {
List<LatLngAndGeohash> list;

  HomeScreen({Key key, this.list}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    if (widget.list != null) {
      initMemoryClustering();
    }

    super.initState();
  }

  // For memory solution
  initMemoryClustering() {
    clusteringHelper = ClusteringHelper.forMemory(
      list: widget.list,
      updateMarkers: updateMarkers,
      aggregationSetup: AggregationSetup(markerSize: 150),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clustering Example"),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        onCameraMove: (newPosition) =>
            clusteringHelper.onCameraMove(newPosition, forceUpdate: false),
        onCameraIdle: clusteringHelper.onMapIdle,
      ),
      floatingActionButton: FloatingActionButton(
        child:
            widget.list == null ? Icon(Icons.content_cut) : Icon(Icons.update),
        onPressed: () async {
          List<LatLngAndGeohash> fakeList =
                          await SplashBloc().getListOfLatLngAndGeohash(context);
      
          clusteringHelper.list = fakeList;
          clusteringHelper.updateMap();
        },
      ),
    );
  }
}
