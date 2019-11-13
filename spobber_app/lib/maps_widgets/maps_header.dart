import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/location_services.dart';
import 'package:provider/provider.dart';
import 'history_view.dart';
import 'maps_view.dart';
import 'ErrorView.dart';
import 'SearchView.dart';
import 'object_filter.dart';

class TabsViewMaps extends StatefulWidget {
  static String tag = 'tabs';
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<TabsViewMaps> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = getErrorWidget;
    return StreamProvider<UserLocation>(
      builder: (context) => LocationService().locationStream,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        body: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Spobber'),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  // Box decoration takes a gradient
                  gradient: LinearGradient(
                    // Where the linear gradient begins and ends
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    // Add one stop for each color. Stops should increase from 0 to 1
                    stops: [0.5, 0.9],
                    colors: [
                      // Colors are easy thanks to Flutter's Colors class.
                      Color(0xff0066C6),
                      Theme.of(context).accentColor,
                    ],
                  ),
                ),
              ),
              bottom: TabBar(tabs: <Widget>[
                //Tab(icon: Icon(Icons.home), text: 'Home'),
                new Container(
                  height: 70,
                  child: Tab(icon: Icon(Icons.my_location), text: 'Kaart'),
                ),
                new Container(
                  height: 70,
                  child: Tab(icon: Icon(Icons.search), text: 'Zoeken'),
                ),
                new Container(
                  height: 70,
                  child: Tab(icon: Icon(Icons.history), text: 'Geschiedenis'),
                ),
              ]),
            ),
            drawer:  ObjectFilter(),          
            body: TabBarView(
              //disable tabs scroll
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                // HomeView(),
                MyLocationView(),
                SearchView(),
                HistoryView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}