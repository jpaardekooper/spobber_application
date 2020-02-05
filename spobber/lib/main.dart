import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spobber/clustering/map_helper.dart';
import 'package:spobber/pages/login/login_page.dart';
import 'package:spobber/pages/login/register_page.dart';
import 'package:spobber/pages/homescreen_tabs.dart';
import 'data/global_variable.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    initIcons().then((_) {
      runApp(MyApp());
    });
  });
}

//url to SAP img (yellow)
const String _markerImageUrlSap =
    'https://spobberstorageaccount.dfs.core.windows.net/marker/sap2.png?sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2021-07-13T22:18:33Z&st=2019-10-24T14:18:33Z&spr=https&sig=W%2BMVqLEyoZmIRE3aj9147RJ%2FYrsbl0uEcjuPVNsNYU4%3D';

/// Url image used on cluster markers (red)
const String _markerImageUrlSigma =
    'https://spobberstorageaccount.dfs.core.windows.net/marker/SIGMA.png?sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2021-07-13T22:18:33Z&st=2019-10-24T14:18:33Z&spr=https&sig=W%2BMVqLEyoZmIRE3aj9147RJ%2FYrsbl0uEcjuPVNsNYU4%3D';

/// Url image used on cluster markers (blue)
const String _markerImageUrlMeetTrein =
    'https://spobberstorageaccount.dfs.core.windows.net/marker/ust02.png?sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2021-07-13T22:18:33Z&st=2019-10-24T14:18:33Z&spr=https&sig=W%2BMVqLEyoZmIRE3aj9147RJ%2FYrsbl0uEcjuPVNsNYU4%3D';

const String _markerImageSpobber =
    'https://spobberstorageaccount.dfs.core.windows.net/marker/spobber.png?sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2021-07-13T22:18:33Z&st=2019-10-24T14:18:33Z&spr=https&sig=W%2BMVqLEyoZmIRE3aj9147RJ%2FYrsbl0uEcjuPVNsNYU4%3D';

//initializing the icons before the app starts
initIcons() async {
  markerSap = await MapHelper.getMarkerImageFromUrl(_markerImageUrlSap);
  markerSigma = await MapHelper.getMarkerImageFromUrl(_markerImageUrlSigma);
  markerUst02 = await MapHelper.getMarkerImageFromUrl(_markerImageUrlMeetTrein);
  markerSpobber = await MapHelper.getMarkerImageFromUrl(_markerImageSpobber);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        //Theme color can be found under theme directory
        //  primarySwatch: myColor,
        primaryColor: myColor,
        accentColor: const Color.fromRGBO(51, 216, 178, 1),
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent)
      ),
      home: LoginPage(),
      routes: <String, WidgetBuilder>{
        '/screen1': (BuildContext context) => new LoginPage(),
        '/screen2': (BuildContext context) => new TabsViewMaps(),
        '/screen3': (BuildContext context) => new RegisterPage(),
      },
    );
  }
}
