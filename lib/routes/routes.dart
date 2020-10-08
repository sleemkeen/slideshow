import 'package:billboard/pages/filePage.dart';
import 'package:flutter/material.dart';
import 'package:billboard/pages/code.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/code': (context) => Code(),
  '/file': (context) => Phoenix(child: FilePage()),
};