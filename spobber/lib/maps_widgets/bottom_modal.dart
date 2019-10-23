import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:math' show cos, sqrt, asin;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spobber/data/place_response.dart';
import 'maps_body.dart';

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

  @override
  void initState() {
    _switchValue = widget.switchValue;
    super.initState();
  }

  int _selectedIndex = 0;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }
  

  Widget _buildContainer() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.blue[100],
          padding: EdgeInsets.symmetric(vertical: 15.0),
          height: 175.0,
          //  child:  ListView(scrollDirection: Axis.horizontal, children: formWidget),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.places.length,
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      _onSelected(index);
                   widget.gotoLocation(
                          widget.places[index].latitude, widget.places[index].longitude);

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
                                  border: Border.all(
                                    width: 5,
                                    color: _selectedIndex == index
                                        ? Colors.red
                                        : Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ),

                                //elevation: 14.0,

                                //  borderRadius: BorderRadius.circular(5.0),
                                // shadowColor: Color(0x802196F3),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    // Container(
                                    //   width: 100,
                                    //   height: 150,
                                    //   child: ClipRRect(
                                    //     borderRadius:
                                    //         new BorderRadius.circular(5.0),
                                    //     child: Image(
                                    //       fit: BoxFit.fitHeight,
                                    //       image: NetworkImage(
                                    //           places[index].preview_image_uri),
                                    //     ),
                                    //     child: Image(
                                    //       fit: BoxFit.fill,
                                    //       image: AssetImage("assets/spoor.jpg"),
                                    //     ),
                                    //   ),
                                    // ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: myDetailsContainer1(
                                            widget.places[index].id.toString(),
                                            widget.places[index].type
                                                .toString(),
                                            widget.places[index].status
                                                .toString(),
                                            widget
                                                .places[index].preview_image_uri
                                                .toString(),
                                            widget.places[index].latitude,
                                            widget.places[index].longitude),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        )),
                  )),
        ));

    //  }
  }

  Widget myDetailsContainer1(String id, String type, String status,
      String imginfo, double lat, double long) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Padding(
        //   padding: const EdgeInsets.all(15.0),
        //   child:
        Container(
            child: Text(
          type,
          style: TextStyle(
              color: Colors.blue,
              fontSize: 20.0,
              fontWeight: FontWeight.normal),
        )),
        //   Divider(),
        SizedBox(height: 5.0),
        Container(
          child: Text("Equipment:",
              style: TextStyle(
                fontSize: 18.0,
              )),
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
                        lat, long, widget.latitude, widget.longitude) +
                    " km",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                ),
              )),
            ])),
        SizedBox(height: 5.0),
        Container(
            child: Text(
          "Id: " + id,
          style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        )),
      ],
    );
  }

  //    void _showModal() {
  //   showModalBottomSheet<void>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return new Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             _buildContainer(),
  //           ],
  //         );
  //       });
  // }

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
