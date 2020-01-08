import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spobber/data/place_response.dart';
import 'package:spobber/data/marker_detail.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';

//variable that needs to be checked in order to get data from the API
bool isSap = false;
bool isSigma = false;
bool isUST02 = false;
bool isVideo = false;
bool isSpobber = false;

bool switchValue1 = false;
bool switchValue2 = false;

List<String> setObjectType = new List<String>();
List<String> setDataSource = new List<String>();

int lastSelectedindex;
//all markers
List<PlaceResponse> places = new List<PlaceResponse>();

//single marker
List<PlaceResponse> singleMarker = new List<PlaceResponse>();
List<MarkerDetail> markerDetailandInformation = new List<MarkerDetail>();

String currentSelectedMarkerID;
String currentSelectedMarkerSecretID;
String currentSelectedMarkerObjectUri;

String singleMarkerObject = "";

MarkerId makeSelectedMarkerbigger;

String searchObject = "";

LatLng mylocation;

//icon animations;
BitmapDescriptor myIconSap;
BitmapDescriptor myIconSigma;
BitmapDescriptor myIconUST02;
BitmapDescriptor myIconSpobber;

