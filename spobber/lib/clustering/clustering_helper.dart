// import 'dart:ui' as ui;
// import 'dart:typed_data';
// import 'dart:async';

// import 'dart:io';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:spobber/data/global_variable.dart';

// import 'aggregated_points.dart';
// import 'aggregation_setup.dart';
// import 'lat_lang_geohash.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:meta/meta.dart';

// class ClusteringHelper {
//   Function showMarkerInformation;
//   Function goToMarkerZoomLocation;

//   ClusteringHelper.forMemory({
//     @required this.list,
//     @required this.updateMarkers,
//     this.maxZoomForAggregatePoints = 18.0,
//     @required this.aggregationSetup,
//     this.bitmapAssetPathForSingleMarker,
//     this.showMarkerInformation,
//     this.goToMarkerZoomLocation,
//   })  : assert(list != null),
//         assert(aggregationSetup != null);

//   //After this value the map show the single points without aggregation
//   final double maxZoomForAggregatePoints;

//   //Custom bitmap: string of assets position
//   final String bitmapAssetPathForSingleMarker;

//   //Custom bitmap: string of assets position
//   final AggregationSetup aggregationSetup;

//   //Where clause for query db
//   String whereClause;

//   GoogleMapController mapController;

//   //Variable for save the last zoom
//   double _currentZoom = 0.0;

//   //Function called when the map must show single point without aggregation
//   // if null the class use the default function
//   Function showSinglePoint;

//   //Function for update Markers on Google Map
//   Function updateMarkers;

//   //List of points for memory clustering
//   List<LatLngAndGeohash> list;

//   Timer iosMapStopped;

//   //Call during the editing of CameraPosition
//   //If you want updateMap during the zoom in/out set forceUpdate to true
//   //this is NOT RECCOMENDED
//   onCameraMove(CameraPosition position, {forceUpdate = false}) {
//     _currentZoom = position.zoom;
//     if (forceUpdate) {
//       updateMap();
//     }
//     if (Platform.isIOS) {
//       iosMapStopped?.cancel();
//       iosMapStopped = Timer(const Duration(milliseconds: 500), updateMap);
//     }
//   }

//   //Call when user stop to move or zoom the map
//   Future<void> onMapIdle() async {
//     updateMap();
//   }

//   updateMap() {
//     if (_currentZoom < maxZoomForAggregatePoints) {
//       updateAggregatedPoints(zoom: _currentZoom);
//     } else {
//       if (showSinglePoint != null) {
//         showSinglePoint();
//       } else {
//         updatePoints(_currentZoom);
//       }
//     }
//   }

//   // Used for update list
//   // NOT RECCOMENDED for good performance (SQL IS BETTER)
//   updateData(List<LatLngAndGeohash> newList) {
//     list = newList;
//     updateMap();
//   }

//   Future<List<AggregatedPoints>> getAggregatedPoints(double zoom) async {
//     assert(() {
//       // print("loading aggregation");
//       return true;
//     }());

//     int level = 5;

//     if (zoom <= aggregationSetup.maxZoomLimits[0]) {
//       level = 1;
//     } else if (zoom < aggregationSetup.maxZoomLimits[1]) {
//       level = 2;
//     } else if (zoom < aggregationSetup.maxZoomLimits[2]) {
//       level = 3;
//     } else if (zoom < aggregationSetup.maxZoomLimits[3]) {
//       level = 4;
//     } else if (zoom < aggregationSetup.maxZoomLimits[4]) {
//       level = 5;
//     } else if (zoom < aggregationSetup.maxZoomLimits[5]) {
//       level = 6;
//     } else if (zoom < aggregationSetup.maxZoomLimits[6]) {
//       level = 7;
//     }

//     try {
//       List<AggregatedPoints> aggregatedPoints;
//       final latLngBounds = await mapController.getVisibleRegion();

//       final listBounds = list.where((p) {
//         final double leftTopLatitude = latLngBounds.northeast.latitude;
//         final double leftTopLongitude = latLngBounds.southwest.longitude;
//         final double rightBottomLatitude = latLngBounds.southwest.latitude;
//         final double rightBottomLongitude = latLngBounds.northeast.longitude;

