import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spobber/data/global_variable.dart';
import 'package:spobber/data/marker_detail.dart';
import 'package:spobber/data/place_response.dart';
import 'package:http/http.dart' as http;

class NewMarkerInformation extends StatefulWidget {
  final MarkerDetail markerinformation;

  NewMarkerInformation({@required this.markerinformation});
  @override
  _MarkerInfoState createState() => _MarkerInfoState();
}

// Create a corresponding State class. This class will hold the data related to
// the form.
class _MarkerInfoState extends State<NewMarkerInformation> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> _status = <String>[
    '',
    'Actief',
    'Inactief ',
    'Gereed voor verwijdering',
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
  String _typesTxt = '';
  String _statusTxt = '';
  String _plaatsingTxt = '';
  List<String> _plaatsing = <String>[
    '',
    '01-vk_Ltg',
    '02-vk_Rtg',
    '03-ak_Ltg_bt',
    '04-ak_Ltg_bn',
    '05-ak_Rtg_bn',
    '06-ak_Rtg_bt',
    '07-tsps_Lbt',
    '08-tsps_Lbn',
    '09-tsps_Rbn',
    '10-tsps_Rbt',
    '15-vk_Lssps',
    '16-vk_psk_L',
    '17-vk_psk_R',
    '18-vk_Rssps',
    '19-ak_Lssps',
    '20-ak_psk_L',
    '21-ak_psk_R',
    '22-ak_Rssps',
    '23-Hg_ak_Rssps',
    '24-Hg_ak_psk_R',
    '25-Hg_ak_psk_L',
    '26-Hg_ak_Lssps',
    '27-Hg_ak_tsps_Rbt',
    '28-Lg_vk_Lbttg',
    '29-Lg_vk_Lbntg',
    '30-Hg_vk_psk_R',
    '31-Hg_vk_psk_L',
    '32-Lg_vk_Rbntg',
    '33-Lg_vk_Rbttg',
    '34-Hg_ak_tsps_Lbt',
    '35-Hg_vk_tsps_Rbt',
    '36-Lg_ak_Lbttg_R',
    '37-Lg_ak_Lbntg_L',
    '38-Hg_vk_tsps_Rbn',
    '39-Hg_vk_tsps_Lbn',
    '40-Lg_ak_Rbntg_R',
    '41-Lg_ak_Rbttg_L',
    '42-Hg_vk_tsps_Lbt',
    '43-Lg_ak_Lbttg_L',
    '44-Lg_ak_Lbntg_R',
    '45-Lg_ak_Rbntg_L',
    '46-Lg_ak_Rbttg_R',
    '47-Lg_vk_tsps_Lbt',
    '48-Hg_ak_Rbttg_L',
    '49-Hg_ak_Rbntg_R',
    '50-Lg_vk_tsps_Lbn',
    '51-Lg_vk_tsps_Rbn',
    '52-Hg_ak_Lbntg_L',
    '53-Hg_ak_Lbttg_R',
    '54-Lg_vk_tsps_Rbt',
    '55-Lg_ak_tsps_Lbt',
    '56-Hg_vk_Rbttg',
    '57-Hg_vk_Rbntg',
    '58-Lg_vk_psk_L',
    '59-Lg_vk_psk_R',
    '60-Hg_vk_Lbntg',
    '61-Hg_vk_Lbttg',
    '62-Lg_ak_tsps_Rbt',
    '63-Lg_ak_Lssps',
    '64-Lg_ak_psk_L',
    '65-Lg_ak_psk_R',
    '66-Lg_ak_Rssps',
    '67-Lg_ak_Rssps',
    '68-Lg_ak_psk_R',
    '69-Lg_ak_psk_L',
    '70-Lg_ak_Lssps',
    '71-Lg_ak_tsps_Rbt',
    '72-Lg_ak_tsps_Rbn',
    '73-Lg_ak_tsps_Lbn',
    '74-Lg_ak_tsps_Lbt',
    '75-Lg_tsps_Rbt',
    '76-Lg_tsps_Rbn',
    '77-Lg_tsps_Lbn',
    '78-Lg_tsps_Lbt',
    '79-Lg_vk_tsps_Rbt',
    '80-Lg_vk_tsps_Rbn',
    '81-Lg_vk_tsps_Lbn',
    '82-Lg_vk_tsps_Lbt',
    '83-Hg_vk_tsps_Lbt',
    '84-Hg_vk_tsps_Lbn',
    '85-Hg_vk_tsps_Rbn',
    '86-Hg_vk_tsps_Rbt',
    '87-Hg_tsps_Lbt',
    '88-Hg_tsps_Lbn',
    '89-Hg_tsps_Rbn',
    '90-Hg_tsps_Rbt',
    '91-Hg_ak_tsps_Lbt',
    '92-Hg_ak_tsps_Lbn',
    '93-Hg_ak_tsps_Rbn',
    '94-Hg_ak_tsps_Rbt',
    '95-Hg_ak_Lssps',
    '96-Hg_ak_psk_L',
    '97-Hg_ak_psk_R',
    '98-Hg_ak_Rssps',
    'Linker spoorstaaf',
    'Rechter spoorstaaf',
    '100-wlnr1-vk_Ltg',
    '101-wlnr1-vk_Rtg',
    '102-wlnr1-ak_Ltg_bt',
    '103-wlnr1-ak_Ltg_bn',
    '104-wlnr1-ak_Rtg_bn',
    '105-wlnr1-ak_Rtg_bt',
    '106-wlnr1-vk_Lssps',
    '107-wlnr2-ak_Ltg_bt',
    '108-wlnr2-ak_Ltg_bt',
    '109-wlnr2-ak_Ltg_bn',
    '110-wlnr2-ak_Rtg_bn',
    '111-wlnr2-ak_Rtg_bt',
    '112-wlnr2-ak_Rtg_bt',
    '113-wlnr1-vk_Rssps',
    '114-wlnr2-ak_Ltg_bn',
    '115-wlnr1-vk_psk1_L',
    '116-wlnr1-vk_psk1_R',
    '117-wlnr2-ak_Rtg_bn',
    '118-wlnr1_vk_psk2_L',
    '119-wlnr1_vk_psk2_R',
    '120-wlnr1-ak_psk1_L',
    '121-wlnr1-ak_psk1_R',
    '122-wlnr1-ak_Lssps',
    '123-wlnr2-vk_Lssps',
    '124-wlnr1-ak_psk2_L',
    '125-wlnr2-tssps_Lbn',
    '126-wlnr1-ak_psk2_R',
    '127-wlnr2-tssps_Rbn',
    '128-wlnr2-tssps_Lbn',
    '129-wlnr1-ak_psk2_L',
    '130-wlnr2-tssps_Rbn',
    '131-wlnr1-ak_psk2_R',
    '132-wlnr2-vk_Rssps',
    '133-wlnr1-ak_Rssps',
    '134-wlnr2-vk_psk3_L',
    '135-wlnr2-vk_psk3_R',
    '136-wlnr2-ak_Lssps',
    '137-wlnr2-ak_psk3_L',
    '138-wlnr2-ak_psk3_R',
    '139-wlnr2-ak_Rssps',
  ];
  MarkerDetail newMarkerDetail = MarkerDetail();
  final GlobalKey<ScaffoldState> _scaffoldKeyThree = GlobalKey<ScaffoldState>();

  // String id;
  // String secretId;
  // String type;
  // String description;
  // String equipmentId;
  // String equipmentStatus;
  // String userStatusEquipment;
  // String parentEquipKind;
  // String datacollection;
  // String placement;
  // double latitude;
  // double longitude;
  // String picFileName;
  // String runNr;
  // String trackVersion;
  // String source;
  // int year;
  // String readableID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyThree,
      appBar: AppBar(
        title: Text(widget.markerinformation.id),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Form(
          key: _formKey,
          //autovalidate: true,
          child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              // Divider(
              //   color: Theme.of(context).accentColor,
              //   height: 50,
              //   thickness: 20,
              // ),
              new TextFormField(
                initialValue: '${widget.markerinformation.readableID}',
                decoration: InputDecoration(
                    enabled: false,
                    icon: Icon(Icons.security),
                    hintText: 'readable_ID',
                    labelText: 'readable_ID'.toUpperCase(),
                    labelStyle: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                validator: (value) {
                  if (value.isEmpty) {
                    value = '';
                    return 'Please enter some text';
                  } else {
                    newMarkerDetail.readableID =
                        widget.markerinformation.readableID.toString();
                  }
                },
              ),
              new TextFormField(
                initialValue: '${widget.markerinformation.secretId}',
                decoration: InputDecoration(
                    icon: Icon(Icons.security),
                    enabled: false,
                    hintText: 'secretId',
                    labelText: 'secretId'.toUpperCase(),
                    labelStyle: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  } else {
                    newMarkerDetail.secretId =
                        widget.markerinformation.secretId;
                  }
                },
              ),
              new TextFormField(
                enabled: true,
                initialValue: '${widget.markerinformation.type}',
                decoration: InputDecoration(
                    icon: Icon(Icons.description),
                    hintText: 'Type',
                    labelText: 'Type'.toUpperCase(),
                    labelStyle: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  } else {
                    newMarkerDetail.type = value;
                  }
                },
              ),
              new FormField(
                builder: (FormFieldState state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                        icon: const Icon(Icons.description),
                        labelText: 'Type Es-las'.toUpperCase(),
                        labelStyle: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
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
              // Divider(
              //   color: Theme.of(context).accentColor,
              //   height: 50,
              //   thickness: 20,
              // ),
              new TextFormField(
                enabled: true,
                initialValue: '${widget.markerinformation.description}',
                decoration: InputDecoration(
                    icon: Icon(Icons.description),
                    labelText: 'beschrijving'.toUpperCase(),
                    labelStyle: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  } else {
                    newMarkerDetail.description = value;
                  }
                },
              ),
              new TextFormField(
                enabled: true,
                initialValue: '${widget.markerinformation.equipmentId}',
                decoration: InputDecoration(
                    icon: Icon(Icons.description),
                    helperText:
                        'Unieke identificatienummer van een equipment (uit SAP).',
                    labelText: 'Equipment'.toUpperCase(),
                    labelStyle: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  } else {
                    newMarkerDetail.equipmentId = value;
                  }
                },
              ),
              new FormField(
                builder: (FormFieldState state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                        icon: const Icon(Icons.sentiment_satisfied),
                        helperText:
                            'Status van het object in de railinfrastructuur',
                        labelText: 'Status'.toUpperCase(),
                        labelStyle: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
                    isEmpty:
                        _statusTxt == widget.markerinformation.equipmentStatus,
                    child: new DropdownButtonHideUnderline(
                      child: new DropdownButton(
                        value: _statusTxt,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            newMarkerDetail.equipmentStatus = newValue;
                            _statusTxt = newValue;
                            state.didChange(newValue);
                          });
                        },
                        items: _status.map((String value) {
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
                  return val != '' ? null : 'Status van het object';
                },
              ),
              new TextFormField(
                enabled: true,
                initialValue: '${widget.markerinformation.userStatusEquipment}',
                decoration: InputDecoration(
                    icon: Icon(Icons.live_help),
                    helperText: 'De status wordt overgenomen uit SAP PLM.',
                    labelText: 'User status equipment'.toUpperCase(),
                    labelStyle: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  } else {
                    newMarkerDetail.userStatusEquipment = value;
                  }
                },
              ),
              // Divider(
              //   color: Theme.of(context).accentColor,
              //   height: 50,
              //   thickness: 20,
              // ),
              new TextFormField(
                enabled: true,
                initialValue: '${widget.markerinformation.parentEquipKind}',
                decoration: InputDecoration(
                    icon: Icon(Icons.live_help),
                    labelText: 'Parent equip kind'.toUpperCase(),
                    labelStyle: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  } else {
                    newMarkerDetail.parentEquipKind = value;
                  }
                },
              ),
              new TextFormField(
                enabled: true,
                initialValue: '${widget.markerinformation.datacollection}',
                decoration: InputDecoration(
                    icon: Icon(Icons.list),
                    helperText:
                        "De reden van de mutatie van de infrastamdata van het object. ",
                    labelText: 'Datacollectie'.toUpperCase(),
                    labelStyle: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  } else {
                    newMarkerDetail.datacollection = value;
                  }
                },
              ),
              new FormField(
                builder: (FormFieldState state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                        icon: const Icon(Icons.location_on),
                        helperText:
                            'De locatie in het spoor, het wissel of de kruising waar de ES-las zich bevindt.',
                        labelText: 'Plaatsing'.toUpperCase(),
                        labelStyle: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
                    isEmpty:
                        _plaatsingTxt == widget.markerinformation.placement,
                    child: new DropdownButtonHideUnderline(
                      child: new DropdownButton(
                        value: _plaatsingTxt,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            newMarkerDetail.placement = newValue;
                            _plaatsingTxt = newValue;
                            state.didChange(newValue);
                          });
                        },
                        items: _plaatsing.map((String value) {
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
                  return val != '' ? null : 'Plaatsing van het object';
                },
              ),
              new TextFormField(
                enabled: false,
                initialValue: '${widget.markerinformation.latitude}',
                decoration: InputDecoration(
                    icon: Icon(Icons.location_on),
                    //  hintText: 'Parent equip kind',
                    labelText: 'GPS coordinate van de Latitude'.toUpperCase(),
                    labelStyle: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                validator: (value) {
                  if (value.isEmpty) {
                    value = '';
                    return 'Please enter some text';
                  } else {
                    newMarkerDetail.latitude =
                        widget.markerinformation.latitude;
                  }
                },
              ),
              new TextFormField(
                enabled: false,
                initialValue: '${widget.markerinformation.longitude}',
                decoration: InputDecoration(
                    icon: Icon(Icons.location_on),
                    labelText: 'GPS coordinate van de Longitude'.toUpperCase(),
                    labelStyle: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  } else {
                    newMarkerDetail.longitude =
                        widget.markerinformation.longitude;
                  }
                },
              ),

              new TextFormField(
                enabled: true,
                initialValue: '${widget.markerinformation.runNr}',
                decoration: InputDecoration(
                    icon: Icon(Icons.tram),
                    labelText: 'Run nummer'.toUpperCase(),
                    labelStyle: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  } else {
                    newMarkerDetail.runNr = value;
                  }
                },
              ),
              new TextFormField(
                enabled: true,
                initialValue: '${widget.markerinformation.trackVersion}',
                decoration: InputDecoration(
                    icon: Icon(Icons.tram),
                    labelText: 'Track versie'.toUpperCase(),
                    labelStyle: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  } else {
                    newMarkerDetail.trackVersion = value;
                  }
                },
              ),
              new TextFormField(
                enabled: false,
                initialValue: '${widget.markerinformation.source}',
                decoration: InputDecoration(
                    icon: Icon(Icons.art_track),
                    labelText: 'Bron'.toUpperCase(),
                    labelStyle: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  } else {
                    newMarkerDetail.source = value;
                  }
                },
              ),
              new TextFormField(
                enabled: false,
                keyboardType: TextInputType.numberWithOptions(),
                initialValue: '${widget.markerinformation.year}',
                decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: 'Datum '.toUpperCase(),
                    labelStyle: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  } else {
                    newMarkerDetail.year = int.parse(value);
                  }
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
      newMarkerDetail.id = widget.markerinformation.id;
      newMarkerDetail.secretId = widget.markerinformation.secretId;
      form.save(); //This invokes each onSaved event

      print('Form save called, newContact is now up to date...');
      print('ID: ${newMarkerDetail.id}');
      print('secretId: ${newMarkerDetail.secretId}');
      print('type: ${newMarkerDetail.type}');
      print('description: ${newMarkerDetail.description}');
      print('equipmentStatus: ${newMarkerDetail.equipmentStatus}');
      print('userStatusEquipment: ${newMarkerDetail.userStatusEquipment}');
      print('parentEquipKind: ${newMarkerDetail.parentEquipKind}');
      print('datacollection: ${newMarkerDetail.datacollection}');
      print('placement: ${newMarkerDetail.placement}');
      print('LAT: ${newMarkerDetail.latitude}');
      print('LONG: ${newMarkerDetail.longitude}');
      print('runNr: ${newMarkerDetail.runNr}');
      print('trackVersion: ${newMarkerDetail.trackVersion}');
      print('source: ${newMarkerDetail.source}');
      print('year: ${newMarkerDetail.year}');
      print('readableID: ${newMarkerDetail.readableID}');
      print('objectType: ${newMarkerDetail.objectType}');
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
