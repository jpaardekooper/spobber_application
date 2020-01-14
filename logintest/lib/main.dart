import 'package:flutter/material.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:logintest/Registeringpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'LoginPage.dart';
import 'Users.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: LoginPage(),
      routes: <String, WidgetBuilder>{
        '/screen1': (BuildContext context) => new LoginPage(),
        '/screen2': (BuildContext context) => new MyHomePage(),
        '/screen3': (BuildContext context) => new Test(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  MyHomePage({Key key, @required this.sharedPreferences}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  User _user = new User();

  void initState() {
    super.initState();
    _user = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('testing enzo'),
        backgroundColor: Color(0xFF0062A5),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => popupMessage(),
          ),
        ],
      ),
      body: Container(),
    );
  }

  void popupMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Container(
                alignment: Alignment.center,
                height: 40,
                width: 80,
                color: Color(0xFF0062A5),
                child: Text(
                  'Confirm',
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ),
              onPressed: () => goToLogin(),
            ),
          ],
        );
      },
    );
  }

  User getData() {
    String item = widget.sharedPreferences.getString('user');
    User user = User.fromJson(json.decode(item));
    return user;
  }

  void goToLogin() {
    setState(() {
      widget.sharedPreferences.remove('user');
    });
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/screen1', (Route<dynamic> route) => false);
  }
}
