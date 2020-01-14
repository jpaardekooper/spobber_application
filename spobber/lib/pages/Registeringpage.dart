import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool checkpassword = false;
  bool _validate = false;
  String name, email, password;
  String _spobberEndpoint = 'http://spobber.azurewebsites.net/api/';
  TextEditingController passwordController = new TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _validatepasswordFocus = FocusNode();

  Future<bool> register(
      String _email, String _username, String _password) async {
    final cryptor = new PlatformStringCryptor();
    final key =
        'MZlo8hLg5HDeJpsEIp5jVQ==:NxiOBTn9vVfENgCG13onWLKKmj2mC8eibz7rDnuRLJQ=';
    final encrypted = await cryptor.encrypt(_password, key);

    Map data = {"email": _email, "username": _username, "password": encrypted};
    HttpClientRequest request = await _preparePostPackage(
        _spobberEndpoint + "authentication/register", data);
    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/screen1', (Route<dynamic> route) => false);
      return true;
    } else {
      response = await request.close();
      if (response.statusCode == 200) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/screen1', (Route<dynamic> route) => false);
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Registration'),
      ),
      body: new SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.all(15.0),
          child: new Form(
            key: _key,
            autovalidate: _validate,
            child: registeringUI(),
          ),
        ),
      ),
    );
  }


  Widget registeringUI() {
    return Center(
      child: Container(
        width: 250,
        child: new Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              focusNode: _emailFocus,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _emailFocus, _nameFocus);
              },
              validator: validateEmail,
              autofocus: false,
              onSaved: (String val) {
                email = val;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            TextFormField(
              validator: validateName,
              textInputAction: TextInputAction.next,
              focusNode: _nameFocus,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _nameFocus, _passwordFocus);
              },
              autofocus: false,
              onSaved: (String val) {
                name = val;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            TextFormField(
              controller: passwordController,
              onFieldSubmitted: (term) {
                _fieldFocusChange(
                    context, _passwordFocus, _validatepasswordFocus);
              },
              focusNode: _passwordFocus,
              textInputAction: TextInputAction.next,
              validator: validatePassword,
              obscureText: checkpassword ? false : true,
              autofocus: false,
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            TextFormField(
              validator: validateValidation,
              focusNode: _validatepasswordFocus,
              textInputAction: TextInputAction.done,
              obscureText: checkpassword ? false : true,
              autofocus: false,
              onSaved: (String val) {
                password = val;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
                labelText: 'Confirm password',
              ),
            ),
            new SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            new Container(
              width: 250,
              height: 50.0,
              alignment: FractionalOffset.center,
              decoration: new BoxDecoration(
                  color: Color(0xFF0062A5),
                  borderRadius:
                      new BorderRadius.all(const Radius.circular(10.0))),
              child: SizedBox.expand(
                child: FlatButton(
                  onPressed: _sendToServer,
                  color: Colors.transparent,
                  child: Text('Register', style: TextStyle(color: Colors.white),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  String validateName(String value) {
    if (value.length == 0) {
      return "Name is Required";
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.length == 0) {
      return "Password is required";
    } else if (value.length < 8) {
      return "Password must be 8 or more digits";
    }
    return null;
  }

  String validateValidation(String value) {
    if (value.length == 0) {
      return "Password validation is required";
    } else if (value != passwordController.text) {
      return "Passwords must match";
    }
    return null;
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
      register(email, name, password);
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future<HttpClientRequest> _preparePostPackage(
      String endpoint, Map data) async {
    HttpClient provider = new HttpClient();
    HttpClientRequest request = await provider.postUrl(Uri.parse(endpoint));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(data)));
    return request;
  }
}
