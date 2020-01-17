import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spobber/clustering/map_marker.dart';

import 'dart:math' show cos, sqrt, asin;

import 'package:spobber/data/global_variable.dart';

//import '../../data/global_variable.dart';

class BottomSheetSwitch extends StatefulWidget {
  BottomSheetSwitch({
    @required this.markers,
    @required this.latitude,
    @required this.longitude,
    @required this.gotoLocation,
    @required this.openMarkerInfo,
  });
  final List<MapMarker> markers;

  final double latitude;
  final double longitude;
  final Function gotoLocation;
  final Function openMarkerInfo;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          color: Theme.of(context).accentColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Swipe naar beneden om te sluiten",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              )
            ],
          ),
        ),
        Container(
          height: 125.0,
          color: Theme.of(context).primaryColor,
          width: MediaQuery.of(context).size.width,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.markers.length,
            itemBuilder: (BuildContext context, int index) {
              return _coffeeShopList(index);
            },
          ),
        ),
      ],
    );
  }

  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();

      moveCamera();
    }
  }

  moveCamera() {
    widget.gotoLocation(widget.markers[_pageController.page.toInt()].latitude,
        widget.markers[_pageController.page.toInt()].longitude);
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
        onDoubleTap: () async {
          setState(() {
            currentSelectedMarkerID = widget.markers[index].readableId;
            currentSelectedMarkerObjectUri = widget.markers[index].objectUri;
            currentSelectedMarkerSecretID = widget.markers[index].secretId;
          });

          widget.openMarkerInfo();
        },
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(
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
                        offset: const Offset(0.0, 4.0),
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
                        width: 45.0,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: const Radius.circular(10.0),
                              topLeft: const Radius.circular(10.0)),
                          image: getCorrectPhoto(index),
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ophaal ID: " + widget.markers[index].readableId,
                            style: const TextStyle(
                                fontSize: 12.5, fontWeight: FontWeight.bold),
                          ),
                          widget.markers[index].equipment != '0'
                              ? Text(
                                  "Equipment: " +
                                      widget.markers[index].equipment,
                                  style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                )
                              : Text(
                                  "Bron: " + widget.markers[index].source,
                                  style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                ),
                          widget.markers[index].placement != ""
                              ? Text(
                                  "Plaatsing: " +
                                      widget.markers[index].placement,
                                  style: const TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w300),
                                )
                              : const Text(""),
                          Text(
                            "Afstand: " +
                                calculateDistance(
                                    widget.latitude,
                                    widget.longitude,
                                    widget.markers[index].latitude,
                                    widget.markers[index].longitude) +
                                " km",
                            style: const TextStyle(
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
    if (widget.markers[index].source == "SAP") {
      return const DecorationImage(
          image: AssetImage("assets/SAP.png"), fit: BoxFit.none);
    } else if (widget.markers[index].source == "SIGMA") {
      return const DecorationImage(
          image: AssetImage("assets/SIGMA.png"), fit: BoxFit.none);
    } else if (widget.markers[index].source == "UST02") {
      return const DecorationImage(
          image: AssetImage("assets/UST02.png"), fit: BoxFit.none);
    } else if (widget.markers[index].source == "SPOBBER") {
      return const DecorationImage(
          image: AssetImage("assets/spobber_icon.png"), fit: BoxFit.none);
    } else {}
  }
}
