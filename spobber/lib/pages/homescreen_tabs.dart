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

// class TabsViewMaps extends StatefulWidget {
//   @override
//   _TabsState createState() => _TabsState();
// }

class TabsViewMaps extends StatelessWidget {
  // @override
  // void initState() {
  // //  super.initState();

  // }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    getData();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      //   setState(() {
      platformIsIOS = true;
      // });
    } else {
      //  setState(() {
      platformIsIOS = false;
      //   });
    }
    
     

    ErrorWidget.builder = getErrorWidget;
    return StreamProvider<UserLocation>(
      builder: (context) => LocationService().locationStream,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          body: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: false,
                primary: true,
                title: const Text(
                  'Spobber',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                actions: <Widget>[
               
                  
                    IconButton(
                    icon: const Icon(Icons.exit_to_app), color: Colors.white54,
                    onPressed: () => popupMessage(context),
                  ),
               
                
                ],
                flexibleSpace: Container(
                  color: Theme.of(context).primaryColor,
                ),
                bottom: TabBar(indicatorColor: Colors.white, tabs: <Widget>[
                  //Tab(icon: Icon(Icons.home), text: 'Home'),
                  new Container(
                    //      height: 50,
                    child: const Tab(
                      text: 'Kaart',
                    ),
                  ),
                  new Container(
                    //       height: 50,
                    child: const Tab(text: 'Zoeken'),
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
      ),
    );
  }

  static const double heightPop = 40;
  static const double widthPop = 80;

  void popupMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Afmelden'),
          content: const Text('Weet u zeker dat u wilt afmelden?'),
          actions: <Widget>[
            FlatButton(
              child: const Text("Annuleren"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Container(
                alignment: Alignment.center,
                height: heightPop,
                width: widthPop,
                color: Theme.of(context).primaryColor,
                child: const Text(
                  'Bevestigen',
                  style: const TextStyle(fontWeight: FontWeight.w600,
                       color: Colors.white),
                ),
              ),
              onPressed: () => goToLogin(context),
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

  void goToLogin(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //   setState(() {
    prefs.remove('user');
//    });
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/screen1', (Route<dynamic> route) => false);
  }
}
