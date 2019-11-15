import 'package:dynamic_widget/dynamic_widget/utils.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'icons_helper.dart';

class CardParser extends WidgetParser {
  @override
  bool forWidget(String widgetName) {
    return "Card" == widgetName;
  }

  @override
  Widget parse(Map<String, dynamic> map, ClickListener listener) {
    Widget child = DynamicWidgetBuilder.buildFromMap(map['child'], listener);
    Card card = new Card(child: child);
    return card;
  }
}