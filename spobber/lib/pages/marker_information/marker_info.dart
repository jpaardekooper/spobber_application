// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:spobber/data/global_variable.dart';
// import 'package:spobber/data/marker_detail.dart';

// class MarkerInfo extends StatefulWidget {
//   final String id;
//  // final String objectUri;

//   // In the constructor, require a Person
//   MarkerInfo({@required this.id});
//   @override
//   _MarkerInfoState createState() => _MarkerInfoState();
// }

// // Create a corresponding State class. This class will hold the data related to
// // the form.
// class _MarkerInfoState extends State<MarkerInfo>
//     with AutomaticKeepAliveClientMixin<MarkerInfo> {
//   // Create a global key that will uniquely identify the Form widget and allow
//   // us to validate the form
//   //
//   // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
//   @override
//   void dispose() {
//     print("Disposing second route");
//     super.dispose();
//   }

//   @override
//   bool get wantKeepAlive => true;
//   final _formKey = GlobalKey<FormState>();

//   String name;
//   String age;
//   String position;
//   String objectType;
//   String phpEndPoint = "";
//   // int _selectedStatus = 0;
//   // int _selectedType = 0;

//   List<DropdownMenuItem<int>> statusList = [];

//   void loadStatusList() {
//     statusList = [];
//     statusList.add(new DropdownMenuItem(
//       child: new Text('Onbekend'),
//       value: 0,
//     ));
//     statusList.add(new DropdownMenuItem(
//       child: new Text('Slecht'),
//       value: 1,
//     ));
//     statusList.add(new DropdownMenuItem(
//       child: new Text('Normaal'),
//       value: 2,
//     ));
//     statusList.add(new DropdownMenuItem(
//       child: new Text('Goed'),
//       value: 3,
//     ));
//     statusList.add(new DropdownMenuItem(
//       child: new Text('Vervanging nodig'),
//       value: 4,
//     ));
//   }

//   List<DropdownMenuItem<int>> typeList = [];
//   void loadTypeList() {
//     typeList = [];
//     typeList.add(new DropdownMenuItem(
//       child: new Text('Lijmlas Edilon-NS'),
//       value: 0,
//     ));
//     typeList.add(new DropdownMenuItem(
//       child: new Text('Lijmlas Edilon-TC'),
//       value: 1,
//     ));
//     typeList.add(new DropdownMenuItem(
//       child: new Text('Lijmlas BWG-S'),
//       value: 2,
//     ));
//     typeList.add(new DropdownMenuItem(
//       child: new Text('Lijmlas BWG-S versterkt'),
//       value: 3,
//     ));
//     typeList.add(new DropdownMenuItem(
//       child: new Text('Lijmlas Kloos HB600'),
//       value: 4,
//     ));
//     typeList.add(new DropdownMenuItem(
//       child: new Text('Lijmlas Kloos HB480'),
//       value: 5,
//     ));
//     typeList.add(new DropdownMenuItem(
//       child: new Text('Lijmlas ETS PF1/BN2 - oud'),
//       value: 6,
//     ));
//     typeList.add(new DropdownMenuItem(
//       child: new Text('Lijmlas ETS PF1/BN2 - nieuw'),
//       value: 7,
//     ));
//     typeList.add(new DropdownMenuItem(
//       child: new Text('Geconstr. las NS'),
//       value: 8,
//     ));
//     typeList.add(new DropdownMenuItem(
//       child: new Text('Geconstr. las Tenconi-4 gats'),
//       value: 9,
//     ));
//     typeList.add(new DropdownMenuItem(
//       child: new Text('Geconstr. las Tenconi-6 gats'),
//       value: 10,
//     ));
//     typeList.add(new DropdownMenuItem(
//       child: new Text('Geconstr. las Exel'),
//       value: 11,
//     ));
//     typeList.add(new DropdownMenuItem(
//       child: new Text('  Geconstr. las BWG-MT'),
//       value: 12,
//     ));
//     typeList.add(new DropdownMenuItem(
//       child: new Text('Geconstr. las BWG-MT versterkt'),
//       value: 13,
//     ));
//     typeList.add(new DropdownMenuItem(
//       child: new Text('Lijmlas type onbekend'),
//       value: 14,
//     ));
//     typeList.add(new DropdownMenuItem(
//       child: new Text('Geconstr. las type onbekend'),
//       value: 15,
//     ));
//     typeList.add(new DropdownMenuItem(
//       child: new Text('Lijmlas Railpro-HIRD'),
//       value: 16,
//     ));
//   }

//   List<Widget> getFormWidget() {
//     List<Widget> formWidget = new List<Widget>();