//         final bool latQuery = (leftTopLatitude > rightBottomLatitude)
//             ? p.location.latitude <= leftTopLatitude &&
//                 p.location.latitude >= rightBottomLatitude
//             : p.location.latitude <= leftTopLatitude ||
//                 p.location.latitude >= rightBottomLatitude;

//         final bool longQuery = (leftTopLongitude < rightBottomLongitude)
//             ? p.location.longitude >= leftTopLongitude &&
//                 p.location.longitude <= rightBottomLongitude
//             : p.location.longitude >= leftTopLongitude ||
//                 p.location.longitude <= rightBottomLongitude;
//         return latQuery && longQuery;
//       }).toList();

//       aggregatedPoints = _retrieveAggregatedPoints(listBounds, List(), level);

//       return aggregatedPoints;
//     } catch (e) {
//       assert(() {
//         print(e.toString());
//         return true;
//       }());
//       return List<AggregatedPoints>();
//     }
//   }

//   final List<AggregatedPoints> aggList = [];

//   List<AggregatedPoints> _retrieveAggregatedPoints(
//       List<LatLngAndGeohash> inputList,
//       List<AggregatedPoints> resultList,
//       int level) {
//     assert(() {
//       ///print("input list lenght: " + inputList.length.toString());
//       return true;
//     }());

//     if (inputList.isEmpty) {
//       return resultList;
//     }
//     final List<LatLngAndGeohash> newInputList = List.from(inputList);
//     List<LatLngAndGeohash> tmp;
//     final t = newInputList[0].geohash.substring(0, level);
//     tmp =
//         newInputList.where((p) => p.geohash.substring(0, level) == t).toList();
//     newInputList.removeWhere((p) => p.geohash.substring(0, level) == t);
//     double latitude = 0;
//     double longitude = 0;
//     tmp.forEach((l) {
//       latitude += l.location.latitude;
//       longitude += l.location.longitude;
//     });
//     final count = tmp.length;
//     final a = AggregatedPoints(
//         LatLng((latitude / count), (longitude / count)), count);
//     resultList.add(a);
//     return _retrieveAggregatedPoints(newInputList, resultList, level);
//   }

//   Future<void> updateAggregatedPoints({double zoom = 0.0}) async {
//     List<AggregatedPoints> aggregation = await getAggregatedPoints(zoom);

//     assert(() {
//       // print("aggregation lenght: " + aggregation.length.toString());
//       return true;
//     }());
//     final Set<Marker> markers = {};

//     for (int i = 0; i < aggregation.length; i++) {
//       final a = aggregation[i];
//       assert(() {
//         print(a.count);
//         return true;
//       }());
//       BitmapDescriptor bitmapDescriptor;
//       if (a.count > 1) {
//         // >1
//         final Uint8List markerIcon =
//             await getBytesFromCanvas(a.count.toString(), getColor(a.count));
//         bitmapDescriptor = BitmapDescriptor.fromBytes(markerIcon);

//         final MarkerId markerId = MarkerId(a.getId());

//         final marker = Marker(
//             markerId: markerId,
//             position: a.location,
//             infoWindow: InfoWindow(title: a.count.toString()),
//             icon: bitmapDescriptor,
//             onTap: () {
//               goToMarkerZoomLocation(
//                   a.location.latitude, a.location.longitude, _currentZoom);
//             });

//         markers.add(marker);
//       }
//     }
//     updateMarkers(markers, zoom);
//   }

//   // final String _markerImageUrlSap =
//   //     'https://spobberstorageaccount.dfs.core.windows.net/marker/sap2.png?sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2021-07-13T22:18:33Z&st=2019-10-24T14:18:33Z&spr=https&sig=W%2BMVqLEyoZmIRE3aj9147RJ%2FYrsbl0uEcjuPVNsNYU4%3D';

//   // /// Url image used on cluster markers (red)
//   // final String _markerImageUrlSigma =
//   //     'https://spobberstorageaccount.dfs.core.windows.net/marker/SIGMA.png?sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2021-07-13T22:18:33Z&st=2019-10-24T14:18:33Z&spr=https&sig=W%2BMVqLEyoZmIRE3aj9147RJ%2FYrsbl0uEcjuPVNsNYU4%3D';

