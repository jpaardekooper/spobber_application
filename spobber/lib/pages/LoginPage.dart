import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:spobber/data/Users.dart';
import 'package:spobber/pages/Registeringpage.dart';
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

    loadData();
  }

  loadanimation() {
    _loginAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));

    _loginAnimation =
        Tween(begin: MediaQuery.of(context).size.width * 0.8, end: 50.0)
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

  void loadData() async {
    sharedpreferences = await SharedPreferences.getInstance();
    if (sharedpreferences?.containsKey('user') != null) {
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
      print("dit is password variable "+ password);
      print("dit is _password variable " +_password);
      // final plainText = _password;
      final key = encrypt.Key.fromUtf8('@+()_FDAS()HJIUOPFiphdusfaho8!@&');
      final iv = encrypt.IV.fromLength(16);

      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final encrypted = encrypter.encrypt(_password, iv: iv);
      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      print(decrypted);

      if (decrypted == _password) {
        saveUser(User(
            username: login.username,
            password: login.password,
            email: login.email));
        goToMainPage();
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
      body: Container(
        child: new Form(
          key: _key,
          autovalidate: _validate,
          child: loginWidget(),
        ),
      ),
    );
  }

  Widget loginWidget() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Column(children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.26,
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
                    errorText: invalidInfo
                        ? 'Combinatie van usernaam en wachtwoord wordt niet herkent'
                        : null,
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
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
          ),
          AnimatedBuilder(
            animation: _loginAnimationController,
            builder: (context, child) {
              return Container(
                width: _loginAnimation.value,
                height: 50.0,
                alignment: FractionalOffset.center,
                decoration: new BoxDecoration(
                  color: Color(0xFF0062A5),
                  borderRadius: new BorderRadius.all(
                    _loginAnimation.value > 60
                        ? const Radius.circular(10.0)
                        : const Radius.circular(30.0),
                  ),
                ),
                child: SizedBox.expand(
                  child: FlatButton(
                    color: Colors.transparent,
                    child: _loginAnimation.value > 75
                        ? Text(
                            'Log in',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .title
                                    .color,
                                fontSize: 16),
                          )
                        : FittedBox(
                            fit: BoxFit.fill,
                            child: CircularProgressIndicator(
                              value: null,
                              strokeWidth: 4,
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          ),
                    onPressed: () => {
                      FocusScope.of(context).requestFocus(FocusNode()),
                      _sendToServer(),
                    },
                  ),
                ),
              );
            },
          ),
          Divider(
            height: 50,
          ),
          Container(
            width: 180,
            height: 30,
            color: Colors.transparent,
            child: FlatButton(
              child: Text(
                'Heeft u nog geen account? Druk hier om te registreren',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue[200],
                  fontSize: 13,
                ),
              ),
              onPressed: () => goToRegistering(),
            ),
          ),
        ]));
  }

  void autoLogin() async {
    try {
      User user =
          User.fromJson(json.decode(sharedpreferences.getString('user')));
      String _username = user.username;
      String _password = user.password;

      final response = await http.get(
          'http://spobber.azurewebsites.net/api/authentication/login?username=$_username&password=$_password');
      print(response.statusCode);
      if (response.statusCode == 200) {
        goToMainPage();
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
        var begin = Offset(0.0, 1.0);
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
