import 'package:dynamic_widget/dynamic_widget/utils.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'icons_helper.dart';

class IconParser extends WidgetParser {
  @override
  bool forWidget(String widgetName) {
    return "Icon" == widgetName;
  }

  @override
  Widget parse(Map<String, dynamic> map, ClickListener listener) {
    Icon icon = Icon(
      getMaterialIcon(name: map['icon'].toString()),
      color: map.containsKey('color') ? parseHexColor(map['color']) : null,
      semanticLabel: map.containsKey('semanticLabel') ? map['semanticLabel'] : "",
      size: map.containsKey('size') ? double.parse(map['size']) : 1.0,
      textDirection: map.containsKey('textDirection') ? parseTextDirection(map['textDirection']) : parseTextDirection("ltr"),
    );
    return icon;
  }
}