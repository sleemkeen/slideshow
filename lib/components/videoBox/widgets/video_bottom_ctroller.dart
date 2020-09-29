import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../video.controller.dart';

class VideoBottomView extends StatefulObserverWidget {
  final VideoController controller;

  const VideoBottomView({Key key, @required this.controller}) : super(key: key);

  @override
  _VideoBottomViewState createState() => _VideoBottomViewState();
}

class _VideoBottomViewState extends State<VideoBottomView> {

  void _onTap(){}
  @override
  Widget build(BuildContext context) {
    var _top = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          child: Text(
            widget.controller.durationText,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );

    var _bottom = Row(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          color: Colors.black,
          padding:
          EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          child: Text(
              widget.controller.positionText,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Spacer(),
        IconButton(
          icon: Icon(
            widget.controller.volume <= 0
                ? Icons.volume_off
                : widget.controller.volume <= 0.5
                ? Icons.volume_down
                : Icons.volume_up,
          ),
          onPressed: widget.controller.setOnSoundOrOff,
        ),
      ],
    );

    return GestureDetector(
      onTap: _onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _top,
          _bottom,
        ],
      ),
    );
  }
}
