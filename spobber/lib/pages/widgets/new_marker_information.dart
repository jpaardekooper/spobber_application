import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spobber/data/global_variable.dart';
import 'package:spobber/data/marker_detail.dart';
import 'package:spobber/data/place_response.dart';
import 'package:http/http.dart' as http;

class NewMarkerInformation extends StatefulWidget {
  final LatLng position;

  NewMarkerInformation({@required this.position});
  @override
  _MarkerInfoState createState() => _MarkerInfoState();
}

// Create a corresponding State class. This class will hold the data related to
// the form.
class _MarkerInfoState extends State<NewMarkerInformation> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> _type = <String>[
    '',
    'ES-LAS',
  ];
  List<String> _types = <String>[
    '',
    'Lijmlas Edilon-NS',
    'Lijmlas Edilon-TC',
    'Lijmlas BWG-S',
    'Lijmlas BWG-S versterkt',
    'Lijmlas Kloos HB600',
    'Lijmlas Kloos HB480',
    'Lijmlas ETS PF1/BN2 - oud',
    'Lijmlas ETS PF1/BN2 - nieuw',
    'Geconstr. las NS',
    'Geconstr. las Tenconi-4 gats',
    'Geconstr. las Tenconi-6 gats',
    'Geconstr. las Exel',
    'Geconstr. las BWG-MT',
    'Geconstr. las BWG-MT versterkt',
    'Lijmlas type onbekend',
    'Geconstr. las type onbekend',
    'Lijmlas Railpro-HIRD'
  ];
  String _typeTxt = '';
  String _typesTxt = '';
  MarkerDetail newMarkerDetail = MarkerDetail();
  final GlobalKey<ScaffoldState> _scaffoldKeyThree = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyThree,
      appBar: AppBar(
        title: Text("Nieuw object"),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              new TextFormField(
                enabled: false,
                initialValue: 'Spobber Application',
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Bron',
                  labelText: 'Bron',
                  
                ),            
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  else{
                     newMarkerDetail.source = value;
                  }
                },
              ),
              new FormField(
                builder: (FormFieldState state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      icon: const Icon(Icons.color_lens),
                      labelText: 'Type',
                    ),
                    isEmpty: _typeTxt == '',
                    child: new DropdownButtonHideUnderline(
                      child: new DropdownButton(
                        value: _typeTxt,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            newMarkerDetail.type = newValue;
                            _typeTxt = newValue;
                            state.didChange(newValue);
                          });
                        },
                        items: _type.map((String value) {
                          return new DropdownMenuItem(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
                validator: (val) {
                  return val != '' ? null : 'Selecteer het object soort';
                },
              ),
              new TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Enter your first and last name',
                  labelText: '',
                ),
              ),
              new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.phone),
                  hintText: 'Enter a phone number',
                  labelText: 'Phone',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
              ),
              new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.email),
                  hintText: 'Enter a email address',
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              new FormField(
                builder: (FormFieldState state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      icon: const Icon(Icons.color_lens),
                      labelText: 'Soort Type',
                    ),
                    isEmpty: _typesTxt == '',
                    child: new DropdownButtonHideUnderline(
                      child: new DropdownButton(
                        value: _typesTxt,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            newMarkerDetail.type = newValue;
                            _typesTxt = newValue;
                            state.didChange(newValue);
                          });
                        },
                        items: _types.map((String value) {
                          return new DropdownMenuItem(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
                validator: (val) {
                  return val != '' ? null : 'Selecteer het object soort';
                },
              ),
              new Container(
                  padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                  child: new RaisedButton(
                    child: const Text('Submit'),
                    onPressed: _submitForm,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKeyThree.currentState.showSnackBar(new SnackBar(
        backgroundColor: Theme.of(context).accentColor,
        content: new Text(message)));
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save(); //This invokes each onSaved event

      print('Form save called, newContact is now up to date...');
      print('ID: ${newMarkerDetail.id}');
      print('LAT: ${newMarkerDetail.latitude}');
      print('LONG: ${newMarkerDetail.longitude}');
      print('PLAATSING: ${newMarkerDetail.placement}');
      print('TYPE: ${newMarkerDetail.type}');

      print('source: ${newMarkerDetail.source}');
      print('equipmentStatus: ${newMarkerDetail.equipmentStatus}');
      print('parentEquipKind: ${newMarkerDetail.parentEquipKind}');
      print('source: ${newMarkerDetail.source}');
      print('trackVersion: ${newMarkerDetail.trackVersion}');
      print('========================================');
      print('Submitting to back end...');
      print('TODO - we will write the submission part next...');

      var contactService = new MarkerDetail();
      contactService.createContact(newMarkerDetail).then((value) =>
          showMessage('New contact created for ${value.id}!', Colors.blue));
    }
  }
}

// class ContactService {}

// class Contact {
//   String name;
//   DateTime dob;
//   String phone = '';
//   String email = '';
//   String favoriteColor = '';
// }
