import 'package:flutter/material.dart';

class SliderBox extends StatelessWidget {
  final Color color;
  final int duration;
  const SliderBox({Key key, this.color, this.duration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.all(10), color: color);
  }
}