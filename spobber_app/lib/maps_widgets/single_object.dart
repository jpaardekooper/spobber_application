import "package:flutter/material.dart";
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:spobber_app/data/global_variable.dart';
import 'object_filter.dart';
import '../data/my_flutter_app_icons.dart';

class SingleObject extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SingleObject();
  }
}


class _SingleObject extends State<SingleObject> {
  @override
  Widget build(BuildContext context) {
    return Row(
 mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ObjectFilter()),
            );
          },
          child: Container(
            width: 180,
            height: 30,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10, top: 8),
              child: Text(
                "U zoekt op: $searchObject",
                style: TextStyle(fontSize: 15.0, color: Colors.black),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, top: 5),
          child: SizedBox.fromSize(
            size: Size(30, 30), // buton width and height
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.blue[600], // splash color
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ObjectFilter()),
                  );
                }, // button pressed
                child: Icon(
                  MyFilter.filter,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
