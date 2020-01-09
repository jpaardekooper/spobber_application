import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spobber/data/global_variable.dart';

import 'package:spobber/network/location_services.dart';
import 'package:provider/provider.dart';
import 'package:spobber/pages/search_view.dart';
import 'package:spobber/pages/widgets/page.dart';
import 'history_view.dart';
import 'maps_view.dart';
import 'widgets/error_view.dart';

import 'widgets/drawer_filter.dart';

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
        key: _scaffoldKey,
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Spobber',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              // actions: <Widget>[
              //   IconButton(
              //     icon: Icon(Icons.info),
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (context) => TutorialSpot()),
              //       );
              //     },
              //   )
              // ],
              flexibleSpace: Container(
                color: Theme.of(context).primaryColor,
              ),
              bottom: TabBar(indicatorColor: Colors.white, tabs: <Widget>[
                //Tab(icon: Icon(Icons.home), text: 'Home'),
                new Container(
                  //      height: 50,
                  child: Tab(
                    icon: Icon(Icons.my_location),
                    text: 'Kaart',
                  ),
                ),
                new Container(
                  //       height: 50,
                  child: Tab(icon: Icon(Icons.search), text: 'Zoeken'),
                ),
                // new Container(
                //   height: 70,
                //   child: Tab(icon: Icon(Icons.history), text: 'Geschiedenis'),
                // ),
                // new Container(
                //   height: 70,
                //   child: Tab(icon: Icon(Icons.history), text: 'Tensorflow'),
                // ),
              ]),
            ),
            drawer: DrawerFilter(),
            body: TabBarView(
              //disable tabs scroll
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                // HomeView(),
                MapView(),
                SearchView(),
                //       HistoryView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
