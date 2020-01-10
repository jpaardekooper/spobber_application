import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spobber/data/global_variable.dart';
import 'package:spobber/data/place_response.dart';
import 'package:spobber/pages/widgets/single_marker_with_maps.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class HistoryView extends StatefulWidget {
  // @override
  // State<StatefulWidget> createState() {
  //   return HistoryViewState();
  // }

  @override
  HistoryViewState createState() => HistoryViewState();
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
            key != "lib_cached_image_data_last_clean" &&
            key.contains('__'))
        .map<Widget>((key) => Row(children: <Widget>[
              Expanded(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image.asset(_getPrefData(prefs.get(key), 2)),
                    radius: 8,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
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
                                    child: Text("Bevestigen ?"),
                                  ),
                                ],
                              ),
                              content: Text(
                                  "Weet u zeker dat u uw geschiedenis wilt verwijderen? Het kan niet meer worden teruggedraaid"),
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
                                      deleteAllPrefs(key);
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                  ),
                  title: Text(
                    "ID: " + key.replaceRange(0, 2, ""),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Locatie: " +
                      _getPrefData(prefs.get(key), 0) +
                      ',' +
                      _getPrefData(prefs.get(key), 1)),
                  onTap: () {
                    List<String> splitArr =
                        prefs.get(key).toString().split(",");

                    ///array 0 is latitude
                    ///array 1 is longitude
                    ///array 2 is imageData assets/imagename
                    ///array 3 is source
                    ///array 4 is secretid
                    ///array 5 is type
                    singleMarker.clear();
                    singleMarker.add(new PlaceResponse(
                        type: splitArr[5],
                        secretId: splitArr[4],
                        latitude: double.tryParse(splitArr[0]),
                        longitude: double.tryParse(splitArr[1]),
                        readableID: key.replaceRange(0, 2, ""),
                        source: splitArr[3]));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SingleMarkerWithMaps()),
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

  void deleteAllPrefs(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.remove(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Geschiedenis overzicht"),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          //refresh button
          ListTile(
            title: Text("Refresh"),
            onTap: () {
              setState(() {
                getAllPrefs();
              });
            },
          ),

          // ListTile(
          //   leading: Icon(
          //     Icons.delete,
          //     color: Colors.redAccent,
          //     size: 32,
          //   ),
          //   title: Text("Verwijder geschiedenis"),
          //   onTap: () {

          // );

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
                    title: Text("Couldn\'t get History Positions"),
                  );
                } else if (!snapshot.hasData)
                  return ListTile(
                    title: Text("No Favorite History is Saved"),
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
