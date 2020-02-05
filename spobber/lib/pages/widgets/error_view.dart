import 'package:flutter/material.dart';

int i = 0;
///
///if there is an error in the widget or sub-parents this widget will be shown to the device
// ignore: missing_return
Widget getErrorWidget(FlutterErrorDetails error) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: const Text("Uw Locatie wordt geladen"),
        ),
        Center(child: const CircularProgressIndicator(),)
      ],
    ),
  );
}
