import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SearchFavoriteView.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class HistoryView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HistoryViewState();
  }
}

class HistoryViewState extends State<HistoryView> {
  //return a specific value order of index : [0]=>lat,[1]=>long,[2]=>ImageUrl
  String _getPrefData(String values, int index) {
    List<String> _spliteArr = values.split(",");
    return _spliteArr[index].toString();
  }

  Future<List<Widget>> getAllPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    ///return  a list (Keys ,values) of sharedPreferences and not cache(map) records
    return prefs
        .getKeys()
        .where((String key) =>
            key != "lib_cached_image_data" &&
            key != "lib_cached_image_data_last_clean")
        .map<Widget>((key) => Row(children: <Widget>[
              Expanded(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image.asset(_getPrefData(prefs.get(key), 2)),
                  ),
                  title: Text(key),
                  subtitle: Text("" +
                      _getPrefData(prefs.get(key), 0) +
                      ',' +
                      _getPrefData(prefs.get(key), 1)),
                  onTap: () {
                    List<String> splitArr =
                        prefs.get(key).toString().split(",");
                    SearchFavoriteView.favoriteLat =
                        double.tryParse(splitArr[0]);
                    SearchFavoriteView.favoriteLong =
                        double.tryParse(splitArr[1]);
                    SearchFavoriteView.locationImage = splitArr[2];
                    print(splitArr[2]);
                    SearchFavoriteView.favoritePlaceName = key;
                    SearchFavoriteView.isFavorite = true;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchFavoriteView()),
                    );
                  },
                ),
              ),

              /// Copy Button for every LitTile
              IconButton(
                  icon: Icon(Icons.content_copy),
                  iconSize: 20,
                  color: Colors.grey[500],
                  onPressed: () {
                    Clipboard.setData(new ClipboardData(
                        text:
                            "${_getPrefData(prefs.get(key), 0)} ,${_getPrefData(prefs.get(key), 1)}"));
                    showToast("Copied",
                        gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
                  }),
            ]))
        .toList(growable: true);
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  void deleteAllPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }


//  child: new Column(
//     mainAxisSize: MainAxisSize.max,
//     children: <Widget>[
//       new Text('Top'),
//       new Expanded(
//         child: new Align(
//           alignment: Alignment.bottomCenter,
//           child: new Text('Bottom'),
//         ),
//       ),
//     ],
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
         
          //refresh button
          //  ListTile(
          //   title: Text("Refresh"),
          //   onTap: () {
          //     setState(() {
          //       getAllPrefs();
          //     });
          //   },
          // ),

          ListTile(
            leading: Icon(
              Icons.delete,
              color: Colors.redAccent,
              size: 32,
            ),
            title: Text("Verwijder geschiedenis"),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Row(
                        children: <Widget>[
                          Icon(
                            Icons.warning,
                            color: Colors.redAccent,
                            size: 32,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("Are you sure ?"),
                          ),
                        ],
                      ),
                      content: Text(
                          "Do you really want to delete these records? This process cannot be undone."),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text("Delete"),
                          onPressed: () {
                            setState(() {
                              deleteAllPrefs();
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            },
          ),

              

          FutureBuilder<List<Widget>>(
              //  getAllPrefs return List of Widgets
              future: getAllPrefs(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return new Center(
                    child: Container(),
                  );
                } else if (snapshot.hasError) {
                  return ListTile(
                    title: Text("Couldn\'t get Favorite Positions"),
                  );
                } else if (!snapshot.hasData)
                  return ListTile(
                    title: Text("No Favorite Positions Saved"),
                  );
                else {
                  return Column(children: snapshot.data);
                }
                
              }),
        
         
        ],
      ),
    );
  }

  
   void dispose() {
    // Clean up the controller when the Widget is disposed
    super.dispose();
  }
}
