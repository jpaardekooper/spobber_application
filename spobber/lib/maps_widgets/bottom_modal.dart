import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:math' show cos, sqrt, asin;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spobber/data/place_response.dart';
import 'maps_body.dart';
import '../data/global_variable.dart';

class BottomSheetSwitch extends StatefulWidget {
  BottomSheetSwitch(
      {@required this.switchValue,
      @required this.valueChanged,
      @required this.places,
      @required this.latitude,
      @required this.longitude,
      @required this.gotoLocation});
  final List<PlaceResponse> places;
  final bool switchValue;
  final ValueChanged valueChanged;
  final double latitude;
  final double longitude;
  final Function gotoLocation;

  @override
  _BottomSheetSwitch createState() => _BottomSheetSwitch();
}

class _BottomSheetSwitch extends State<BottomSheetSwitch> {
  bool _switchValue;
  int _lengthOfPlaces;

  int _selectedIndex = 0;

  @override
  void initState() {
    _switchValue = widget.switchValue;
    _lengthOfPlaces = widget.places.length;

    // if(_selectedIndex == 0 && lastSelectedindex != 0){
    //   _selectedIndex = _selectedIndex;
    // }
    super.initState();
  }

  _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
      //  lastSelectedindex = _selectedIndex;
    });
  }

  Widget _returnImage(int index) {
    print(widget.places[index].previewImageUri.toString());
    if (_lengthOfPlaces < 0) {
      print("ik kom bij de niet gevulde data");
      return ClipRRect(
        borderRadius: new BorderRadius.circular(5.0),
        child: Image(
          fit: BoxFit.fitHeight,
          image: AssetImage("assets/marker_yellow.png"),
        ),
      );
    } else {
      print("ik kom bij de gevulde data");
      return ClipRRect(
        borderRadius: new BorderRadius.circular(5.0),
        child: Image(
            fit: BoxFit.fitHeight,
            image:
                NetworkImage(widget.places[index].previewImageUri.toString())),
      );
    }
  }

  Widget _buildContainer() {
    if (_lengthOfPlaces <= 0) {
      return Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15.0),
          height: 175.0,
          //  child:  ListView(scrollDirection: Axis.horizontal, children: formWidget),
          child: Text("Test"),
        ),
      );
    } else {
      return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 15.0),
            height: 175.0,
            //  child:  ListView(scrollDirection: Axis.horizontal, children: formWidget),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.places.length,
                itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        _onSelected(index);
                        widget.gotoLocation(widget.places[index].latitude,
                            widget.places[index].longitude);

                        //   Navigator.pop(context);
                        // _onMarkerTapped(places[index].);
                      },
                      // child: Container(
                      //   width: MediaQuery.of(context).size.width * 0.6,
                      //   child: Card(
                      //     color: _selectedIndex != null && _selectedIndex == index
                      //         ? Colors.red
                      //         : Colors.white,
                      //     child: Container(
                      //       child: Center(
                      //           child: Text(
                      //         places[index].id.toString(),
                      //         style: TextStyle(color: Colors.white, fontSize: 36.0),
                      //       )),
                      //     ),
                      child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Container(
                            color: Colors.white,
                            child: FittedBox(
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 5,
                                      color: _selectedIndex == index
                                          ? Colors.blue[800]
                                          : Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 8.0,
                                        color: Colors.black.withOpacity(.5),
                                        //     offset: Offset(3.0, 4.0),
                                      ),
                                    ],
                                  ),

                                  //elevation: 14.0,

                                  //  borderRadius: BorderRadius.circular(5.0),
                                  // shadowColor: Color(0x802196F3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          width: 100,
                                          height: 150,
                                          child: ClipRRect(
                                            borderRadius:
                                                new BorderRadius.circular(5.0),
                                            child: Image(
                                                fit: BoxFit.fitHeight,
                                                image: new NetworkImage(widget
                                                    .places[index]
                                                    .previewImageUri
                                                    .toString())),
                                          )),
                                      // Container(
                                      //   height: 100,
                                      //   width: 100,
                                      //   decoration: BoxDecoration(
                                      //     borderRadius:
                                      //         BorderRadius.circular(10),
                                      //     color: Colors.red,
                                      //   ),
                                      //   child: ClipRect(
                                      //     clipBehavior: Clip.hardEdge,
                                      //     child: OverflowBox(
                                      //       maxHeight: 100,
                                      //       maxWidth: 100,
                                      //       child: Center(
                                      //         child: Container(
                                      //           decoration: BoxDecoration(
                                      //             color: Colors.white,
                                      //             shape: BoxShape.circle,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: myDetailsContainer1(index),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          )),
                    )),
          ));
    }

    //  }
  }

  Widget myDetailsContainer1(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Padding(
        //   padding: const EdgeInsets.all(15.0),
        //   child:
        Container(
            child: Text(
          widget.places[index].source,
          style: TextStyle(
              color: Colors.blue,
              fontSize: 20.0,
              fontWeight: FontWeight.normal),
        )),
        Container(
            child: Text(
          widget.places[index].type,
          style: TextStyle(
              color: Colors.blue,
              fontSize: 20.0,
              fontWeight: FontWeight.normal),
        )),
        //   Divider(),
        SizedBox(height: 5.0),
        Container(
          child: Text("Equipment: \t" + widget.places[index].id.toString(),
              style: TextStyle(
                fontSize: 18.0,
              )),
        ),
        Container(
          child: Text(
            widget.places[index].placement,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
        // ),

        // Container(
        //     child: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: <Widget>[
        //     Container(
        //         child: Text(
        //       "Status ",
        //       style: TextStyle(
        //         color: Colors.black54,
        //         fontSize: 18.0,
        //       ),
        //     )),
        //     Container(
        //       child: Icon(
        //         FontAwesomeIcons.solidStar,
        //         color: Colors.amber,
        //         size: 15.0,
        //       ),
        //     ),
        //     Container(
        //       child: Icon(
        //         FontAwesomeIcons.solidStar,
        //         color: Colors.amber,
        //         size: 15.0,
        //       ),
        //     ),
        //     Container(
        //       child: Icon(
        //         FontAwesomeIcons.solidStar,
        //         color: Colors.amber,
        //         size: 15.0,
        //       ),
        //     ),
        //     Container(
        //       child: Icon(
        //         FontAwesomeIcons.solidStar,
        //         color: Colors.amber,
        //         size: 15.0,
        //       ),
        //     ),
        //     Container(
        //       child: Icon(
        //         FontAwesomeIcons.solidStarHalf,
        //         color: Colors.amber,
        //         size: 15.0,
        //       ),
        //     ),
        //   ],
        // )),

        SizedBox(height: 5.0),
        Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
              Container(
                  child: Text(
                "Afstand ",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                ),
              )),
              Container(
                  child: Text(
                calculateDistance(
                        widget.places[index].latitude,
                        widget.places[index].latitude,
                        widget.latitude,
                        widget.longitude) +
                    " km",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                ),
              )),
            ])),
        //SizedBox(height: 5.0),
        // Container(
        //     child: Text(
        //   "Id: " + id,
        //   style: TextStyle(
        //       color: Colors.black54,
        //       fontSize: 18.0,
        //       fontWeight: FontWeight.bold),
        // )),
      ],
    );
  }

  String calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

    var value = 12742 * asin(sqrt(a));
    return value.toStringAsFixed(3);
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: CupertinoSwitch(
    //     activeColor: Colors.red,
    //       value: _switchValue,
    //       onChanged: (bool value) {
    //         setState(() {
    //           _switchValue = value;
    //           widget.valueChanged(value);
    //         });
    //       }),
    // );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[_buildContainer()],
    );
  }
}
