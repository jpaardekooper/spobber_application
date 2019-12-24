import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:math' show cos, sqrt, asin;

import '../../data/global_variable.dart';

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
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8)
      ..addListener(_onScroll);
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
    return Container(
        decoration: BoxDecoration(
          border: Border(          
            top: BorderSide(
              //                    <--- top side
              color: Theme.of(context).accentColor,
              width: 4.0,
            ),            
          ),
        ),
        child: Container(
          height: 125.0,
          color: Theme.of(context).primaryColor,
          width: MediaQuery.of(context).size.width,
          child: PageView.builder(
            controller: _pageController,
            itemCount: places.length,
            itemBuilder: (BuildContext context, int index) {
              return _coffeeShopList(index);
            },
          ),
        ));
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
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 20.0,
                ),
                height: 125.0,
                width: 275.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black87,
                        offset: Offset(0.0, 4.0),
                        blurRadius: 10.0,
                      ),
                    ]),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white),
                  child: Row(
                    children: [
                      Container(
                        height: 90.0,
                        width: 90.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0)),
                          image: getCorrectPhoto(index),
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Type: " + places[index].type,
                            style: TextStyle(
                                fontSize: 12.5, fontWeight: FontWeight.bold),
                          ),
                          places[index].equipmentId != '0'
                              ? Text(
                                  "Equipment: " + places[index].equipmentId.toString(),
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                )
                              : Text(
                                  "Bron: " + places[index].source,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                ),
                          places[index].placement != ""
                              ? Text(
                                  "Plaatsing: " + places[index].placement,
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w300),
                                )
                              : Text(""),
                          Text(
                            "Afstand: " +
                                calculateDistance(
                                    widget.latitude,
                                    widget.longitude,
                                    places[index].latitude,
                                    places[index].longitude) +
                                " meter",
                            style: TextStyle(
                                fontSize: 11.0, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getCorrectPhoto(int index) {
    if (places[index].source == "SAP") {
      return DecorationImage(
          image: AssetImage("assets/SAP.png"), fit: BoxFit.none);
    } else if (places[index].source == "SIGMA") {
      return DecorationImage(
          image: AssetImage("assets/SIGMA.png"), fit: BoxFit.none);
    } else if (places[index].source == "UST02") {
      return DecorationImage(
          image: AssetImage("assets/UST02.png"), fit: BoxFit.none);
    } else {
      print("geen marker gevonden");
    }
  }
}
