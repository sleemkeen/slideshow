import 'package:billboard/pages/filePage.dart';
import 'package:flutter/material.dart';
import 'package:billboard/pages/code.dart';

Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/code': (context) => Code(),
  '/file': (context) => FilePage(),
};