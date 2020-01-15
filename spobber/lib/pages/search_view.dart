import 'package:flutter/material.dart';

//import 'package:latlong/latlong.dart';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:spobber/data/place_response.dart';

import 'package:http/http.dart' as http;
import 'package:spobber/pages/widgets/show_toast.dart';
import 'package:spobber/pages/widgets/single_marker_with_maps.dart';

import '../data/global_variable.dart';
import 'dart:async';
import '../data/place_response.dart';
import 'package:toast/toast.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  //to retrieve position from TextField
  final myController = TextEditingController();
  //final favoritePlaceController = TextEditingController();

  //ClusteringHelper clusteringHelper;

  ///changes after declaring the desired location
  // Widget _searchView;
  double lat = 0.00;
  double long = 0.00;
  bool _empty = false;
  String placeName = "";
  String placePosition = "";

  bool isButtonDisabled = false;

  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  Widget inputContainer() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              cursorColor: Colors.black,
              controller: myController,
              focusNode: _searchField,
              onFieldSubmitted: (value) {
                _searchField.unfocus();
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(
                  Icons.location_searching,
                  //      color: Colors.teal,
                ),

                //border color
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                // focused border color (erasing theme default color [teal])
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.black)),
                errorText: _empty ? 'Foute invoer' : null,
                hintText: 'Vul de ID van het object in',
                hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
              ),
              style: TextStyle(fontSize: 20.00, color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text("Zoeken"),
                color: isButtonDisabled
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).accentColor,
                textColor: Colors.white,
                onPressed: isButtonDisabled
                    ? null
                    : () async {
                        _searchField.unfocus();
                        myController.text.isEmpty
                            ? _empty = true
                            : _empty = false;
                        //TexField not empty
                        if (_empty == false) {
                          singleMarker.clear();
                          String url =
                              "https://spobber.azurewebsites.net/api/objects/${myController.text}";
                          print(url);

                          final response = await http.get(url);
                          fillMarkerList(response).then((value) {
                            if (value) {
                              if (singleMarker[0].readableID == "0" ||
                                  singleMarker[0].readableID == null) {
                                showToast(
                                    "Geen geldig equipment nummer gevonden",
                                    context,
                                    gravity: Toast.CENTER,
                                    duration: Toast.LENGTH_LONG);
                              } else {
                                showToast(
                                    "Object id: ${myController.text} wordt geladen",
                                    context,
                                    gravity: Toast.CENTER,
                                    duration: Toast.LENGTH_SHORT);

                             

                                setState(() {
                                  this.lat = singleMarker[0].latitude;
                                  this.long = singleMarker[0].longitude;
                                });
                              }
                            }
                          });
                        }
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  final FocusNode _searchField = FocusNode();

  Future<bool> fillMarkerList(http.Response response) async {
    //  setState(() {
    singleMarker.clear();
//    });
    if (response.statusCode == 200) {
      // final data = json.decode(response.body);
      singleMarker = (json.decode(response.body) as List)
          .map((data) => new PlaceResponse().fromJson(data))
          .toList();

      //  print(response.body);
      return true;
    } else {
      print("url is niet gevonden");
      //throw Exception('An error occurred getting places nearby');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if ((lat == 0.00 || long == 0.00)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[inputContainer()],
      );
    } else {
      return SingleMarkerWithMaps();
    }
  }
}
