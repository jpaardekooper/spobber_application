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

class _MarkerHistoryState extends State<MarkerHistory> {
  //   with AutomaticKeepAliveClientMixin<MarkerHistory> {
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
  final _controller = ScrollController();
  final _height = 90;

  _animateToIndex(i) => _controller.animateTo(_height * i,
      duration: Duration(seconds: 2), curve: Curves.fastOutSlowIn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        controller: _controller,
        itemCount: list.length,
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 0,
        ),
        itemBuilder: (BuildContext context, int index) {
          final data = list[index];

          if (data['variable'] == "readable_id") {
            editObjectInfomartion.readableID = data['value'];
            if (editObjectInfomartion.readableID == null) {
              editObjectInfomartion.readableID = "";
            }
          } else if (data['variable'] == "equipment_id") {
            editObjectInfomartion.equipmentId = data['value'];
            if (editObjectInfomartion.equipmentId == null) {
              editObjectInfomartion.equipmentId = "";
            }
          } else if (data['variable'] == "secret_id") {
            editObjectInfomartion.secretId = data['value'];
            if (editObjectInfomartion.secretId == null) {
              editObjectInfomartion.secretId = "";
            }
          } else if (data['variable'] == "id") {
            editObjectInfomartion.secretId = data['value'];
          } else if (data['variable'] == "type") {
            editObjectInfomartion.type = data['value'];
            if (editObjectInfomartion.type == null) {
              editObjectInfomartion.type = "";
            }
          } else if (data['variable'] == "description") {
            editObjectInfomartion.description = data['value'];
            if (editObjectInfomartion.description == null) {
              editObjectInfomartion.description = "";
            }
          } else if (data['variable'] == "equipment_status") {
            editObjectInfomartion.equipmentStatus = data['value'];
            if (editObjectInfomartion.equipmentStatus == null) {
              editObjectInfomartion.equipmentStatus = "";
            }
          } else if (data['variable'] == "user_status_equipment") {
            editObjectInfomartion.userStatusEquipment = data['value'];
            if (editObjectInfomartion.userStatusEquipment == null) {
              editObjectInfomartion.userStatusEquipment = "";
            }
          } else if (data['variable'] == "parent_equip_kind") {
            editObjectInfomartion.parentEquipKind = data['value'];
            if (editObjectInfomartion.parentEquipKind == null) {
              editObjectInfomartion.parentEquipKind = "";
            }
          } else if (data['variable'] == "datacollection") {
            editObjectInfomartion.datacollection = data['value'];
            if (editObjectInfomartion.datacollection == null) {
              editObjectInfomartion.datacollection = "";
            }
          } else if (data['variable'] == "placement") {
            editObjectInfomartion.placement = data['value'];
            if (editObjectInfomartion.placement == null) {
              editObjectInfomartion.placement = "";
            }
          } else if (data['variable'] == "latitude") {
            editObjectInfomartion.latitude = data['value'];
          } else if (data['variable'] == "longitude") {
            editObjectInfomartion.longitude = data['value'];
          } else if (data['variable'] == "pic_file_name") {
            editObjectInfomartion.picFileName = data['value'];
            if (editObjectInfomartion.picFileName == null) {
              editObjectInfomartion.picFileName = "";
            }
          } else if (data['variable'] == "run_nr") {
            editObjectInfomartion.runNr = data['value'];
            if (editObjectInfomartion.runNr == null) {
              editObjectInfomartion.runNr = "";
            }
          } else if (data['variable'] == "track_version") {
            editObjectInfomartion.trackVersion = data['value'];
            if (editObjectInfomartion.trackVersion == null) {
              editObjectInfomartion.trackVersion = "";
            }
          } else if (data['variable'] == "source") {
            editObjectInfomartion.source = data['value'];
            if (editObjectInfomartion.source == null) {
              editObjectInfomartion.source = "";
            }
          } else if (data['variable'] == "source") {
            editObjectInfomartion.source = data['value'];
            if (editObjectInfomartion.source == null) {
              editObjectInfomartion.source = "";
            }
          } else if (data['variable'] == "creator") {
            editObjectInfomartion.creator = data['value'];
            if (editObjectInfomartion.creator == null) {
              editObjectInfomartion.creator = "";
            }
          } else if (data['variable'] == "year") {
            editObjectInfomartion.year = data['value'];
            if (editObjectInfomartion.year == null) {
              editObjectInfomartion.year = 0;
            }
          }

          //     if (index % 4 == 0) {
          return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                index % 3 == 0 && index != 0
                    ? Container(
                        color:  const Color(0xff0066C6),
                        child: const Text(""),
                      )
                    : Container(),
                Card(
                  child: ListTile(
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
                  ),
                )
              ]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Wijzigen",
        child: const Icon(Icons.edit, color: Colors.white,),
        heroTag: "edit",
        onPressed: () {
          if (editObjectInfomartion.userStatusEquipment == null) {
            editObjectInfomartion.userStatusEquipment = "";
          }

          _animateToIndex(list.length.toDouble()).then((onValue) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => (NewMarkerInformation(
                    markerinformation: editObjectInfomartion)),
              ),
            );
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    print("Disposing second route");
    super.dispose();
  }

  // @override
  // bool get wantKeepAlive => true;
}
