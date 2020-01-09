import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spobber/data/marker_detail.dart';
import 'package:spobber/pages/widgets/new_marker_information.dart';

class MarkerHistory extends StatefulWidget {
  final String secretid;
  // final String objectUri;

  // In the constructor, require a Person
  MarkerHistory({@required this.secretid});

  @override
  _MarkerHistoryState createState() => _MarkerHistoryState();
}

class _MarkerHistoryState extends State<MarkerHistory>
    with AutomaticKeepAliveClientMixin<MarkerHistory> {
  var list = List();

  _loadList() async {
    final response = await http.get(
        "https://spobber.azurewebsites.net/api/objects/${widget.secretid}");
    print("https://spobber.azurewebsites.net/api/objects/${widget.secretid}");
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          list = json.decode(response.body) as List;
        });
      }
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  void initState() {
    _loadList();
    super.initState();
  }

  MarkerDetail editObjectInfomartion = new MarkerDetail();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: list.length,
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 0,
        ),
        itemBuilder: (BuildContext context, int index) {
          final data = list[index];

          if (data['variable'] == "readable_id") {
            editObjectInfomartion.readableID = data['value'];
          }        
          if (data['variable'] == "equipment_id") {
            editObjectInfomartion.equipmentId = data['value'];
          }
          if (data['variable'] == "secret_id") {
            editObjectInfomartion.secretId = data['value'];
          }
          if (data['variable'] == "type") {
            editObjectInfomartion.type = data['value'];
          }
          if (data['variable'] == "description") {
            editObjectInfomartion.description = data['value'];
          }
          if (data['variable'] == "equipment_status") {
            editObjectInfomartion.equipmentStatus = data['value'];
          }
          if (data['variable'] == "user_status_equipment") {
            editObjectInfomartion.userStatusEquipment = data['value'];
          }
          if (data['variable'] == "parent_equip_kind") {
            editObjectInfomartion.parentEquipKind = data['value'];
          }
          if (data['variable'] == "datacollection") {
            editObjectInfomartion.datacollection = data['value'];
          }
          if (data['variable'] == "placement") {
            editObjectInfomartion.placement = data['value'];
          }
          if (data['variable'] == "latitude") {
            editObjectInfomartion.latitude = data['value'];
          }
          if (data['variable'] == "longitude") {
            editObjectInfomartion.longitude = data['value'];
          }
          if (data['variable'] == "pic_file_name") {
            editObjectInfomartion.picFileName = data['value'];
          }
          if (data['variable'] == "run_nr") {
            editObjectInfomartion.runNr = data['value'];
          }
          if (data['variable'] == "track_version") {
            editObjectInfomartion.trackVersion = data['value'];
          }
          if (data['variable'] == "source") {
            editObjectInfomartion.source = data['value'];
          }
          if (data['variable'] == "year") {
            editObjectInfomartion.year = data['value'];
          }

          if (index % 4 == 0) {
            return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    color: Theme.of(context).accentColor,
                    child: Text(""),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    leading: Icon(Icons.info),
                    title: Text(
                      data['variable'].toString().toUpperCase(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      data['value'].toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ]);
          }
          return ListTile(
            contentPadding: EdgeInsets.all(10.0),
            leading: Icon(Icons.info),
            title: Text(
              data['variable'].toString().toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              data['value'].toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Wijzigen",
        child: Icon(Icons.edit),
        heroTag: "edit",
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => (NewMarkerInformation(
                  markerinformation: new MarkerDetail(
          //          id: editObjectInfomartion.readableID,
                    secretId: editObjectInfomartion.secretId,
                    type: editObjectInfomartion.type,
                    description: editObjectInfomartion.description,
                    equipmentId: editObjectInfomartion.equipmentId,
                    equipmentStatus: editObjectInfomartion.equipmentStatus,
                    userStatusEquipment:editObjectInfomartion.userStatusEquipment,
                    parentEquipKind: editObjectInfomartion.parentEquipKind,
                    datacollection: editObjectInfomartion.datacollection,
                    placement: editObjectInfomartion.placement,
                    latitude: editObjectInfomartion.latitude,
                    longitude: editObjectInfomartion.longitude,
                    picFileName: editObjectInfomartion.picFileName,
                    runNr: editObjectInfomartion.runNr,
                    trackVersion: editObjectInfomartion.trackVersion,
                    source: editObjectInfomartion.source,
                    year: editObjectInfomartion.year, // => 21-04-2019 02:40:25
                    readableID: editObjectInfomartion.readableID,
                  ),
                )),
              ));
        },
      ),
    );
  }

  @override
  void dispose() {
    print("Disposing second route");
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
