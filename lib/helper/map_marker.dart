import 'package:fluster/fluster.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:spobber_release/data/global_variable.dart';
import 'package:spobber_release/marker_information/marker_template.dart';
import 'package:spobber_release/data/global_variable.dart';

/// [Fluster] can only handle markers that conform to the [Clusterable] abstract class.
///
/// You can customize this class by adding more parameters that might be needed for
/// your use case. For instance, you can pass an onTap callback or add an
/// [InfoWindow] to your marker here, then you can use the [toMarker] method to convert
/// this to a proper [Marker] that the [GoogleMap] can read.
class MapMarker extends Clusterable {
  final int id;
  final String secretId;
  final LatLng position;
  final BitmapDescriptor icon;
  final VoidCallback onTapFunction;
  final String equipment;
  final String objectUri;
  final String placement;

  MapMarker({
    @required this.id,
    @required this.position,
    @required this.icon,
    @required this.secretId,
    @required this.equipment,
    this.placement,
    this.onTapFunction,
    this.objectUri,
    isCluster = false,
    clusterId,
    pointsSize,
    childMarkerId,
  }) : super(
          markerId: id.toString(),
          latitude: position.latitude,
          longitude: position.longitude,
          isCluster: isCluster,
          clusterId: clusterId,
          pointsSize: pointsSize,
          childMarkerId: childMarkerId,
        );

  Marker toMarker() => Marker(
        markerId: MarkerId(id.toString()),
        position: LatLng(
          position.latitude,
          position.longitude,
        ),
        icon: icon,
        onTap: () {
          //   selectMarker(equipment, secretId, objectUri);
          currentSelectedMarkerID = equipment;
          currentSelectedMarkerSecretID = secretId;
          currentSelectedMarkerObjectUri = objectUri;
        },
        //   consumeTapEvents: true,
        infoWindow: isCluster
            ? null
            : InfoWindow(
                title: equipment.startsWith("0") ? "Er is geen equipment_id gevonden" : "Equipment: $equipment",
                snippet: "Plaatsing: $placement",
                onTap: onTapFunction,
              ),
      );
}
