//  List<LatLng> pointsRed = <LatLng>[];
//   List<LatLng> pointsOrange = <LatLng>[];
//   List<LatLng> pointsGreen = <LatLng>[];
//   List<LatLng> pointsAll = <LatLng>[];

//   Future loadPolyline() async {
//     polylines.clear();
//     pointsAll.clear();
//     pointsOrange.clear();
//     pointsGreen.clear();
//     pointsRed.clear();

//     // List<UpperObject> objects;
//     String uri =
//         "https://spobberapi20190919041857.azurewebsites.net/api/measure/?nlat=90&blat=-90&nlon=90&blon=-90";

//     print(uri);

//     final response = await http.get(Uri.encodeFull(uri));
//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       UpperObject upperObject = new UpperObject.fromJson(jsonResponse);
//       print(upperObject.content.length);

//       print(upperObject.id.toString());
//       print(upperObject.content[6].latitude.toString());

//       for (int i = 0; i < upperObject.content.length; i++) {
//         print(upperObject.content[i].latitude);
//         pointsAll.add(_createLatLng(
//             upperObject.content[i].latitude, upperObject.content[i].longitude));

//         if (upperObject.content[i].value < 1600) {
//           pointsRed.add(_createLatLng(upperObject.content[i].latitude,
//               upperObject.content[i].longitude));
//         } else if (upperObject.content[i].value < 1800 &&
//             upperObject.content[i].value >= 1600) {
//           pointsOrange.add(_createLatLng(upperObject.content[i].latitude,
//               upperObject.content[i].longitude));
//         } else if (upperObject.content[i].value >= 1800) {
//           pointsGreen.add(_createLatLng(upperObject.content[i].latitude,
//               upperObject.content[i].longitude));
//         }
//       }
//       final String polylineIdVal = 'polyline_id_ALL';
//       final PolylineId polylineId = PolylineId(polylineIdVal);

//       final Polyline polylineAll = Polyline(
//         polylineId: polylineId,
//         consumeTapEvents: true,
//         color: Colors.blue,
//         width: 5,
//         points: pointsAll,
//         zIndex: 0,
//         onTap: () {
//           _onPolylineTapped(polylineId);
//         },
//       );

//       setState(() {
//         polylines[polylineId] = polylineAll;
//       });

//       final String polylineIdValRed = 'polyline_id_Red';
//       final PolylineId polylineIdRed = PolylineId(polylineIdValRed);

//       final Polyline polylineRed = Polyline(
//           polylineId: polylineIdRed,
//           consumeTapEvents: false,
//           color: Colors.red,
//           width: 4,
//           points: pointsRed,
//           zIndex: 1);

//       setState(() {
//         polylines[polylineIdRed] = polylineRed;
//       });

//       final String polylineIdValOrange = 'polyline_id_Orange';
//       final PolylineId polylineIdOrange = PolylineId(polylineIdValOrange);

//       final Polyline polylineOrange = Polyline(
//           polylineId: polylineIdOrange,
//           consumeTapEvents: false,
//           color: Colors.orange,
//           width: 4,
//           points: pointsOrange,
//           zIndex: 2);

//       setState(() {
//         polylines[polylineIdOrange] = polylineOrange;
//       });

//       final String polylineIdValGreen = 'polyline_id_Green';
//       final PolylineId polylineIdGreen = PolylineId(polylineIdValGreen);

//       final Polyline polylineGreen = Polyline(
//           polylineId: polylineIdGreen,
//           consumeTapEvents: false,
//           color: Colors.green,
//           width: 4,
//           points: pointsGreen,
//           zIndex: 3);

//       setState(() {
//         polylines[polylineIdGreen] = polylineGreen;
//       });
//     }
//   }

//   LatLng _createLatLng(double lat, double lng) {
//     return LatLng(lat, lng);
//   }


// Map<CircleId, Circle> circles = <CircleId, Circle>{};
//   int _circleIdCounter = 1;
//   CircleId selectedCircle;

//   void _onCircleTapped(CircleId circleId) {
//     setState(() {
//       selectedCircle = circleId;
//       _remove();
//     });
//   }

//   void _remove() {
//     setState(() {
//       circles.clear();
//       if (circles.containsKey(selectedCircle)) {
//         circles.remove(selectedCircle);
//       }
//       selectedCircle = null;
//     });
//   }

//   void _add2(double lat, double long) {
//     circles.clear();
//     final int circleCount = circles.length;

//     if (circleCount == 12) {
//       return;
//     }

//     final String circleIdVal = 'circle_id_$_circleIdCounter';
//     _circleIdCounter++;
//     final CircleId circleId = CircleId(circleIdVal);

//     final Circle circle = Circle(
//       circleId: circleId,
//       consumeTapEvents: true,
//       strokeColor: Colors.red,
//       fillColor: Colors.red[100].withOpacity(0.1),
//       strokeWidth: 2,
//       center: LatLng(lat, long),
//       radius: 2,
//       onTap: () {
//         _onCircleTapped(circleId);
//       },
//     );

//     setState(() {
//       circles[circleId] = circle;
//     });
//   }

//   Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};

//   PolylineId selectedPolyline;

//   void _onPolylineTapped(PolylineId polylineId) {
//     setState(() {
//       selectedPolyline = polylineId;
//     });
//   }
