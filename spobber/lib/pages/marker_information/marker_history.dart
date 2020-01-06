import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

    print("HALO");
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

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 0,
      ),
      itemBuilder: (BuildContext context, int index) {
        final data = list[index];
        if (data['value'].toString() == "" ||
            data['value'].toString() == null ||
            data['value'].toString() == '') {
          return null;
        } else {
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
        }
      },
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
