// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spobber/data/global_variable.dart';
import 'package:spobber/data/marker_detail.dart';

import 'new_marker_information.dart';

class PlaceMarkerBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PlaceMarkerBodyState();
}

//typedef Marker MarkerUpdateAction(Marker marker);

class PlaceMarkerBodyState extends State<PlaceMarkerBody> {
  PlaceMarkerBodyState();
  LatLngBounds _visibleRegion;

  GoogleMapController _addObjectController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;

  void _onMapCreated(GoogleMapController controller) {
    this._addObjectController = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  CameraPosition getbounds;

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        showRemove = true;
        selectedText = tappedMarker.markerId.toString();
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    } else {
      setState(() {
        showRemove = false;
      });
    }
  }

  // void _onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
  //   final Marker tappedMarker = markers[markerId];
  //   if (tappedMarker != null) {
  //     await showDialog<void>(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //               actions: <Widget>[
  //                 FlatButton(
  //                   child: const Text('OK'),
  //                   onPressed: () => Navigator.of(context).pop(),
  //                 )
  //               ],
  //               content: Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 66),
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: <Widget>[
  //                       Text('Old position: ${tappedMarker.position}'),
  //                       Text('New position: $newPosition'),
  //                     ],
  //                   )));
  //         });
  //   }
  // }

  Widget _location() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 12, 0),
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
                  _goToCurrentLocation();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.location_searching), // icon
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

  _goToCurrentLocation() {
    if (mounted) {
      _addObjectController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            //  bearing: 270.0,
            target: LatLng(mylocation.latitude, mylocation.longitude),
            //  tilt: 30.0,
            zoom: 18.0,
          ),
        ),
      );
    }
  }

  void _onInfoWindowTapped(MarkerId markerId) {
    final Marker marker = markers[selectedMarker];

    if (marker != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => (NewMarkerInformation(
              markerinformation: new MarkerDetail(
                //        id: "STATUS_NEW_OBJECT",
                readableID: "STATUS_NEW_OBJECT",
                secretId: "STATUS_NEW_OBJECT",
                type: "Es-las",
                description: "",
                equipmentId: "",
                equipmentStatus: "",
                userStatusEquipment: "",
                parentEquipKind: "",
                datacollection: "",
                placement: "",
                latitude: marker.position.latitude,
                longitude: marker.position.longitude,
                picFileName: "",
                runNr: "",
                trackVersion: "",
                source: "SPOBBER",
                year: 2019, // => 21-04-2019 02:40:25
                creator: ""
              ),
            )),
          ));
    }
  }

  static LatLng center;
  void _add() async {
    print("kom je hier");
    if (mounted) {
      final LatLngBounds visibleRegion =
          await _addObjectController.getVisibleRegion();
      setState(() {
        _visibleRegion = visibleRegion;
      });
    }

    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);
    LatLng markerPos = LatLng(
      ((_visibleRegion.northeast.latitude + _visibleRegion.southwest.latitude) /
          2),
      ((_visibleRegion.northeast.longitude +
              _visibleRegion.southwest.longitude) /
          2),
    );

    final Marker marker = Marker(
      draggable: false,
      markerId: markerId,
      position: markerPos,
      infoWindow: InfoWindow(
        title: markerIdVal,
        snippet: 'Nieuw Object klik hier om gegvens toe te voegen',
        onTap: () {
          _onInfoWindowTapped(markerId);
        },
      ),
      onTap: () {
        _onMarkerTapped(markerId);
      },
      // onDragEnd: (LatLng position) {
      //   _onMarkerDragEnd(markerId, position);
      // },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _remove() {
    setState(() {
      if (markers.containsKey(selectedMarker)) {
        markers.remove(selectedMarker);
        showRemove = false;
      }
    });
  }

  // void _changePositionRight() {
  //   final Marker marker = markers[selectedMarker];
  //   final LatLng current = marker.position;
  //   final Offset offset = Offset(
  //     mylocation.latitude - current.latitude,
  //     mylocation.longitude - current.longitude,
  //   );
  //   setState(() {
  //     markers[selectedMarker] = marker.copyWith(
  //       positionParam: LatLng(
  //         current.latitude,
  //         current.longitude - offset.dx,
  //       ),
  //     );
  //   });
  // }

  // void _changePositionLeft() {
  //   final Marker marker = markers[selectedMarker];
  //   final LatLng current = marker.position;
  //   final Offset offset = Offset(
  //     mylocation.latitude - current.latitude,
  //     mylocation.longitude - current.longitude,
  //   );
  //   setState(() {
  //     markers[selectedMarker] = marker.copyWith(
  //       positionParam: LatLng(
  //         current.latitude,
  //         current.longitude + offset.dx,
  //       ),
  //     );
  //   });
  // }

  // void _changePositionTop() {
  //   final Marker marker = markers[selectedMarker];
  //   final LatLng current = marker.position;
  //   final Offset offset = Offset(
  //     mylocation.latitude - current.latitude,
  //     mylocation.longitude - current.longitude,
  //   );
  //   setState(() {
  //     markers[selectedMarker] = marker.copyWith(
  //       positionParam: LatLng(
  //         current.latitude - offset.dx,
  //         current.longitude,
  //       ),
  //     );
  //   });
  // }

  // void _changePositionBottom() {
  //   final Marker marker = markers[selectedMarker];
  //   final LatLng current = marker.position;
  //   final Offset offset = Offset(
  //     mylocation.latitude - current.latitude,
  //     mylocation.longitude - current.longitude,
  //   );
  //   setState(() {
  //     markers[selectedMarker] = marker.copyWith(
  //       positionParam: LatLng(
  //         current.latitude + offset.dx,
  //         current.longitude,
  //       ),
  //     );
  //   });
  // }
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
    return GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      onMapCreated: _onMapCreated,
      mapType: mapType,
      initialCameraPosition: CameraPosition(
        target: mylocation,
        zoom: 17.0,
      ),
      markers: Set<Marker>.of(markers.values),
    );
  }

  Widget addMarker() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.all(30.0),
        child: RaisedButton(
          onPressed: _add,
          padding: const EdgeInsets.all(0.0),
          textColor: Colors.white,
          child: Container(
            width: MediaQuery.of(context).size.width / 2.5,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xFF1b2932),
                  Color(0xFF1b2932),
                  Color(0xE61b2932),
                ],
              ),
            ),
            padding: const EdgeInsets.all(10.0),
            child: const Text(
              'Nieuw object toevoegen',
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      // child: FlatButton(

      //   color: Colors.orange,
      //   textColor: Colors.white,
      //   disabledColor: Colors.grey,
      //   disabledTextColor: Colors.black,
      //   padding: EdgeInsets.all(8.0),
      //   splashColor: Colors.blueAccent,
      //   child: const Text('Object toevoegen'),
      //   onPressed: _add,
      // ),
    );
  }