// //getId information 1
//     formWidget.add(new TextFormField(
//       enabled: false,
//       controller: TextEditingController(
//           text: markerDetailandInformation[0].readableID.toString()),
//       decoration: InputDecoration(
//           labelText: 'equipment',
//           hintText: 'equipment',
//           icon: Icon(Icons.content_paste)),
//       validator: (value) {
//         if (value.isEmpty) {
//           return 'equipment';
//         } else {
//           return '';
//         }
//       },
//       onSaved: (value) {
//         setState(() {
//           name = value;
//         });
//       },
//     ));

//     //getName information 2
//     formWidget.add(new TextFormField(
//       enabled: false,
//       controller: TextEditingController(
//           text: markerDetailandInformation[0].type.toString()),
//       decoration: InputDecoration(
//           labelText: "Type", hintText: 'object type', icon: Icon(Icons.filter)),
//       validator: (value) {
//         if (value.isEmpty) {
//           return 'vul een de juiste type in';
//         } else {
//           return '';
//         }
//       },
//       onSaved: (value) {
//         setState(() {
//           objectType = value;
//         });
//       },
//     ));

//     //getName information 2
//     formWidget.add(new TextFormField(
//       enabled: false,
//       controller: TextEditingController(
//           text: markerDetailandInformation[0].description.toString()),
//       decoration: InputDecoration(
//           labelText: "beschrijving",
//           hintText: 'object type',
//           icon: Icon(Icons.filter)),
//       validator: (value) {
//         if (value.isEmpty) {
//           return 'vul een de juiste type in';
//         } else {
//           return '';
//         }
//       },
//       onSaved: (value) {
//         setState(() {
//           objectType = value;
//         });
//       },
//     ));

//     //getName information 2
//     formWidget.add(new TextFormField(
//       enabled: false,
//       controller: TextEditingController(
//           text: markerDetailandInformation[0].equipmentStatus.toString()),
//       decoration: InputDecoration(
//           labelText: "equipment status",
//           hintText: 'object type',
//           icon: Icon(Icons.filter)),
//       validator: (value) {
//         if (value.isEmpty) {
//           return 'vul een de juiste type in';
//         } else {
//           return '';
//         }
//       },
//       onSaved: (value) {
//         setState(() {
//           objectType = value;
//         });
//       },
//     ));

//     //getName information 2
//     formWidget.add(new TextFormField(
//       enabled: false,
//       controller: TextEditingController(
//           text: markerDetailandInformation[0].parentEquipKind.toString()),
//       decoration: InputDecoration(
//           labelText: "parent equipment",
//           hintText: 'object type',
//           icon: Icon(Icons.filter)),
//       validator: (value) {
//         if (value.isEmpty) {
//           return 'vul een de juiste type in';
//         } else {
//           return '';
//         }
//       },
//       onSaved: (value) {
//         setState(() {
//           objectType = value;
//         });
//       },
//     ));

//     //getName information 2
//     formWidget.add(new TextFormField(
//       enabled: false,
//       controller: TextEditingController(
//           text: markerDetailandInformation[0].datacollection.toString()),
//       decoration: InputDecoration(
//           labelText: "datacollection",
//           hintText: 'object type',
//           icon: Icon(Icons.filter)),
//       validator: (value) {
//         if (value.isEmpty) {
//           return 'vul een de juiste type in';
//         } else {
//           return '';
//         }
//       },
//       onSaved: (value) {
//         setState(() {
//           objectType = value;
//         });
//       },
//     ));

//     //getName information 2
//     formWidget.add(new TextFormField(
//       enabled: false,
//       controller: TextEditingController(
//           text: markerDetailandInformation[0].placement.toString()),
//       decoration: InputDecoration(
//           labelText: "plaatsing",
//           hintText: 'object type',
//           icon: Icon(Icons.filter)),
//       validator: (value) {
//         if (value.isEmpty) {
//           return 'vul een de juiste type in';
//         } else {
//           return '';
//         }
//       },
//       onSaved: (value) {
//         setState(() {
//           objectType = value;
//         });
//       },
//     ));

//     //getName information 2
//     formWidget.add(new TextFormField(
//       enabled: false,
//       controller: TextEditingController(
//           text: markerDetailandInformation[0].latitude.toString()),
//       decoration: InputDecoration(
//           labelText: "latitude",
//           hintText: 'object type',
//           icon: Icon(Icons.filter)),
//       validator: (value) {
//         if (value.isEmpty) {
//           return 'vul een de juiste type in';
//         } else {
//           return '';
//         }
//       },
//       onSaved: (value) {
//         setState(() {
//           objectType = value;
//         });
//       },
//     ));

//     //getName information 2
//     formWidget.add(new TextFormField(
//       enabled: false,
//       controller: TextEditingController(
//           text: markerDetailandInformation[0].longitude.toString()),
//       decoration: InputDecoration(
//           labelText: "longitude",
//           hintText: 'object type',
//           icon: Icon(Icons.filter)),
//       validator: (value) {
//         if (value.isEmpty) {
//           return 'vul een de juiste type in';
//         } else {
//           return '';
//         }
//       },
//       onSaved: (value) {
//         setState(() {
//           objectType = value;
//         });
//       },
//     ));

