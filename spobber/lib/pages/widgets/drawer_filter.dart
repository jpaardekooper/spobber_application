import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spobber/data/global_variable.dart';
import 'package:spobber/pages/history_view.dart';
import 'package:spobber/pages/tflite/home.dart';
import 'package:spobber/pages/widgets/page.dart';
import 'add_object.dart';

class DrawerFilter extends StatefulWidget {
  @override
  _DrawerFilter createState() => _DrawerFilter();
}

class _DrawerFilter extends State<DrawerFilter> {
  bool showUserDetails = false;
  List<CameraDescription> cameras;
  Widget _buildDrawerList() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Text("Nieuw Object toevoegen"),
          // subtitle: Text("-"),
          leading: const Icon(Icons.add),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).accentColor,
            size: 18,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => (PlaceMarkerBody()),
              ),
            );
          },
        ),
        ListTile(
          title: const Text("TensorFlow"),
          //subtitle: Text("-"),
          leading: Icon(Icons.camera_alt),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).accentColor,
            size: 18,
          ),
          onTap: () async {
            try {
              cameras = await availableCameras();
            } on CameraException catch (e) {
              print('Error: $e.code\nError Message: $e.message');
            }

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => (HomePage(cameras)),
                ));
          },
        ),
        ListTile(
          title: const Text("Geschiedenis:"),
          // subtitle: Text("date"),
          leading: Icon(Icons.history),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).accentColor,
            size: 18,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryView()),
            );
          },
        ),
        ListTile(
          title: const Text("Info:"),
          //  subtitle: Text("date"),
          leading: const Icon(Icons.info),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).accentColor,
            size: 18,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TutorialSpot()),
            );
          },
        ),
        Divider(),
        ListTile(
          title: const Text(
              'Eigendom van Result! Data.ai, Zoetermeer, onderdeel van de Result! groep, meer informatie bij info@resultdata.ai'),
          enabled: false,
          leading: const Icon(Icons.copyright),
        )
      ],
    );
  }

  static const double heightPop = 30;
  static const double widthPop = 70;

  void popupMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Afmelden'),
          content: const Text('Weet u zeker dat u wilt afmelden?'),
          actions: <Widget>[
            FlatButton(
              child: const Text("Annuleren"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Container(
                alignment: Alignment.center,
                height: heightPop,
                width: widthPop,
                color: Colors.red,
                child: const Text(
                  'Bevestigen',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
              onPressed: () => goToLogin(),
            ),
          ],
        );
      },
    );
  }

  void goToLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //   setState(() {
    prefs.remove('user');
//    });
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/screen1', (Route<dynamic> route) => false);
  }

  Widget _buildUserDetail() {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          ListTile(
              title: const Text("Afmelden"),
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
              onTap: popupMessage),
          Divider(),
          ListTile(
            title: const Text("User details"),
            leading: Icon(Icons.info_outline),
          ),
          Divider(),
          ListTile(
            title: const Text("Device"),
            subtitle: Theme.of(context).platform == TargetPlatform.iOS
                ? const Text("IOS Device")
                : const Text("Android Device"),
            leading: Icon(Icons.device_unknown),
          ),
          ListTile(
            title: const Text("Account is gemaakt op:"),
            subtitle: const Text("31-1-2020"),
            leading: const Icon(Icons.question_answer),
          ),
          Divider(),
          ListTile(
            title: const Text('Versie 5.0.0'),
            enabled: false,
            leading: const Icon(Icons.system_update),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        UserAccountsDrawerHeader(
          margin: EdgeInsets.all(0),
          accountName: Text(userInformation.username),
          accountEmail: Text(userInformation.email),
          onDetailsPressed: () {
            setState(() {
              showUserDetails = !showUserDetails;
            });
          },
          currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? const Text("I", style: TextStyle(fontSize: 40.0))
                  : const Text("A", style: TextStyle(fontSize: 40.0))),
        ),
        Expanded(
            child: showUserDetails ? _buildUserDetail() : _buildDrawerList())
      ]),
    );
  }
}
