import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spobber/data/Users.dart';
import 'package:spobber/data/global_variable.dart';

import 'package:spobber/network/location_services.dart';
import 'package:provider/provider.dart';
import 'package:spobber/pages/search_view.dart';
import 'maps_view.dart';
import 'widgets/error_view.dart';

import 'widgets/drawer_filter.dart';

class TabsViewMaps extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<TabsViewMaps> {

  @override
  void initState() {
    super.initState();
    getData();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      setState(() {
        platformIsIOS = true;
      });
    } else {
      setState(() {
        platformIsIOS = false;
      });
    }
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
                actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => popupMessage(),
          ),
        ],
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

  
  void popupMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Container(
                alignment: Alignment.center,
                height: 40,
                width: 80,
                color: Color(0xFF0062A5),
                child: Text(
                  'Confirm',
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ),
              onPressed: () => goToLogin(),
            ),
          ],
        );
      },
    );
  }

  Future<User> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String item = prefs.getString('user');
    userInformation = User.fromJson(json.decode(item));
    return userInformation;
  }

  void goToLogin() async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.remove('user');
    });
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/screen1', (Route<dynamic> route) => false);
  }
}