//     //getName information 2
//     formWidget.add(new TextFormField(
//       enabled: false,
//       controller: TextEditingController(
//           text: markerDetailandInformation[0].runNr.toString()),
//       decoration: InputDecoration(
//           labelText: "run nummer",
//           hintText: 'object type',
//           icon: Icon(Icons.filter)),
//       validator: (value) {
//         if (value.isEmpty) {
//           return 'vul een de juiste type in';
//         } else {
//           return '';
//         }
//       },
//       onSaved: (value) {
//         setState(() {
//           objectType = value;
//         });
//       },
//     ));

//     //getName information 2
//     formWidget.add(new TextFormField(
//       enabled: false,
//       controller: TextEditingController(
//           text: markerDetailandInformation[0].trackVersion.toString()),
//       decoration: InputDecoration(
//           labelText: "track version",
//           hintText: 'object type',
//           icon: Icon(Icons.filter)),
//       validator: (value) {
//         if (value.isEmpty) {
//           return 'vul een de juiste type in';
//         } else {
//           return '';
//         }
//       },
//       onSaved: (value) {
//         setState(() {
//           objectType = value;
//         });
//       },
//     ));

//     //getName information 2
//     formWidget.add(new TextFormField(
//       enabled: false,
//       controller: TextEditingController(
//           text: markerDetailandInformation[0].source.toString()),
//       decoration: InputDecoration(
//           labelText: "source",
//           hintText: 'object type',
//           icon: Icon(Icons.filter)),
//       validator: (value) {
//         if (value.isEmpty) {
//           return 'vul een de juiste type in';
//         } else {
//           return '';
//         }
//       },
//       onSaved: (value) {
//         setState(() {
//           objectType = value;
//         });
//       },
//     ));

//       formWidget.add(new TextFormField(
//       enabled: false,
//       controller: TextEditingController(
//           text: markerDetailandInformation[0].readableID),
//       decoration: InputDecoration(
//           labelText: "readable id",
//           hintText: 'readable id',
//           icon: Icon(Icons.filter)),
//       validator: (value) {
//         if (value.isEmpty) {
//           return 'vul een de juiste type in';
//         } else {
//           return '';
//         }
//       },
//       onSaved: (value) {
//         setState(() {
//           objectType = value;
//         });
//       },
//     ));

  
//     //getId information
//     formWidget.add(Container(
//         margin: const EdgeInsets.only(bottom: 60),
//         child: new TextFormField(
//           enabled: false,
//           controller: TextEditingController(
//               text: markerDetailandInformation[0].year.toString()),
//           decoration: InputDecoration(
//               labelText: "bron datum:",
//               hintText: 'bron datum',
//               icon: Icon(Icons.date_range)),
//           validator: (value) {
//             if (value.isEmpty) {
//               return 'Please enter a datum';
//             } else {
//               return '';
//             }
//           },
//           onSaved: (value) {
//             setState(() {
//               age = value;
//             });
//           },
//         )));

//     formWidget.add(
//       OutlineButton(          
//         focusColor: Colors.orange,
//         onPressed: () {
//           if (status == '') {
//             setState(() {
//               status = "Uploaden is gelukt";
//             });
//             return showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                   // Retrieve the text the user has typed in using our
//                   // TextEditingController
//                   content: Text("uploading"),
//                 );
//               },
//             );
//           } else {
//             setState(() {
//               status = "Error: Het uploaden is niet gelukt";
//             });
//             return null;
//           }
//         },
//         child: Text('Opslaan'),
//       ),
//     );

//     formWidget.add(
//       Text(
//         status,
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           color:status == 'Uploaden is gelukt' ? Colors.green : Colors.red,
//           fontWeight: FontWeight.bold,
//           fontSize: 18.0,
//         ),
//       ),
//     );

//     return formWidget;
//   }

//   String status = '';

//   _loadList() async {
//     markerDetailandInformation.clear();

//     String url = widget.id;
//     print(url);
//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       // final data = json.decode(response.body);
//       markerDetailandInformation = (json.decode(response.body) as List)
//           .map((data) => new MarkerDetail().fromJson(data))
//           .toList();
//     } else {
//       print(url);
//       print("URL NOT FOUND");
//     }

//     setState(() {});
//   }

//   @override
//   void initState() {
//     print("lOADING LIST");
//    // _loadList();

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // loadStatusList();
//     // loadTypeList();

//     if (markerDetailandInformation.isEmpty) {
//       print(markerDetailandInformation.length);
//       return Center(child: CircularProgressIndicator());
//     } else {
//       return Container(
//         child: Form(
//           key: _formKey,
//           child: new ListView(
//             padding: EdgeInsets.all(20.0),
//             children: getFormWidget(),
//           ),
//         ),
//       );
//     }

//   }
// }