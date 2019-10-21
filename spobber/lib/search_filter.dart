import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'data/global_variable.dart';



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
          title: Text('Selecteer een object type' , style: TextStyle(fontSize: 16)),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              selected: _selectedPosition == 0,
              leading: Icon(Icons.room),
              title: Text(filterOptions[0]),
              onTap: () {
                _saveKeywordPreference(0);
              },
              trailing: _getIcon(0),
            ),
            ListTile(
              selected: _selectedPosition == 1,
              leading: Icon(Icons.tram),
              title: Text(filterOptions[1]),
              onTap: () {          
                _saveKeywordPreference(1);
              },
              trailing: _getIcon(1),
            ),   
       
          ],
        ),
        endDrawer: new SearchFilter2(),
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
  }






///////////////////////////////////////////////////////////////////////////////



class SearchFilter2 extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _SearchFilter2();
  }
}

class _SearchFilter2 extends State<SearchFilter2> {
//this goes in our State class as a global variable 

  @override
  void initState() {
    super.initState();
  //  _loadPreferences();
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
          title: Text('Selecteer een of meerdere bronnen' , style: TextStyle(fontSize: 16)),
        ),
        body: ListView(
          children: <Widget>[
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
                secondary: const Icon(Icons.tram)
                ),    
          ],
        ),  
      ),
      
    );
  }



  
  


}
