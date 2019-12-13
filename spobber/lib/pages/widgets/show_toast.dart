import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
 
void showToast(String msg, context, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }