import 'package:flutter/material.dart';
import 'maps_widget.dart';

Widget _buildDrawer(context) {
  return Drawer(
    
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: <Widget>[
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
    ],
  ));
}

class HomePage extends StatelessWidget {
  static String tag = 'Dashboard';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Color primaryColor = Color.fromRGBO(6, 71, 138, 1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: _buildDrawer(context),
        body: Container(
            color: Color(0xFFEFEEF5),
            child: Column(children: <Widget>[
              Stack(children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  constraints: BoxConstraints.expand(height: 225),
                  decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [primaryColor, primaryColor],
                          begin: const FractionalOffset(1.0, 1.0),
                          end: const FractionalOffset(0.2, 0.1),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  child: Container(
                    padding: EdgeInsets.only(top: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.menu),
                          color: Colors.white,
                          iconSize: 30.0,
                          onPressed: () =>
                              _scaffoldKey.currentState.openDrawer(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            "Dashboard",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.power_settings_new),
                          color: Colors.white,
                          iconSize: 30.0,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  // backgroundColor: Color.fromRGBO(244, 244, 244, 1),
                  // body: SingleChildScrollView(
                  child: Column(
                    //  crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 230.0),
                            child: Container(
                              // width: double.infinity,
                              // height: 500.0,
                              // decoration: BoxDecoration(
                              //     color: Colors.blueGrey,
                              //     borderRadius:
                              //         BorderRadius.all(Radius.circular(15.0)),
                              //     boxShadow: [
                              //       BoxShadow(
                              //           color: Colors.black.withOpacity(0.1),
                              //           offset: Offset(0.0, 5.0),
                              //           blurRadius: 15.0)
                              //     ]),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        //maps container
                                        Container(
                                          margin: EdgeInsets.only(
                                             top:10, right: 0, left: 0, bottom: 10),
                                          height: 180,
                                          width: 110,
                             
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                            boxShadow: [
                                              new BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 10.0,
                                              ),
                                            ],
                                          ),
                                          child: 
                                          Padding(padding: EdgeInsets.only(top: 50),child:
                                          Column(
                                            children: <Widget>[
                                              Material(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                color: Colors.blue
                                                    .withOpacity(0.1),
                                                child: IconButton(
                                                  
                                                  padding: EdgeInsets.all(15.0),
                                                  icon: Icon(Icons.map),
                                                  color: Colors.blue,
                                                  iconSize: 30.0,
                                                  onPressed: () {
                                                   // Navigator.pop(context);
                                                    
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              GoogleMapsApp()),
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(height: 8.0),
                                              Text('Maps',
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                        ),
                                        ),
                                        //end maps container

                                        //new container
                                       Container(
                                          margin: EdgeInsets.only(
                                             top:10, right: 0, left: 0, bottom: 10),
                                          height: 180,
                                          width: 110,
                             
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                            boxShadow: [
                                              new BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 10.0,
                                              ),
                                            ],
                                          ),
                                          child: 
                                          Padding(padding: EdgeInsets.only(top: 50),child:
                                          Column(
                                          children: <Widget>[
                                            Material(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              color: Colors.purple
                                                  .withOpacity(0.1),
                                              child: IconButton(
                                                padding: EdgeInsets.all(15.0),
                                                icon: Icon(Icons.show_chart),
                                                color: Colors.purple,
                                                iconSize: 30.0,
                                                onPressed: () {},
                                              ),
                                            ),
                                            SizedBox(height: 8.0),
                                            Text('Statistiek',
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),)),


                                        //new
                                    Container(
                                          margin: EdgeInsets.only(
                                             top:10, right: 0, left: 0, bottom: 10),
                                          height: 180,
                                          width: 110,
                             
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                            boxShadow: [
                                              new BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 10.0,
                                              ),
                                            ],
                                          ),
                                          child: 
                                          Padding(padding: EdgeInsets.only(top: 50),child:
                                          Column(
                                          children: <Widget>[
                                            Material(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              color: Colors.orange
                                                  .withOpacity(0.1),
                                              child: IconButton(
                                                padding: EdgeInsets.all(15.0),
                                                icon: Icon(Icons.history),
                                                color: Colors.orange,
                                                iconSize: 30.0,
                                                onPressed: () {},
                                              ),
                                            ),
                                            SizedBox(height: 8.0),
                                            Text('Activiteit',
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ))),
                                      ],
                                    ),
                                  ),
                                ]
                                    ),
                                  ),
                                  // SizedBox(height: 10.0),
                                  // Divider(),
                                  // SizedBox(height: 10.0),
                                  // Padding(
                                  //   padding:
                                  //       EdgeInsets.symmetric(horizontal: 25.0),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: <Widget>[
                                  //       Expanded(
                                  //         child: Text(
                                  //           'Heeft u problemen neem dan contact op met ...',
                                  //           textAlign: TextAlign.left,
                                  //           style: TextStyle(
                                  //               color: Colors.grey,
                                  //               fontWeight: FontWeight.bold),
                                  //         ),
                                  //       ),
                                  //       SizedBox(width: 40.0),
                                  //       Material(
                                  //         borderRadius:
                                  //             BorderRadius.circular(100.0),
                                  //         color: Colors.blueAccent
                                  //             .withOpacity(0.1),
                                  //         child: IconButton(
                                  //           icon: Icon(Icons.arrow_forward_ios),
                                  //           color: Colors.blueAccent,
                                  //           onPressed: () {},
                                  //         ),
                                  //       )
                                  //     ],
                                  //   ),
                                  // )
                            
                              ),
                         
                     
                        ],
                      ),
                    ],
                  ),
                ),
              ])
            ])));
  }
}
