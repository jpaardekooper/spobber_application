import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spobber/maps_widgets/maps_header.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:math' show cos, sqrt, asin;

import '../data/global_variable.dart';

class BottomSheetSwitch extends StatefulWidget {
  BottomSheetSwitch({
    //  @required this.places,
    @required this.latitude,
    @required this.longitude,
    @required this.gotoLocation,
  });
  //final List<PlaceResponse> places;

  final double latitude;
  final double longitude;
  final Function gotoLocation;

  @override
  _BottomSheetSwitch createState() => _BottomSheetSwitch();
}

class _BottomSheetSwitch extends State<BottomSheetSwitch> {
  PageController _pageController;

  int prevPage;


  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
  }

  // _onSelected(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //     //  lastSelectedindex = _selectedIndex;
  //   });
  // }

  // Widget _returnImage(int index) {
  //   print(places[index].previewImageUri.toString());
  //   if (_lengthOfPlaces < 0) {
  //     print("ik kom bij de niet gevulde data");
  //     return  Image(
  //         fit: BoxFit.fitHeight,
  //         image: AssetImage("assets/marker_yellow.png"),
  //       );
      
  //   } else {
  //     print("ik kom bij de gevulde data");
  //     return Image(
  //           fit: BoxFit.fitHeight,
  //           image: NetworkImage(places[index].previewImageUri.toString()),
  //     );
  //   }
  // }

  // Widget _buildContainer() {
  //   return Align(
  //       alignment: Alignment.bottomCenter,
  //       child: Container(
  //         color: Colors.white,
  //         padding: EdgeInsets.symmetric(vertical: 15.0),
  //         height: 175.0,
  //         //  child:  ListView(scrollDirection: Axis.horizontal, children: formWidget),
  //         child: ListView.builder(
  //             scrollDirection: Axis.horizontal,
  //             itemCount: places.length,
  //             itemBuilder: (context, index) => GestureDetector(
  //                   onTap: () {
  //                     _onSelected(index);
  //                     widget.gotoLocation(
  //                         places[index].latitude, places[index].longitude);

  //                     //   Navigator.pop(context);
  //                     // _onMarkerTapped(places[index].);
  //                   },
  //                   // child: Container(
  //                   //   width: MediaQuery.of(context).size.width * 0.6,
  //                   //   child: Card(
  //                   //     color: _selectedIndex != null && _selectedIndex == index
  //                   //         ? Colors.red
  //                   //         : Colors.white,
  //                   //     child: Container(
  //                   //       child: Center(
  //                   //           child: Text(
  //                   //         places[index].id.toString(),
  //                   //         style: TextStyle(color: Colors.white, fontSize: 36.0),
  //                   //       )),
  //                   //     ),
  //                   child: Padding(
  //                       padding: EdgeInsets.all(8),
  //                       child: Container(
  //                         color: Colors.white,
  //                         child: FittedBox(
  //                           child: Container(
  //                               decoration: BoxDecoration(
  //                                 color: Colors.white,
  //                                 border: Border.all(
  //                                   width: 5,
  //                                   color: _selectedIndex == index
  //                                       ? Colors.blue[800]
  //                                       : Color.fromRGBO(255, 255, 255, 1),
  //                                 ),
  //                                 boxShadow: [
  //                                   BoxShadow(
  //                                     blurRadius: 8.0,
  //                                     color: Colors.black.withOpacity(.5),
  //                                     //     offset: Offset(3.0, 4.0),
  //                                   ),
  //                                 ],
  //                               ),

  //                               //elevation: 14.0,

  //                               //  borderRadius: BorderRadius.circular(5.0),
  //                               // shadowColor: Color(0x802196F3),
  //                               child: Row(
  //                                 mainAxisAlignment:
  //                                     MainAxisAlignment.spaceBetween,
  //                                 children: <Widget>[
  //                                   Container(
  //                                       width: 100,
  //                                       height: 150,
  //                                       child: ClipRRect(
  //                                         borderRadius:
  //                                             new BorderRadius.circular(5.0),
  //                                         child: Image(
  //                                             fit: BoxFit.fitHeight,
  //                                             image: places[index]
  //                                                         .previewImageUri
  //                                                         .toString() !=
  //                                                     null
  //                                                 ? new NetworkImage(
  //                                                     places[index]
  //                                                         .previewImageUri
  //                                                         .toString())
  //                                                 : new AssetImage(
  //                                                     "assets/no_image.png")),
  //                                       )),
  //                                   Container(
  //                                     child: Padding(
  //                                       padding: const EdgeInsets.all(15.0),
  //                                       child: myDetailsContainer1(index),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               )),
  //                         ),
  //                       )),
  //                 )),
  //       ));
  // }

  // //  }

  // Widget myDetailsContainer1(int index) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       // Padding(
  //       //   padding: const EdgeInsets.all(15.0),
  //       //   child:
  //       Container(
  //           child: Text(
  //         places[index].source,
  //         style: TextStyle(
  //             color: Colors.blue,
  //             fontSize: 20.0,
  //             fontWeight: FontWeight.normal),
  //       )),
  //       Container(
  //           child: Text(
  //         places[index].type,
  //         style: TextStyle(
  //             color: Colors.blue,
  //             fontSize: 20.0,
  //             fontWeight: FontWeight.normal),
  //       )),
  //       //   Divider(),
  //       SizedBox(height: 5.0),
  //       Container(
  //         child: Text("Equipment: \t" + places[index].id.toString(),
  //             style: TextStyle(
  //               fontSize: 18.0,
  //             )),
  //       ),
  //       Container(
  //         child: Text(
  //           places[index].placement,
  //           style: TextStyle(
  //             fontSize: 18.0,
  //           ),
  //         ),
  //       ),
    

  //       SizedBox(height: 5.0),
  //       Container(
  //           child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: <Widget>[
  //             Container(
  //                 child: Text(
  //               "Afstand ",
  //               style: TextStyle(
  //                 color: Colors.black54,
  //                 fontSize: 18.0,
  //               ),
  //             )),
  //             Container(
  //                 child: Text(
  //               calculateDistance(
  //                     widget.latitude,
  //                     widget.longitude,
  //                     places[index].latitude,
  //                     places[index].latitude,
  //                   ) +
  //                   " km",
  //               style: TextStyle(
  //                 color: Colors.black54,
  //                 fontSize: 18.0,
  //               ),
  //             )),
  //           ])),
  //       //SizedBox(height: 5.0),
  //       // Container(
  //       //     child: Text(
  //       //   "Id: " + id,
  //       //   style: TextStyle(
  //       //       color: Colors.black54,
  //       //       fontSize: 18.0,
  //       //       fontWeight: FontWeight.bold),
  //       // )),
  //     ],
  //   );
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
    // return Column(
    //   mainAxisSize: MainAxisSize.min,
    //   crossAxisAlignment: CrossAxisAlignment.stretch,
    //   children: <Widget>[_buildContainer()],
    // );
    return Container(
      height: 200.0,
      //color: Color(0xFF0E3311).withOpacity(0.5),
      color: Theme.of(context).canvasColor ,
      width: MediaQuery.of(context).size.width,
      child: PageView.builder(
        controller: _pageController,
        itemCount: places.length,
        itemBuilder: (BuildContext context, int index) {
          return _coffeeShopList(index);
        },
      ),
    );
  }

  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();

      moveCamera();
    }
  }

  moveCamera() {
    widget.gotoLocation(places[_pageController.page.toInt()].latitude,
        places[_pageController.page.toInt()].longitude);
  }

  _coffeeShopList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
          onTap: () {
            // moveCamera();
          },
          child: Stack(children: [
            Center(
                child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    height: 125.0,
                    width: 275.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            offset: Offset(0.0, 4.0),
                            blurRadius: 10.0,
                          ),
                        ]),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white),
                        child: Row(children: [
                          Container(
                              height: 90.0,
                              width: 90.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0)),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/ic_launcher.png"),
                                      fit: BoxFit.cover))),
                          SizedBox(width: 5.0),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  places[index].type,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  places[index].id.toString(),
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  width: 170.0,
                                  child: Text(
                                    places[index].placement,
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                )
                              ])
                        ]))))
          ])),
    );
  }
}
