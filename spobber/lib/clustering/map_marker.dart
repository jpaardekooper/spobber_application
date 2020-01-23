import 'dart:ui';

import 'package:fluster/fluster.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spobber/data/global_variable.dart';

/// [Fluster] can only handle markers that conform to the [Clusterable] abstract class.
///
/// You can customize this class by adding more parameters that might be needed for
/// your use case. For instance, you can pass an onTap callback or add an
/// [InfoWindow] to your marker here, then you can use the [toMarker] method to convert
/// this to a proper [Marker] that the [GoogleMap] can read.
class MapMarker extends Clusterable {
  final String readableId;
  final String secretId;
  final LatLng position;
  BitmapDescriptor icon;
  final VoidCallback onTapFunction;
  final String equipment;
  final String objectUri;
  final String placement;
  final String source;
  final String type;


  MapMarker({
    @required this.readableId,
    @required this.position,

    this.icon,
    this.secretId,
    this.equipment,
    this.source,
    this.type,
    this.placement,
    this.onTapFunction,
    this.objectUri,
    isCluster = false,
    clusterId,
    pointsSize,
    childMarkerId,
  }) : super(
          markerId: readableId,
          latitude: position.latitude,
          longitude: position.longitude,
          isCluster: isCluster,
          clusterId: clusterId,
          pointsSize: pointsSize,
          childMarkerId: childMarkerId,
        );

  Marker toMarker() => Marker(
        markerId: MarkerId(isCluster ? 'cl_$readableId' : readableId),
        position: LatLng(
          position.latitude,
          position.longitude,
        ),

        icon: icon,
        anchor: Offset(0.5, 0.5),
        onTap: () {
          //   selectMarker(equipment, secretId, objectUri);
          currentSelectedMarkerID = readableId;
          currentSelectedMarkerSecretID = secretId;
          currentSelectedMarkerObjectUri = objectUri;  
            currentSelectedMarkerSource = source;     
        },
        //   consumeTapEvents: true,
        infoWindow: isCluster
            ? null
            : InfoWindow(
                title: "ReadableId: $readableId",
                snippet: "Bron: $source",
                onTap: () {
                  onTapFunction();
                  _favoritePlaces(
                      latitude, longitude, readableId, source, secretId, type);
                },
              ),
      );

//   final favoritePlaceController = TextEditingController();
  _favoritePlaces(double lat, double long, String readableid, String source,
      String secretId, String type) async {
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
    } else if (source == "SPOBBER") {
      imageData = "assets/spobber_icon.png";
    } else {
      return;
    }
    print(imageData);

    /// get the favorite position then added to prefs
    var placeName = readableid;

    ///convert position to string and concat it
    ///array 0 is latitude
    ///array 1 is longitude
    ///array 2 is imageData assets/imagename
    ///array 3 is source
    ///array 4 is secretid
    ///array 5 is type
    var placePosition = lat.toString() +
        ',' +
        long.toString() +
        ',' +
        imageData +
        ',' +
        source +
        ',' +
        secretId +
        ',' +
        type;

    print('Place Name $placeName => $placePosition Captured.');
    await prefs.setString(
      '__$placeName',
      '$placePosition',
    );
    // favoritePlaceController.clear();
  }
}
