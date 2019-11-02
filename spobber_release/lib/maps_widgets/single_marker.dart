import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spobber_release/data/place_response.dart';
import 'package:spobber_release/marker_information/marker_template.dart';
import 'package:http/http.dart' as http;
import '../data/global_variable.dart';
import 'dart:async';
import '../data/place_response.dart';
import 'package:toast/toast.dart';

// Define a custom Form widget.
class SingleMarker extends StatefulWidget {
  SingleMarker({Key key}) : super(key: key);

  @override
  _SingleMarkerState createState() => _SingleMarkerState();
}

class _SingleMarkerState extends State<SingleMarker> {
  final _formKey = GlobalKey<FormState>();

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 180,
            height: 25,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: TextFormField(
                decoration: InputDecoration(
                  // icon: Icon(Icons.check_box_outline_blank),
                  fillColor: Colors.black,
                  hintText: 'Equipment',
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.only(left: 10, bottom: 15),
                   border: InputBorder.none,
                  //  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0)),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return;
                  } else {
                    singleMarkerObject = value;
                  }
                  //    return null;
                },
              ),
            ),
          ),
          Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: SizedBox.fromSize(
            size: Size(30, 30), // buton width and height
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.blue[600], // splash color
                onTap: () async {
                  if (_formKey.currentState.validate()) {
                    print(singleMarkerObject);
                    String url =
                        "https://spobber.azurewebsites.net/api/objects/$singleMarkerObject";
                    print(url);
                    final response = await http.get(url);
                    fillMarkerList(response).then((value) {
                      if (value) {
                        if (singleMarker.first.id == 0) {
                          showToast("Geen geldige equipment gevonden",
                              gravity: Toast.BOTTOM,
                              duration: Toast.LENGTH_LONG);
                        } else {
                          showToast(
                              "Object id: $singleMarkerObject wordt geladen",
                              gravity: Toast.BOTTOM,
                              duration: Toast.LENGTH_SHORT);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MarkerTemplate(
                                type: singleMarker[0].type,
                                objectUri: singleMarker[0].objectUri,
                                id: singleMarker[0].id,
                                secretId: singleMarker[0].secretId,
                              ),
                            ),
                          );

                          print("niet leeg");
                        }
                      } else {
                        print("error handling url");
                      }
                    });
                    // Process data.
                  }
                }, // button pressed
                child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> fillMarkerList(http.Response response) async {
    setState(() {
      singleMarker.clear();
    });
    if (response.statusCode == 200) {
      // final data = json.decode(response.body);
      singleMarker = (json.decode(response.body) as List)
          .map((data) => new PlaceResponse().fromJson(data))
          .toList();

      return true;
    } else {
      print("url is niet gevonden");
      //throw Exception('An error occurred getting places nearby');
      return false;
    }
  }
}
