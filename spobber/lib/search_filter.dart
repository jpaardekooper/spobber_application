import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';

bool isSap = false;
bool isSigma = false;
bool isUST02 = false;
bool isVideo = false;

class SearchFilter extends StatefulWidget {
  final Function updateKeyword;

  SearchFilter(this.updateKeyword);

  @override
  State<StatefulWidget> createState() {
    return _SearchFilter(updateKeyword);
  }
}

class _SearchFilter extends State<SearchFilter> {
//this goes in our State class as a global variable

  static final List<String> filterOptions = <String>[
    "Es-las",
    "Bovenleiding",
  ];

  static const String _KEY_SELECTED_POSITION = "position";
  static const String _KEY_SELECTED_VALUE = "value";

  int _selectedPosition = 0;
  final Function updateKeyword;

  _SearchFilter(this.updateKeyword);

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
          title: Text('Selecteer object'),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              selected: _selectedPosition == 0,
              leading: Icon(Icons.room),
              title: Text(filterOptions[0]),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildAboutDialog(context),
                );
                _saveKeywordPreference(0);
              },
              trailing: _getIcon(0),
            ),
            ListTile(
              selected: _selectedPosition == 1,
              leading: Icon(Icons.tram),
              title: Text(filterOptions[1]),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildAboutDialog(context),
                );
                _saveKeywordPreference(1);
              },
              trailing: _getIcon(1),
            ),
            //this goes in as one of the children in our column

            // ListTile(
            //   selected: _selectedPosition == 2,
            //   leading: Icon(Icons.local_cafe),
            //   title: Text(filterOptions[2]),
            //   onTap: () {
            //     _saveKeywordPreference(2);
            //   },
            //   trailing: _getIcon(2),
            // ),
            // ListTile(
            //   selected: _selectedPosition == 3,
            //   leading: Icon(Icons.local_dining),
            //   title: Text(filterOptions[3]),
            //   onTap: () {
            //     _saveKeywordPreference(3);
            //   },
            //   trailing: _getIcon(3),
            // ),
            // ListTile(
            //   selected: _selectedPosition == 4,
            //   leading: Icon(Icons.local_grocery_store),
            //   title: Text(filterOptions[4]),
            //   onTap: () {
            //     _saveKeywordPreference(4);
            //   },
            //   trailing: _getIcon(4),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _getIcon(int value) {
    return Builder(
      builder: (BuildContext context) {
        if (value == _selectedPosition) {
          return Icon(Icons.check);
        } else {
          return SizedBox(
            width: 50,
          );
        }
      },
    );
  }

  void _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedPosition = prefs.getInt(_KEY_SELECTED_POSITION) ?? 0;
    });
  }

  void _saveKeywordPreference(int position) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedPosition = position;
      prefs.setString(_KEY_SELECTED_VALUE, filterOptions[position]);
      prefs.setInt(_KEY_SELECTED_POSITION, position);
      updateKeyword(filterOptions[position]);
      // Navigator.pop(context);
      //Scaffold.of(context).openEndDrawer();
    });
  }



  Widget _buildAboutDialog(BuildContext context) {
    return new AlertDialog(
      // title: const Text(
      //   'Selecteer Data bronnen',
      //   style: TextStyle(fontSize: 15),
      // ),
      content: new Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
           mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: new Text(
                "Selecteer data bronnen ",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            // _buildAboutText(),
            // _buildLogoAttribution(),
            SwitchListTile(
                title: const Text('SAP'),
                value: isSap,
                onChanged: (bool value) {
                  setState(() {
                    isSap = value;
                  });
                },
                secondary: const Icon(Icons.tram)),
            SwitchListTile(
                title: const Text('Sigma'),
                value: isSigma,
                onChanged: (bool value) {
                  setState(() {
                    isSigma = value;
                  });
                },
                secondary: const Icon(Icons.tram)),
            SwitchListTile(
                title: const Text('UST02 meettrein'),
                value: isUST02,
                onChanged: (bool value) {
                  setState(() {
                    isUST02 = value;
                  });
                },
                secondary: const Icon(Icons.tram)),
            SwitchListTile(
                title: const Text('Videoschouwtrein'),
                value: isVideo,
                onChanged: (bool value) {
                  setState(() {
                    isVideo = value;
                  });
                },
                secondary: const Icon(Icons.tram)),

            ListTile(
              title: new Text(
                "Opslaan ",
                style: TextStyle(
                    color: Colors.lightBlue, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      // actions: <Widget>[
      //   new FlatButton(
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //     textColor: Theme.of(context).primaryColor,
      //     child: const Text(
      //       'Opslaan, en doorgaan',
      //     ),
      //   ),
      // ],
    );
  }

  bool _isChecked = true;

  List<String> _texts = [
    "InduceSmile.com," "Flutter.io",
    "google.com",
    "youtube.com",
    "yahoo.com",
    "gmail.com"
  ];
}
