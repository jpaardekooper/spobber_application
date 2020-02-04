import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:spobber/data/Users.dart';
import 'package:spobber/pages/login/register_page.dart';
import 'package:spobber/pages/homescreen_tabs.dart';

import 'package:encrypt/encrypt.dart' as encrypt;

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  GlobalKey<FormState> _key = new GlobalKey();
  SharedPreferences sharedpreferences;

  GlobalKey key = GlobalKey();
  // final cryptor = new PlatformStringCryptor();
  // final key =
  //     'MZlo8hLg5HDeJpsEIp5jVQ==:NxiOBTn9vVfENgCG13onWLKKmj2mC8eibz7rDnuRLJQ=';

  bool checkpassword = false;
  bool _validate = false;
  bool invalidInfo = false;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  String name, password, email;

  Animation _loginAnimation;
  AnimationController _loginAnimationController;

  @override
  void initState() {
    super.initState();
    //  initIcons();
    loadData();
  }

  // static const String _markerImageUrlSap =
  //     'https://spobberstorageaccount.dfs.core.windows.net/marker/sap2.png?sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2021-07-13T22:18:33Z&st=2019-10-24T14:18:33Z&spr=https&sig=W%2BMVqLEyoZmIRE3aj9147RJ%2FYrsbl0uEcjuPVNsNYU4%3D';

  // /// Url image used on cluster markers (red)
  // static const String _markerImageUrlSigma =
  //     'https://spobberstorageaccount.dfs.core.windows.net/marker/SIGMA.png?sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2021-07-13T22:18:33Z&st=2019-10-24T14:18:33Z&spr=https&sig=W%2BMVqLEyoZmIRE3aj9147RJ%2FYrsbl0uEcjuPVNsNYU4%3D';

  // /// Url image used on cluster markers (blue)
  // static const String _markerImageUrlMeetTrein =
  //     'https://spobberstorageaccount.dfs.core.windows.net/marker/ust02.png?sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2021-07-13T22:18:33Z&st=2019-10-24T14:18:33Z&spr=https&sig=W%2BMVqLEyoZmIRE3aj9147RJ%2FYrsbl0uEcjuPVNsNYU4%3D';

  // static const String _markerImageSpobber =
  //     'https://spobberstorageaccount.dfs.core.windows.net/marker/spobber.png?sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2021-07-13T22:18:33Z&st=2019-10-24T14:18:33Z&spr=https&sig=W%2BMVqLEyoZmIRE3aj9147RJ%2FYrsbl0uEcjuPVNsNYU4%3D';

  // initIcons() async {
  //   markerSap = await MapHelper.getMarkerImageFromUrl(_markerImageUrlSap);
  //   markerSigma = await MapHelper.getMarkerImageFromUrl(_markerImageUrlSigma);
  //   markerUst02 =
  //       await MapHelper.getMarkerImageFromUrl(_markerImageUrlMeetTrein);
  //   markerSpobber = await MapHelper.getMarkerImageFromUrl(_markerImageSpobber);
  // }

  final GlobalKey<ScaffoldState> _scaffoldKeyLogin = GlobalKey<ScaffoldState>();

  void showMessage(String message, Color color) {
    _scaffoldKeyLogin.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  loadanimation() {
    _loginAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    _loginAnimation =
        Tween(begin: MediaQuery.of(context).size.width * 0.9, end: 50.0)
            .animate(
      new CurvedAnimation(
        parent: _loginAnimationController,
        curve: new Interval(
          0.0,
          0.150,
        ),
      ),
    );
  }

  bool userFound = false;
  void loadData() async {
    sharedpreferences = await SharedPreferences.getInstance();
    if (sharedpreferences?.containsKey('user') != null) {
      userFound = true;
      autoLogin();
    }
  }

  checkLoginConfirmation() async {
    User login = await getUserinfo(
        'http://spobber.azurewebsites.net/api/authentication/login?username=$name&password=$password');

    if (login.username != null ||
        login.email != null ||
        login.password != null) {
      //  String _password = await cryptor.decrypt(login.password, key);
      String _password = login.password;
      print("dit is password variable " + password);
      print("dit is _password variable " + _password);
      // final plainText = _password;
      final key = encrypt.Key.fromUtf8('@+()_FDAS()HJIUOPFiphdusfaho8!@&');
      final iv = encrypt.IV.fromLength(16);

      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final encrypted = encrypter.encrypt(_password, iv: iv);
      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      // print(decrypted);

      if (decrypted == _password) {
        saveUser(User(
            username: login.username,
            password: login.password,
            email: login.email));
        showMessage('Login was succesvol!', Colors.blue);

        //   Future.delayed(const Duration(milliseconds: 1000), () {
        goToMainPage();
        //   });
      } else {
        _errorMessage();
      }
    } else {
      _errorMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    loadanimation();
    _loginAnimationController.addListener(() async {
      if (_loginAnimation.isCompleted) {
        checkLoginConfirmation();
      }
    });

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKeyLogin,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            // Box decoration takes a gradient
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.1, 0.9],
              colors: [
                // Colors are easy thanks to Flutter's Colors class.
                const Color(0xff004990),
                const Color(0xff0066C6),
              ],
            ),
          ),
          child: Form(
            key: _key,
            autovalidate: _validate,
            child: loginWidget(),
          ),
        ));
  }

  Widget loginWidget() {
    return Center(
      child: Container(
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0))),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 130.0,
              width: 130.0,
              decoration: const BoxDecoration(
                image: const DecorationImage(
                    image: const AssetImage('assets/ic_launcher.png'),
                    fit: BoxFit.contain),
              ),
            ),
            TextFormField(
              validator: validateName,
              textInputAction: TextInputAction.next,
              focusNode: _nameFocus,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _nameFocus, _passwordFocus);
              },
              autofocus: false,
              onSaved: (String val) async {
                name = val;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                errorText:
                    invalidInfo ? 'Verkeerde gebruikersnaam opgegeven' : null,
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            TextFormField(
              validator: validatePassword,
              focusNode: _passwordFocus,
              textInputAction: TextInputAction.done,
              obscureText: checkpassword ? false : true,
              autofocus: false,
              onSaved: (String val) async {
                password = val;
                //password = await cryptor.encrypt(val, key);
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: checkpassword ? Colors.red : Colors.grey[700],
                  ),
                  onPressed: () => setState(() {
                    checkpassword = !checkpassword;
                  }),
                ),
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            AnimatedBuilder(
              animation: _loginAnimationController,
              builder: (context, child) {
                return MaterialButton(
                  //    minWidth: _loginAnimation.value,
                  height: 50.0,
                  highlightColor: Theme.of(context).primaryColor,
                  color: Theme.of(context).primaryColor,
                  hoverColor: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: _loginAnimation.value > 150
                        ? BorderRadius.circular(10.0)
                        : BorderRadius.circular(50.0),
                    //  side: BorderSide(color: Colors.red)
                  ),
                  child: _loginAnimation.value > 150
                      ? Text(
                          'Log in',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .title
                                  .color,
                              fontSize: 16),
                        )
                      : CircularProgressIndicator(
                          value: null,
                          strokeWidth: 2,
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                  onPressed: () => {
                    FocusScope.of(context).requestFocus(FocusNode()),
                    _sendToServer(),
                  },
                  splashColor: Colors.blue,
                );
              },
            ),
            Divider(
              height: 40,
            ),
            Container(
              color: Colors.transparent,
              child: FlatButton(
                child: Text(
                  'Heeft u nog geen account?\n Druk hier om te registreren',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue[200],
                    fontSize: 14,
                  ),
                ),
                onPressed: goToRegistering,
              ),
            ),
            Container(height: 10),
          ],
        ),
      ),
    );
  }

  void autoLogin() async {
    try {
      User user =
          User.fromJson(json.decode(sharedpreferences.getString('user')));
      String _username = user.username;
      String _password = user.password;
      goToMainPage();

      final response = await http.get(
          'http://spobber.azurewebsites.net/api/authentication/login?username=$_username&password=$_password');
      print(response.statusCode);
      if (response.statusCode == 200) {
        showMessage('Login was succesvol!', Colors.blue);
      } else {
        print(response.statusCode);
        return null;
      }
    } catch (Exception) {
      return null;
    }
  }

  void goToMainPage() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (c, a1, a2) => TabsViewMaps(),
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 1000),
      ),
    );
  }

  void goToRegistering() {
    Navigator.of(context).push(_registerRoute());
  }

  Route _registerRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => RegisterPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  String validateName(String value) {
    if (value.length == 0) {
      return "Please enter a name";
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.length == 0) {
      return "Please enter a password";
    }
    return null;
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
      _loginAnimationController.forward();
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }

  _errorMessage() {
    _loginAnimationController.reverse();
    showMessage('Verkeerde gegevens opgegeven!', Colors.red[700]);
    setState(() {
      invalidInfo = true;
    });
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  saveUser(User user) {
    sharedpreferences.setString('user', json.encode(user));
  }

  Future<User> getUserinfo(String url) async {
    Map<String, String> data = {
      "email": email,
      "username": name,
      "password": password,
    };

    http.Response response = await http.get(url, headers: data);

    if (response.statusCode == 200) {
      print(response.body);
      return User.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }
}
