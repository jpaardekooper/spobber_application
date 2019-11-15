import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'parsers/icon.dart';
import 'parsers/card.dart';
import 'parsers/listTile.dart';
import 'package:http/http.dart';

String body;

void main() async {
  Response response = await get("https://spobberdevelopment.azurewebsites.net/api/objects/flutter/b388bcfc-edfe-e911-828a-501ac53b2e7b");
  body = response.body;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PreviewPage(body),
    );
  }
}

class PreviewPage extends StatefulWidget {
  final String jsonString;
  PreviewPage(this.jsonString);

  @override
  PreviewPageState createState() => PreviewPageState(jsonString);
}

class PreviewPageState extends State<PreviewPage> {
  final String jsonString;
  PreviewPageState(this.jsonString);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ES-LAS"),
      ),
      body: Container(
        child: FutureBuilder<Widget>(
          future: _buildWidget(context),
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            print(snapshot.data);
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            return snapshot.hasData
                ? SizedBox.expand(
                    child: snapshot.data,
                  )
                : Text("Loading...");
          },
        ),
      ),
    );
  }

  Future<Widget> _buildWidget(BuildContext context) async {
    DynamicWidgetBuilder.parsers.add(IconParser());
    DynamicWidgetBuilder.parsers.add(ListTileParser());
    DynamicWidgetBuilder.parsers.add(CardParser());
    return DynamicWidgetBuilder().build(jsonString, new DefaultClickListener());
  }
}

class DefaultClickListener implements ClickListener{
  @override
  void onClicked(String event) {
    print("Receive click event: " + event);
  }
}
