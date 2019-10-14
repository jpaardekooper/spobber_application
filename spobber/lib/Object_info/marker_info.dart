import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MarkerInfo extends StatefulWidget {
  // final MarkerDetail markerDetail;

  // // In the constructor, require a Person
  // MarkerInfo({Key key, @required this.markerDetail}) : super(key: key);
  final String imageId;
  final String imageType;
  final String imageLat;
  final String imageLong;
  final String imageStatus;

  // In the constructor, require a Person
  MarkerInfo(this.imageId, this.imageType, this.imageLat, this.imageLong, this.imageStatus);

  @override
  _MarkerInfoState createState() => _MarkerInfoState();
}

// Create a corresponding State class. This class will hold the data related to
// the form.
class _MarkerInfoState extends State<MarkerInfo> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  @override
  void dispose() {
    print("Disposing second route");
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  String name;
  String age;
  String position;
  String objectType;
  String phpEndPoint = '/';
  int _selectedStatus = 0;
  int _selectedType = 0;

  List<DropdownMenuItem<int>> statusList = [];

  void loadStatusList() {
    statusList = [];
    statusList.add(new DropdownMenuItem(
      child: new Text('Onbekend'),
      value: 0,
    ));
    statusList.add(new DropdownMenuItem(
      child: new Text('Slecht'),
      value: 1,
    ));
    statusList.add(new DropdownMenuItem(
      child: new Text('Normaal'),
      value: 2,
    ));
    statusList.add(new DropdownMenuItem(
      child: new Text('Goed'),
      value: 3,
    ));
    statusList.add(new DropdownMenuItem(
      child: new Text('Vervanging nodig'),
      value: 4,
    ));
  }

  List<DropdownMenuItem<int>> typeList = [];
  void loadTypeList() {
    typeList = [];
    typeList.add(new DropdownMenuItem(
      child: new Text('Lijmlas Edilon-NS'),
      value: 0,
    ));
    typeList.add(new DropdownMenuItem(
      child: new Text('Lijmlas Edilon-TC'),
      value: 1,
    ));
    typeList.add(new DropdownMenuItem(
      child: new Text('Lijmlas BWG-S'),
      value: 2,
    ));
    typeList.add(new DropdownMenuItem(
      child: new Text('Lijmlas BWG-S versterkt'),
      value: 3,
    ));
    typeList.add(new DropdownMenuItem(
      child: new Text('Lijmlas Kloos HB600'),
      value: 4,
    ));
    typeList.add(new DropdownMenuItem(
      child: new Text('Lijmlas Kloos HB480'),
      value: 5,
    ));
    typeList.add(new DropdownMenuItem(
      child: new Text('Lijmlas ETS PF1/BN2 - oud'),
      value: 6,
    ));
    typeList.add(new DropdownMenuItem(
      child: new Text('Lijmlas ETS PF1/BN2 - nieuw'),
      value: 7,
    ));
    typeList.add(new DropdownMenuItem(
      child: new Text('Geconstr. las NS'),
      value: 8,
    ));
    typeList.add(new DropdownMenuItem(
      child: new Text('Geconstr. las Tenconi-4 gats'),
      value: 9,
    ));
    typeList.add(new DropdownMenuItem(
      child: new Text('Geconstr. las Tenconi-6 gats'),
      value: 10,
    ));
    typeList.add(new DropdownMenuItem(
      child: new Text('Geconstr. las Exel'),
      value: 11,
    ));
    typeList.add(new DropdownMenuItem(
      child: new Text('  Geconstr. las BWG-MT'),
      value: 12,
    ));
    typeList.add(new DropdownMenuItem(
      child: new Text('Geconstr. las BWG-MT versterkt'),
      value: 13,
    ));
    typeList.add(new DropdownMenuItem(
      child: new Text('Lijmlas type onbekend'),
      value: 14,
    ));
    typeList.add(new DropdownMenuItem(
      child: new Text('Geconstr. las type onbekend'),
      value: 15,
    ));
    typeList.add(new DropdownMenuItem(
      child: new Text('Lijmlas Railpro-HIRD'),
      value: 16,
    ));
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();

//getId information 1
    formWidget.add(new TextFormField(
      enabled: false,
      controller: TextEditingController(text: widget.imageId),
      decoration: InputDecoration(
          labelText: 'Object ID',
          hintText: 'vul een naam in',
          icon: Icon(Icons.content_paste)),
      validator: (value) {
        if (value.isEmpty) {
          return 'ID';
        }
      },
      onSaved: (value) {
        setState(() {
          name = value;
        });
      },
    ));

    //getName information 2
    formWidget.add(new TextFormField(
      enabled: false,
      controller: TextEditingController(text: widget.imageType),
      decoration: InputDecoration(
          labelText: "Type Object",
          hintText: 'object type',
          icon: Icon(Icons.filter)),
      validator: (value) {
        if (value.isEmpty) {
          return 'vul een de juiste type in';
        }
      },
      onSaved: (value) {
        setState(() {
          objectType = value;
        });
      },
    ));

    formWidget.add(new Container(
      width: 300,
      margin: const EdgeInsets.only(top: 20.0, left: 40.0),
      child: new Text('Soort'),
    ));

    formWidget.add(new Container(
        margin: const EdgeInsets.only(top: 1.0, left: 40.0),
        child: new DropdownButton(
          elevation: 5,
          style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              decorationStyle: TextDecorationStyle.wavy),
          isDense: true,
          iconSize: 40.0,
          items: typeList,
          value: _selectedType,
          onChanged: (value) {
            setState(() {
              _selectedType = value;
            });
          },
          isExpanded: true,
        )));

    formWidget.add(new Container(
      width: 300,
      margin: const EdgeInsets.only(top: 20.0, left: 40.0),
      child: new Text('Status van het object'),
    ));

    formWidget.add(new Container(
        margin: const EdgeInsets.only(top: 1.0, left: 40.0),
        child: new DropdownButton(
          elevation: 5,
          style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              decorationStyle: TextDecorationStyle.wavy),
          isDense: true,
          iconSize: 40.0,
          items: statusList,
          value: _selectedStatus,
          onChanged: (value) {
            setState(() {
              _selectedStatus = value;
            });
          },
          isExpanded: true,
        )));

    //getName information
    formWidget.add(new TextFormField(
      enabled: false,
      controller: TextEditingController(text: "lat: " + widget.imageLat +" long: " + widget.imageLong),
      decoration: InputDecoration(
          labelText: "GPS coordinatie",
          hintText: 'object positie',
          icon: Icon(Icons.gps_fixed)),
      validator: (value) {
        if (value.isEmpty) {
          return 'vul een de juiste coordinaten in';
        }
      },
      onSaved: (value) {
        setState(() {
          position = value;
        });
      },
    ));

    //getId information
    formWidget.add(Container(
        margin: const EdgeInsets.only(bottom: 60),
        child: new TextFormField(
          enabled: false,
          controller: TextEditingController(text: "1-9-2017"),
          decoration: InputDecoration(
              labelText: "gemaakt op:",
              hintText: 'leeftijd',
              icon: Icon(Icons.date_range)),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a datum';
            }
          },
          onSaved: (value) {
            setState(() {
              age = value;
            });
          },
        )));

    formWidget.add(FloatingActionButton(
      child: Column(
        // Replace with a Row for horizontal icon + text
        children: <Widget>[
          Icon(Icons.file_upload, color: Colors.white),
          Text(
            "Opslaan",
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
      onPressed: () {
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              // Retrieve the text the user has typed in using our
              // TextEditingController
              content: Text("uploading"),
            );
          },
        );
      },
    ));

    return formWidget;
  }

  @override
  Widget build(BuildContext context) {
    loadStatusList();
    loadTypeList();
    return Container(
        child: Form(
            key: _formKey,
            child: new ListView(
              padding: EdgeInsets.all(20.0),
              children: getFormWidget(),
            )));

    //  return
  }
}
