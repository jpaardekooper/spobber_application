import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spobber/clustering/lat_lang_geohash.dart';
import 'package:spobber/clustering/splash_bloc.dart';

import '../network/location_services.dart';

import 'history_view.dart';
import 'maps_view.dart';
import 'search_view.dart';

import 'widgets/error_view.dart';
import 'package:provider/provider.dart';

import 'widgets/drawer_filter.dart';

class Splash extends StatefulWidget {
  @override
  SplashState createState() {
    return SplashState();
  }
}

class SplashState extends State<Splash> {
  final SplashBloc bloc = SplashBloc();

  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            RaisedButton(
              child: Text('Load Fake Data into Memory'),
              onPressed: loading
                  ? null
                  : () async {
                      try {
                        setState(() {
                          loading = true;
                        });
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(list: new List<LatLngAndGeohash>()),
                          ),
                        );
                        setState(() {
                          loading = false;
                        });
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Column(
                              children: <Widget>[
                                Text('Error'),
                                Text(e.toString()),
                              ],
                            );
                          },
                        );
                      }
                    },
            ),
            loading ? CircularProgressIndicator() : Container(),
          ],
        ),
      ),
    );
  }
}