//   // /// Url image used on cluster markers (blue)
//   // final String _markerImageUrlMeetTrein =
//   //     'https://spobberstorageaccount.dfs.core.windows.net/marker/ust02.png?sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2021-07-13T22:18:33Z&st=2019-10-24T14:18:33Z&spr=https&sig=W%2BMVqLEyoZmIRE3aj9147RJ%2FYrsbl0uEcjuPVNsNYU4%3D';

//   /// If there is a cached file and it's not old returns the cached marker image file
//   /// else it will download the image and save it on the temp dir and return that file.
//   ///
//   /// This mechanism is possible using the [DefaultCacheManager] package and is useful
//   /// to improve load times on the next map loads, the first time will always take more
//   /// time to download the file and set the marker image.
//   ///
//   /// You can resize the marker image by providing a [targetWidth].
//   static Future<BitmapDescriptor> getMarkerImageFromUrl(
//     String url, {
//     int targetWidth,
//   }) async {
//     assert(url != null);

//     final File markerImageFile = await DefaultCacheManager().getSingleFile(url);

//     Uint8List markerImageBytes = await markerImageFile.readAsBytes();

//     if (targetWidth != null) {
//       markerImageBytes = await _resizeImageBytes(
//         markerImageBytes,
//         targetWidth,
//       );
//     }
//     return BitmapDescriptor.fromBytes(markerImageBytes);
//   }

//   /// Resizes the given [imageBytes] with the [targetWidth].
//   ///
//   /// We don't want the marker image to be too big so we might need to resize the image.
//   static Future<Uint8List> _resizeImageBytes(
//     Uint8List imageBytes,
//     int targetWidth,
//   ) async {
//     assert(imageBytes != null);
//     assert(targetWidth != null);

//     final ui.Codec imageCodec = await ui.instantiateImageCodec(
//       imageBytes,
//       targetWidth: targetWidth,
//     );

//     final ui.FrameInfo frameInfo = await imageCodec.getNextFrame();

//     final ByteData byteData = await frameInfo.image.toByteData(
//       format: ui.ImageByteFormat.png,
//     );

//     return byteData.buffer.asUint8List();
//   }

//   bool unclusterMarker = true;
//   // var test;

//   updatePoints(double zoom) async {
//     assert(() {
//       print("update single points");
//       return true;
//     }());

//     try {
//       List<LatLngAndGeohash> listOfPoints;

//       listOfPoints = list;

//       final Set<Marker> markers = listOfPoints.map((p) {
//         final MarkerId markerId = MarkerId(p.getId());

//         // getIconMarker(p.source).then((value) {
//         //   print(test);
//         // });
//         return Marker(
//             //anchor: Offset(0.5, 0.5),
//             markerId: markerId,
//             position: p.location,
//             infoWindow: InfoWindow(
//                 onTap: () {
//                   showMarkerInformation(p.type, p.objectUri, p.id, p.secretId);
//                   _favoritePlaces(p.location.latitude, p.location.longitude,
//                       p.readableID, p.source, p.secretId, p.type);
//                 },
//                 title: "ID: ${p.readableID}",
//                 snippet: p.placement == null || p.placement == ""
//                     ? "Lat: ${p.location.latitude.toStringAsFixed(3)}, Long: ${p.location.longitude.toStringAsFixed(3)}"
//                     : "Plaatsing: ${p.placement}"),
//             icon: getIcon(p.source),
//             anchor: Offset(0.5, 0.5),
//             onTap: () {
//               //   goToMarkerLocation(p.location.latitude, p.location.longitude);
//             });
//       }).toSet();

//       // if (zoom >= 18.5) {

//       // }
//       // else{
//       updateMarkers(markers, zoom);
//       // }
//       //   unclusterMarker = false;
//       // } else if (zoom <= 18.5) {
//       //   updateMarkers(markers);
//       //   unclusterMarker = true;
//       // } else {
//       //   //  updateMarkers(markers);
//       //   unclusterMarker = false;
//       // }

