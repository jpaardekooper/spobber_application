import 'package:flutter/material.dart';
import 'places_search_map.dart';
import 'search_filter.dart';


class GoogleMapsApp extends StatefulWidget {
  static String tag = 'Maps';
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
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // title: 'Spobber',
      // home: Scaffold(
      appBar: AppBar(
          centerTitle: true,
          // iconTheme: IconThemeData(color: Colors.white),
         elevation: 0,
          // backgroundColor: Colors.blue,
          // centerTitle: false,
          title: Text(
            'Filteren op: ' + keyword,
            //textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16),
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
          // bottom: PreferredSize(
          //     preferredSize: Size.fromHeight(50.0),
          //     child: Row(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: <Widget>[
          //           Stack(
          //             children: <Widget>[
          //               Padding(
          //                   padding: EdgeInsets.all(15),
          //                   child: Row(
          //                     children: <Widget>[
          //                       Icon(
          //                         Icons.drafts,
          //                         color: Colors.white,
          //                         size: 20.0,
          //                       ),
          //                       Text("data",
          //                           style: TextStyle(color: Colors.white)),
          //                     ],
          //                   ))
          //             ],
          //           ),
                  
          //               Stack(
          //                 children: <Widget>[
          //                   Padding(
          //                       padding: EdgeInsets.all(15),
          //                       child: Row(
          //                         children: <Widget>[
          //                           Icon(
          //                             Icons.notifications,
          //                             color: Colors.red,
          //                             size: 20.0,
          //                           ),
          //                           Text("15",
          //                               style: TextStyle(color: Colors.white)),
          //                         ],
          //                       ))
          //                 ],
          //               ),
          //             ],
          //           )
          //         )),
      ),
      drawer: _buildDrawer(context),
      body: PlacesSearchMapSample(keyword),
      endDrawer: SearchFilter(updateKeyWord),
      //     ),
    );
  }
}

Widget _buildDrawer(context) {

return Drawer(
      // column holds all the widgets in the drawer
      child: Column(
        children: <Widget>[
          Expanded(
            // ListView contains a group of widgets that scroll inside the drawer
            child: ListView(
              children: <Widget>[
       //         UserAccountsDrawerHeader(),
                DrawerHeader(
        child: Text('Heading'),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
      ),
      
        ListTile(
        leading: Icon(Icons.map),
        title: Text('Maps'),
        onTap: () {
          // Update the state of the app
          // ...
          // Then close the drawer
          Navigator.pop(context);
        },
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.show_chart),
        title: Text('Statistiek'),
        onTap: () {
          // Update the state of the app
          // ...
          // Then close the drawer
          print("pressed item 2");
          Navigator.pop(context);
        },
      ),
       Divider(),
      ListTile(
        leading: Icon(Icons.history),
        title: Text('Geschiedenis'),
        onTap: () {
          // Update the state of the app
          // ...
          // Then close the drawer
          Navigator.pop(context);
        },
      ),
       Divider(),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text('Account'),
        onTap: () {
          // Update the state of the app
          // ...
          // Then close the drawer
          print("pressed item 2");
          Navigator.pop(context);
        },
      ),
       Divider(),
              ],
            ),
          ),
          // This container holds the align
          Container(
              // This align moves the children to the bottom
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  // This container holds all the children that will be aligned
                  // on the bottom and should not scroll with the above ListView
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      Divider(),
                      ListTile(
                          leading: Icon(Icons.settings),
                          title: Text('Settings')),
                          
                      ListTile(
                          leading: Icon(Icons.help),
                          title: Text('Help and Feedback')),

                            ListTile(
                          //leading: Icon(Icons.help),
                          title: Text('Versie 1.0.0', style: TextStyle(fontWeight: FontWeight.w200),))
                    ],
                  )
                )
              )
            )
        ],
      ),
    );
  }