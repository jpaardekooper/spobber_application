import 'package:flutter/material.dart';
import 'marker_history.dart';
import '../gridview/gridview_demo.dart';

class MarkerTemplate extends StatelessWidget {
  final String type;
  final String readableId;
  final String secretId;

  // // In the constructor, require a Person
  MarkerTemplate({Key key, @required this.type, this.readableId, this.secretId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {   
    return SafeArea(child: DefaultTabController(
      length: 2,
      child: Scaffold(    
        primary: true,   
        appBar: AppBar(
          flexibleSpace: Container(
              // decoration: BoxDecoration(
              //   // Box decoration takes a gradient
              //   gradient: LinearGradient(
              //     // Where the linear gradient begins and ends
              //     begin: Alignment.topRight,
              //     end: Alignment.bottomLeft,
              //     // Add one stop for each color. Stops should increase from 0 to 1
              //     stops: [0.1, 0.9],
              //     colors: [
              //       // Colors are easy thanks to Flutter's Colors class.
              //       Color(0xff004990),
              //       Color(0xff0066C6),
              //     ],
              //   ),
              // ),
              color: Theme.of(context).primaryColor),
          bottom: TabBar(
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.white,
            //indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            //labelColor: Colors.white,
            tabs: [
              Tab(
                icon: const Icon(Icons.info),
                text: "Informatie",
              ),
              Tab(
                icon:const Icon(Icons.image),
                text: "Afbeeldingen",
              ),
              //        Tab(icon: Icon(Icons.comment), text: "Commentaar"),
            ],
          ),
          title: Text(type),
        ),
        body: Container(
          color: Colors.white,
          child: TabBarView(
            //  physics: NeverScrollableScrollPhysics(),
            children: [
              //     MarkerInfo(id: readableId.toString()),
              MarkerHistory(secretid: secretId),
              GridViewDemo(id: readableId, secretId: secretId),
              //   MarkerImage(id: id, secretId: secretId),
            ],
          ),
        ),
      ),
    ),);
  }
}
