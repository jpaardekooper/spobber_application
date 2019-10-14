import 'package:flutter/material.dart';
import 'places_search_map.dart';
import 'search_filter.dart';

class GoogleMapsApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GoogleMapsApp();
  }
}

class _GoogleMapsApp extends State<GoogleMapsApp> {
  static String keyword = "Es-las";

  void updateKeyWord(String newKeyword) {
    print(newKeyword);
    setState(() {
      keyword = newKeyword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // title: 'Spobber',
      // home: Scaffold(
      appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          //elevation: 0,
          backgroundColor: Colors.blue,
          // centerTitle: false,
          title: Text(
            'Filteren op: ' + keyword,
            //textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                    icon: Icon(Icons.filter_list),
                    tooltip: 'Filter Search',
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    });
              },
            ),
          ],
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    Icons.linear_scale,
                    size: 60.0,
                  ),
                 
                  Icon(
                    Icons.linear_scale,
                    size: 60.0,
                  ),
                  Icon(
                    Icons.linear_scale,
                    size: 60.0,
                  ),
                ],
              ))),
      body: PlacesSearchMapSample(keyword),
      endDrawer: SearchFilter(updateKeyWord),
      //     ),
    );
  }
}
