import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:spobber/pages/tflite/home.dart';

import 'add_object.dart';

class FancyFab extends StatefulWidget {
  final Function() onPressed;
  final String tooltip;
  final IconData icon;
  final Function test;

  FancyFab({this.onPressed, this.tooltip, this.icon, @required this.test});

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Color.fromRGBO(51, 216, 178, 1),
      end: Color(0xFF1b2932),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget add() {
    return Container(
      child: FloatingActionButton(
        heroTag: "newObject",
        onPressed: () {
          // widget.test

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => (PlaceMarkerBody()),
              ));
        },
        tooltip: 'Add',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  List<CameraDescription> cameras;
  Widget image() {
    return Container(
      child: FloatingActionButton(
        heroTag: "image",
        onPressed: () async {
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
        tooltip: 'Image',
        child: Icon(Icons.camera),
      ),
    );
  }



  Widget toggle() {
    return Container(  
      child:FloatingActionButton(        
        heroTag: "toggler",
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
          color: isOpened ? Colors.white : Theme.of(context).primaryColor,
        ),
      ),
       
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: add(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: image(),
        ),
       
        toggle(),
      ],
    );
  }
}