// //top
//   Widget moveMarkerToTop() {
//     return Align(
//       alignment: Alignment.center,
//       child: Padding(
//         padding:
//             EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 2.5),
//         child: IconButton(
//           color: Colors.orange,
//       //    textColor: Colors.white,
//           disabledColor: Colors.grey,
//       //    disabledTextColor: Colors.black,
//    //       padding: EdgeInsets.all(20.0),
//           splashColor: Colors.blueAccent,
//           icon: Icon(Icons.arrow_drop_up),
//           iconSize: 60,
//           onPressed: _changePositionBottom,
//         ),
//       ),
//     );
//   }

// //bottom
//   Widget moveMarkerToBottom() {
//     return Align(
//       alignment: Alignment.center,
//       child: Padding(
//         padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.5),
//         child: FlatButton(
//           color: Colors.orange,
//           textColor: Colors.white,
//           disabledColor: Colors.grey,
//           disabledTextColor: Colors.black,
//           padding: EdgeInsets.all(8.0),
//           splashColor: Colors.blueAccent,
//           child: const Text('Object toevoegen'),
//           onPressed: _add,
//         ),
//       ),
//     );
//   }

// //left
//   Widget moveMarkerToLeft() {
//     return Align(
//       alignment: Alignment.center,
//       child: Padding(
//         padding: EdgeInsets.only(right: MediaQuery.of(context).size.width / 2),
//         child: FlatButton(
//           color: Colors.orange,
//           textColor: Colors.white,
//           disabledColor: Colors.grey,
//           disabledTextColor: Colors.black,
//           padding: EdgeInsets.all(8.0),
//           splashColor: Colors.blueAccent,
//           child: const Text('Object toevoegen'),
//           onPressed: _add,
//         ),
//       ),
//     );
//   }

