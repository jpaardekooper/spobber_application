// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spobber/data/global_variable.dart';
import 'package:spobber/data/global_variable.dart';

import 'new_marker_information.dart';

class PlaceMarkerBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PlaceMarkerBodyState();
}

typedef Marker MarkerUpdateAction(Marker marker);

class PlaceMarkerBodyState extends State<PlaceMarkerBody> {
  static final LatLng center = const LatLng(-33.86711, 151.1947171);
  LatLngBounds _visibleRegion;

  GoogleMapController controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
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

  void _onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                actions: <Widget>[
                  FlatButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
                content: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 66),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Old position: ${tappedMarker.position}'),
                        Text('New position: $newPosition'),
                      ],
                    )));
          });
    }
  }

  void _add() async {
    final LatLngBounds visibleRegion = await controller.getVisibleRegion();
    setState(() {
      _visibleRegion = visibleRegion;
    });

    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      draggable: true,
      markerId: markerId,
      position: LatLng(
        ((_visibleRegion.northeast.latitude +
                _visibleRegion.southwest.latitude) /
            2),
        ((_visibleRegion.northeast.longitude +
                _visibleRegion.southwest.longitude) /
            2),
      ),
      infoWindow: InfoWindow(
        title: markerIdVal,
        snippet: 'nieuw object',
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => (NewMarkerInformation()),
              ));
        },
      ),
      onTap: () {
        _onMarkerTapped(markerId);
      },
      onDragEnd: (LatLng position) {
        _onMarkerDragEnd(markerId, position);
      },
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
      alignment: Alignment.topCenter,
      child: FlatButton(
        color: Colors.orange,
        textColor: Colors.white,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        padding: EdgeInsets.all(8.0),
        splashColor: Colors.blueAccent,
        child: const Text('Object toevoegen'),
        onPressed: _add,
      ),
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
      child: Container(
        // padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 2),
        child: IconButton(
          color: Colors.orange,
          //    textColor: Colors.white,
          disabledColor: Theme.of(context).accentColor,
          //    disabledTextColor: Colors.black,
          padding: EdgeInsets.all(8.0),
          //    splashColor: Colors.blueAccent,
          icon: Icon(Icons.close),
          onPressed: null,
          iconSize: 20,
        ),
      ),
    );
  }

  bool showRemove = false;
  String selectedText;

  Widget showRemoveButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Visibility(
          //  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 2),
          visible: showRemove,
          child: FlatButton(
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(8.0),
            splashColor: Colors.blueAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.close),
                Text('$selectedText verwijderen')
              ],
            ),
            onPressed: _remove,
          ),
        ),
      ),
    );
  }
// A breaking change to the ImageStreamListener API affects this sample.
// I've updates the sample to use the new API, but as we cannot use the new
// API before it makes it to stable I'm commenting out this sample for now
// TODO(amirh): uncomment this one the ImageStream API change makes it to stable.
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
