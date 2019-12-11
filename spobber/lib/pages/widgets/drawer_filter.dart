import 'package:flutter/material.dart';
import '../../data/global_variable.dart';

//Represents the Homepage widget
class DrawerFilter extends StatefulWidget {
  //`createState()` will create the mutable state for this widget at
  //a given location in the tree.
  @override
  _DrawerFilter createState() => _DrawerFilter();
}

//Our Home state, the logic and internal state for a StatefulWidget.
class _DrawerFilter extends State<DrawerFilter> {
  //A controller for an editable text field.
  //Whenever the user modifies a text field with an associated
  //TextEditingController, the text field updates value and the
  //controller notifies its listeners.
  var _searchview = new TextEditingController();

  bool _firstSearch = true;
  String _query = "";

  List<String> _nebulae;
  List<String> _filterList;

  @override
  void initState() {
    super.initState();
    _nebulae = new List<String>();
    _nebulae = [
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
    _nebulae.sort();
  }

  _DrawerFilter() {
    //Register a closure to be called when the object changes.
    _searchview.addListener(() {
      if (_searchview.text.isEmpty) {
        //Notify the framework that the internal state of this object has changed.
        setState(() {
          _firstSearch = true;
          _query = "";
        });
      } else {
        setState(() {
          _firstSearch = false;
          _query = _searchview.text;
        });
      }
    });
  }

//Build our Home widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: searchObject == null
                  ? Text(
                      "Zoeken naar...",
                      style: TextStyle(fontSize: 15.0),
                    )
                  : Text(
                      "$searchObject",
                      style: TextStyle(fontSize: 15.0),
                    ),
            
      ),
      body: new Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: new Column(
          children: <Widget>[
            _createSearchView(),
            _firstSearch ? _createListView() : _performSearch()
          ],
        ),
      ),
    );
  }

  //Create a SearchView
  Widget _createSearchView() {
    return new Container(
      decoration: BoxDecoration(border: Border.all(width: 1.0)),
      child: new TextField(
        controller: _searchview,
        decoration: InputDecoration(
          hintText: "Zoeken naar..",
          hintStyle: new TextStyle(color: Colors.grey[300]),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  //Create a ListView widget
  Widget _createListView() {
    return new Flexible(
      child: new ListView.builder(
          itemCount: _nebulae.length,
          itemBuilder: (BuildContext context, int index) {
            return new GestureDetector(
                onTap: () {
                  setState(() {
                    searchObject = _nebulae[index];
                    print(searchObject);
                  });
                },
                child: new Card(
                  color: Colors.white,
                  elevation: 5.0,
                  child: new Container(
                    margin: EdgeInsets.all(15.0),
                    child: new Text("${_nebulae[index]}"),
                  ),
                ));
          }),
    );
  }

  //Perform actual search
  Widget _performSearch() {
    _filterList = new List<String>();
    for (int i = 0; i < _nebulae.length; i++) {
      var item = _nebulae[i];

      if (item.toLowerCase().contains(_query.toLowerCase())) {
        _filterList.add(item);
      }
    }
    return _createFilteredListView();
  }

  //Create the Filtered ListView
  Widget _createFilteredListView() {
    return new Flexible(
      child: new ListView.builder(
          itemCount: _filterList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  searchObject = _filterList[index];
                  print(searchObject);
                });
              },
              child: new Card(
                color: Colors.white,
                elevation: 5.0,
                child: new Container(
                  margin: EdgeInsets.all(15.0),
                  child: new Text("${_filterList[index]}"),
                ),
              ),
            );
          }),
    );
  }
}
