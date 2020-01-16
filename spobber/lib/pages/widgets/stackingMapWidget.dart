import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StackingMapWidget extends StatefulWidget {
  //final MarkerDetail markerinformation;
  final Icon mapIcon;
  final VoidCallback onpressedFunction;
  final EdgeInsets padding;
  final Alignment alignment;

  StackingMapWidget(
      {@required this.onpressedFunction,
      @required this.mapIcon,
      @required this.alignment,
      @required this.padding});

  @override
  _StackingMapWidgetState createState() => _StackingMapWidgetState();
}

// Create a corresponding State class. This class will hold the data related to
// the form.
class _StackingMapWidgetState extends State<StackingMapWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Align(
        alignment: widget.alignment,
        child: MaterialButton(
          minWidth: 20,
          height: 30,
          highlightColor: Theme.of(context).primaryColor,
          color: const Color.fromRGBO(51, 216, 178, 1),
          textColor: Colors.white,
          child: widget.mapIcon,
          onPressed: widget.onpressedFunction,
          splashColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
      ),
    );
  }
}