//       //   if (zoom >= 20) {
//       //   return;
//       // }
//     } catch (ex) {
//       assert(() {
//         print(ex.toString());
//         return true;
//       }());
//     }
//   }

//   getIcon(String source) {
//     if (source == "SAP") {
//       return myIconSap;
//     } else if (source == "SIGMA") {
//       //    return BitmapDescriptor.fromAsset("assets/SIGMA.png");
//       return myIconSigma;
//     } else if (source == "UST02") {
//       //   return BitmapDescriptor.fromAsset("assets/UST02.png");
//       return myIconUST02;
//     } else if (source == "SPOBBER") {
//       //   return BitmapDescriptor.fromAsset("assets/UST02.png");
//       return myIconSpobber;
//     }
//   }

//   final favoritePlaceController = TextEditingController();
//   _favoritePlaces(double lat, double long, String readableid, String source,
//       String secretId, String type) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var imageData;
//     print(source);
//     if (source == "SAP") {
//       imageData = "assets/SAP.png";
//     } else if (source == "SIGMA") {
//       imageData = "assets/SIGMA.png";
//       print(imageData);
//     } else if (source == "UST02") {
//       imageData = "assets/UST02.png";
//     } else if (source == "SPOBBER") {
//       imageData = "assets/spobber_icon.png";
//     } else {
//       return;
//     }
//     print(imageData);

//     /// get the favorite position then added to prefs
//     var placeName = readableid;

//     ///convert position to string and concat it
//     ///array 0 is latitude
//     ///array 1 is longitude
//     ///array 2 is imageData assets/imagename
//     ///array 3 is source
//     ///array 4 is secretid
//     ///array 5 is type
//     var placePosition = lat.toString() +
//         ',' +
//         long.toString() +
//         ',' +
//         imageData +
//         ',' +
//         source +
//         ',' +
//         secretId +
//         ',' +
//         type;

//     print('Place Name $placeName => $placePosition Captured.');
//     await prefs.setString(
//       '__$placeName',
//       '$placePosition',
//     );
//     favoritePlaceController.clear();
//   }

//   Future<Uint8List> getBytesFromCanvas(String text, MaterialColor color) async {
//     final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
//     final Canvas canvas = Canvas(pictureRecorder);
//     final Paint paint1 = Paint()..color = color[400];
//     final Paint paint2 = Paint()..color = color[300];
//     final Paint paint3 = Paint()..color = color[100];
//     final int size = aggregationSetup.markerSize;
//     canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint3);
//     canvas.drawCircle(Offset(size / 2, size / 2), size / 2.4, paint2);
//     canvas.drawCircle(Offset(size / 2, size / 2), size / 3.3, paint1);
//     TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
//     painter.text = TextSpan(
//       text: text,
//       style: TextStyle(
//           fontSize: size / 4, color: Colors.black, fontWeight: FontWeight.bold),
//     );
//     painter.layout();
//     painter.paint(
//       canvas,
//       Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
//     );

//     final img = await pictureRecorder.endRecording().toImage(size, size);
//     final data = await img.toByteData(format: ui.ImageByteFormat.png);
//     return data.buffer.asUint8List();
//   }

//   MaterialColor getColor(int count) {
//     if (count <= aggregationSetup.maxAggregationItems[0]) {
//       // + 2
//       return aggregationSetup.colors[0];
//     } else if (count < aggregationSetup.maxAggregationItems[1]) {
//       // + 10
//       return aggregationSetup.colors[1];
//     } else if (count < aggregationSetup.maxAggregationItems[2]) {
//       // + 25
//       return aggregationSetup.colors[2];
//     } else if (count < aggregationSetup.maxAggregationItems[3]) {
//       // + 50
//       return aggregationSetup.colors[3];
//     } else if (count < aggregationSetup.maxAggregationItems[4]) {
//       // + 100
//       return aggregationSetup.colors[4];
//     } else if (count < aggregationSetup.maxAggregationItems[5]) {
//       // +500
//       return aggregationSetup.colors[5];
//     } else {
//       // + 1k
//       return aggregationSetup.colors[6];
//     }
//   }
// }
