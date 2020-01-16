import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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
          title:const Text("Geschiedenis:"),
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
          title:const Text("Info:"),
          //  subtitle: Text("date"),
          leading:const Icon(Icons.info),
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
          title:const Text('Versie 4.0.0'),
          enabled: false,
          leading: const Icon(Icons.system_update),
        )
      ],
    );
  }

  Widget _buildUserDetail() {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          ListTile(
            title:const Text("User details"),
            leading: Icon(Icons.info_outline),
          ),
          Divider(),
          ListTile(
            title:const Text("Device"),
            subtitle: Theme.of(context).platform == TargetPlatform.iOS
                ?const Text("IOS Device")
                : const Text("Android Device"),
            leading: Icon(Icons.device_unknown),
          ),
          ListTile(
            title:const Text("Account is gemaakt op:"),
            subtitle:const Text("date"),
            leading:const Icon(Icons.question_answer),
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
                  ?const Text("I", style: TextStyle(fontSize: 40.0))
                  : const Text("A", style: TextStyle(fontSize: 40.0))),
        ),
        Expanded(
            child: showUserDetails ? _buildUserDetail() : _buildDrawerList())
      ]),
    );
  }
}
