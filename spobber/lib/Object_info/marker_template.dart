import 'package:flutter/material.dart';
import 'marker_image.dart';
import 'marker_info.dart';
import 'marker_history.dart';

import '../data/marker_detail.dart';

class MarkerTemplate extends StatelessWidget {
  final String type;
  final String objectUri;
  final String id;
  final String secretId;

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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.info),
                text: "Informatie",
              ),
              Tab(
                icon: Icon(Icons.image),
                text: "Afbeeldingen",
              ),
              Tab(icon: Icon(Icons.comment), text: "Commentaar"),
            ],
          ),
          title: Text(type),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            MarkerInfo(),
            MarkerImage(id: id, secretId: secretId),
            MarkerHistory(),
          ],
        ),

        // body: Container(
        //     margin: const EdgeInsets.symmetric(vertical: 20.0),
        //     height: 300.0,
        //     child: PhotoView(
        //       imageProvider: NetworkImage("http://objectlabeler.azurewebsites.net/api/image/?id="+markerDetail.name),
        //     )),
      ),
    );
  }
}
