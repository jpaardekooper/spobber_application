import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spobber/data/global_variable.dart';
import 'package:spobber/pages/marker_information/marker_template.dart';

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
                    Icon(Icons.map, color: Colors.white, size: 20), // icon
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
            snippet: "lat ${singleMarker[0].latitude}, long ${singleMarker[0].longitude}",
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
