import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

  class BottomSheetSwitch2 extends StatefulWidget {
  BottomSheetSwitch2({@required this.switchValue, @required this.valueChanged});

  final bool switchValue;
  final ValueChanged valueChanged;

  @override
  _BottomSheetSwitch2 createState() => _BottomSheetSwitch2();
}

class _BottomSheetSwitch2 extends State<BottomSheetSwitch2> {
  bool _switchValue;

  @override
  void initState() {
    _switchValue = widget.switchValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: 
       CupertinoSwitch(
          value: _switchValue,
          onChanged: (bool value) {
            setState(() {
              _switchValue = value;
              widget.valueChanged(value);
            });
          }),
    );
  }
}