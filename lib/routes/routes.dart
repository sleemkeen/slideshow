import 'package:flutter/material.dart';
import 'package:billboard/pages/code.dart';
import 'package:billboard/pages/file.dart';


Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{

  '/code': (context) => Code(),
  '/file': (context) => file(),

};