import "package:flutter/material.dart";
import 'package:spobber/data/place_response.dart';
import 'package:spobber/data/marker_detail.dart';

//variable that needs to be checked in order to get data from the API
bool isSap = false;
bool isSigma = false;
bool isUST02 = false;
bool isVideo = false;

bool switchValue1 = false;
bool switchValue2 = false;

List<String> setObjectType = new List<String>();
List<String> setDataSource = new List<String>();

int lastSelectedindex;

List<PlaceResponse> places = new List<PlaceResponse>();
List<MarkerDetail> markerDetailandInformation = new List<MarkerDetail>();

String currentSelectedMarkerID;
String currentSelectedMarkerSecretID;
String currentSelectedMarkerObjectUri;