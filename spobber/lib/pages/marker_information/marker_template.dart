import 'package:flutter/material.dart';
import 'marker_history.dart';
import '../gridview/gridview_demo.dart';

///
///same as the home_screentabs this widget loads a tabbar controller
///in this case if the data source is equal to SAP or SIGMA it will not load the show image widget
///else if the source is Spobber or UST02 it will load images
class MarkerTemplate extends StatelessWidget {
  final String type;
  final String readableId;
  final String secretId;
  final String source;

  // // In the constructor, require a Person
  MarkerTemplate(
      {Key key,
      @required this.type,
      @required this.readableId,
      this.secretId,
      @required this.source})
      : super(key: key);

  Widget _scaffoldWithTabs(BuildContext context) {  
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          primary: true,
          appBar: AppBar(
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(Icons.remove_red_eye))
            ],
            flexibleSpace: Container(
              decoration: BoxDecoration(
                // Box decoration takes a gradient
                gradient: LinearGradient(
                  // Where the linear gradient begins and ends
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  // Add one stop for each color. Stops should increase from 0 to 1
                  stops: [0.1, 0.9],
                  colors: [
                    // Colors are easy thanks to Flutter's Colors class.
                    Color(0xff004990),
                    Color(0xff0066C6),
                  ],
                ),
              ),
            ),
            bottom: TabBar(
              unselectedLabelColor: Colors.white60,
              indicatorColor: Colors.white,
              //indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3,
              tabs: [
                Tab(
                  icon: const Icon(Icons.info),
                  text: "Informatie",
                ),
                Tab(
                  icon: const Icon(Icons.image),
                  text: "Afbeeldingen",
                ),
              ],
            ),
            title: Text(type + " " + readableId),
          ),
          body: Container(
            color: Colors.white,
            child: TabBarView(
              //  physics: NeverScrollableScrollPhysics(),
              children: [
                MarkerHistory(secretid: secretId),
                GridViewDemo(
                    id: readableId, secretId: secretId, source: source),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _scaffoldWithoutTabs(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        primary: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0), // here the desired height
          child: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                // Box decoration takes a gradient
                gradient: LinearGradient(
                  // Where the linear gradient begins and ends
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  // Add one stop for each color. Stops should increase from 0 to 1
                  stops: [0.1, 0.9],
                  colors: [
                    // Colors are easy thanks to Flutter's Colors class.
                    Color(0xff004990),
                    Color(0xff0066C6),
                  ],
                ),
              ),
            ),
            //          color: Theme.of(context).primaryColor),
            //    backgroundColor: Theme.of(context).primaryColor,
            title: Text("Informatie over: " + readableId),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: MarkerHistory(secretid: secretId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (source == "SPOBBER" || source == "UST02") {
      return _scaffoldWithTabs(context);
    } else {
      return _scaffoldWithoutTabs(context);
    }
  }
}
