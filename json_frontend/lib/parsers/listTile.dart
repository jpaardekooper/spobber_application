import 'package:dynamic_widget/dynamic_widget/utils.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'icons_helper.dart';

class ListTileParser extends WidgetParser {
  @override
  bool forWidget(String widgetName) {
    return "ListTile" == widgetName;
  }

  @override
  Widget parse(Map<String, dynamic> map, ClickListener listener) {
    Widget leading = DynamicWidgetBuilder.buildFromMap(map['leading'], listener);
    Widget title = DynamicWidgetBuilder.buildFromMap(map['title'], listener);
    Widget subtitle = DynamicWidgetBuilder.buildFromMap(map['subtitle'], listener);
    ListTile tile = new ListTile(leading: leading, title: title, subtitle: subtitle);
    return tile;
  }
}