// //right
//   Widget moveMarkerToRight() {
//     return Align(
//       alignment: Alignment.center,
//       child: Padding(
//         padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 2),
//         child: FlatButton(
//           color: Colors.orange,
//           textColor: Colors.white,
//           disabledColor: Colors.grey,
//           disabledTextColor: Colors.black,
//           padding: EdgeInsets.all(8.0),
//           splashColor: Colors.blueAccent,
//           child: const Text('Object toevoegen'),
//           onPressed: _add,
//         ),
//       ),
//     );
//   }

// //right
  Widget addCrossToCenter() {
    return Align(
      alignment: Alignment.center,

      // padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 2),
      child: IconButton(
        padding: EdgeInsets.only(bottom: 30),
        color: Colors.orange,
        //    textColor: Colors.white,
        disabledColor: Theme.of(context).accentColor,
        //    disabledTextColor: Colors.black,
        // padding: EdgeInsets.all(8.0),
        //    splashColor: Colors.blueAccent,
        icon: Icon(Icons.location_on),
        onPressed: null,
        iconSize: 30,
      ),
    );
  }

  bool showRemove = false;
  String selectedText;

  Widget showRemoveButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Visibility(
        //  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 2),
        visible: showRemove,
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: RaisedButton(
            onPressed: _remove,
            padding: const EdgeInsets.all(0.0),
            textColor: Colors.white,
            child: Container(
              width: MediaQuery.of(context).size.width / 2.5,
              color: Colors.red,
              padding: const EdgeInsets.all(10.0),
              child: selectedMarker != null
                  ? Text(
                      '${selectedMarker.value} verwijderen',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      '',
                    ),
            ),
          ),
        ),
      ),
    );
  }
// A breaking change to the ImageStreamListener API affects this sample.
// I've updates the sample to use the new API, but as we cannot use the new
// API before it makes it to stable I'm commenting out this sample for now
//  uncomment this one the ImageStream API change makes it to stable.
// https://github.com/flutter/flutter/issues/33438
//
//  void _setMarkerIcon(BitmapDescriptor assetIcon) {
//    if (selectedMarker == null) {
//      return;
//    }
//
//    final Marker marker = markers[selectedMarker];
//    setState(() {
//      markers[selectedMarker] = marker.copyWith(
//        iconParam: assetIcon,
//      );
//    });
//  }
//
//  Future<BitmapDescriptor> _getAssetIcon(BuildContext context) async {
//    final Completer<BitmapDescriptor> bitmapIcon =
//        Completer<BitmapDescriptor>();
//    final ImageConfiguration config = createLocalImageConfiguration(context);
//
//    const AssetImage('assets/red_square.png')
//        .resolve(config)
//        .addListener(ImageStreamListener((ImageInfo image, bool sync) async {
//      final ByteData bytes =
//          await image.image.toByteData(format: ImageByteFormat.png);
//      final BitmapDescriptor bitmap =
//          BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
//      bitmapIcon.complete(bitmap);
//    }));
//
//    return await bitmapIcon.future;
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Nieuw object toevoegen"),
        ),
        body: Stack(
          children: <Widget>[
            createGoogleMapsMap(),
            addMarker(),
            _location(),
            // moveMarkerToTop(),
            // moveMarkerToBottom(),
            // moveMarkerToLeft(),
            // moveMarkerToRight(),
            addCrossToCenter(),
            showRemoveButton(),
            _mapTypeCycler(),
            // FlatButton(
            //   child: const Text('remove'),
            //   onPressed: _remove,
            // ),
            // FlatButton(
            //   child: const Text('change position'),
            //   onPressed: _changePositionTop,
            // ),
          ],
        ));
  }
}
