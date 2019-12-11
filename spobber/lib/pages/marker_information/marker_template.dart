import 'package:flutter/material.dart';
import 'marker_info.dart';
import 'marker_history.dart';
import '../gridview/gridview_demo.dart';

class MarkerTemplate extends StatelessWidget {
  final String type;
  final String id;
  final String secretId;
  final String objectUri;

  // // In the constructor, require a Person
  MarkerTemplate(
      {Key key,
      @required this.type,
      @required this.objectUri,
      this.id,
      this.secretId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(id.toString() + " " + secretId);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
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
            //labelColor: Colors.white,
            tabs: [
              // Tab(
              //   icon: Icon(Icons.info),
              //   text: "Informatie",
              // ),
              Tab(
                icon: Icon(Icons.image),
                text: "Afbeeldingen",
              ),
              Tab(icon: Icon(Icons.comment), text: "Commentaar"),
            ],
          ),
          title: Text(type),
        ),
        body: Container(
          color: Colors.white,
          child: TabBarView(
            //  physics: NeverScrollableScrollPhysics(),
            children: [
     //         MarkerInfo(id: id.toString(), objectUri: objectUri),
              GridViewDemo(id: id.toString(), secretId: secretId),
              //   MarkerImage(id: id, secretId: secretId),
              MarkerHistory(),
            ],
          ),
        ),
      ),
    );
  }
}
