import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MarkerHistory extends StatefulWidget {
  @override
  _MarkerHistoryState createState() => _MarkerHistoryState();
}

class _MarkerHistoryState extends State<MarkerHistory>
    with AutomaticKeepAliveClientMixin<MarkerHistory> {
  @override
  void dispose() {
    print("Disposing second route");
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  var list = List();

  _loadList() async {
    final response =
        await http.get("https://jsonplaceholder.typicode.com/posts/");
    if (response.statusCode == 200) {
      await new Future.delayed(const Duration(seconds: 1));
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
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        final data = list[index];
        return ListTile(
          contentPadding: EdgeInsets.all(10.0),
          title: Text(data['title']),
          subtitle: Text(
            data['body'],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}
