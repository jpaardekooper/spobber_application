import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spobber/data/global_variable.dart';
import 'package:spobber/pages/marker_information/marker_template.dart';
import 'package:spobber/pages/widgets/stackingMapWidget.dart';

class SingleMarkerWithMaps extends StatefulWidget {
  @override
  _SingleMarkerWithMapsState createState() => _SingleMarkerWithMapsState();
}

class _SingleMarkerWithMapsState extends State<SingleMarkerWithMaps> {
  GoogleMapController controller;
  Set<Marker> markers = Set();

  @override
  void initState() {
    //loading the specific marker
    addnewMarker();
    super.initState();
  }

  void _onMapCreated(GoogleMapController mapController) async {
    controller = mapController;
  }

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(singleMarker[0].latitude, singleMarker[0].longitude),
    zoom: 15,
  );

  MapType mapType = MapType.normal;
  void changeMapType() {
    final MapType nextType = MapType.values[mapType.index == 2 ? 1 : 2];
    setState(() {
      mapType = nextType;
    });
  }

  _mapTypeCycler() {
    return StackingMapWidget(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.fromLTRB(12, 10, 0, 0),
      onpressedFunction: changeMapType,
      mapIcon: const Icon(Icons.map, size: 20),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey2 = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Marker: ${singleMarker[0].readableID}"),
        centerTitle: true,
      ),
      body: Stack(
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
      ),
    );
  }

  addnewMarker() {
    Marker resultMarker = Marker(
        markerId: MarkerId(singleMarker[0].readableID.toString()),
        infoWindow: InfoWindow(
            title: singleMarker[0].readableID.toString(),
            snippet:
                "lat ${singleMarker[0].latitude}, long ${singleMarker[0].longitude}",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MarkerTemplate(
                    type: singleMarker[0].type,
                    readableId: singleMarker[0].readableID,
                    secretId: singleMarker[0].secretId,
                  ),
                ),
              );
            }),
        position: LatLng(singleMarker[0].latitude, singleMarker[0].longitude));

    markers.add(resultMarker);
  }
}
