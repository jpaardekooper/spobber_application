import "package:flutter/material.dart";
import 'package:spobber/data/place_response.dart';

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