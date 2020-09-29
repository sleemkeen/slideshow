import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../video.controller.dart';
import '../video_box.dart';
import 'animated_arrow_icon.dart';

class SeekToView extends StatelessWidget {
  final VideoController controller;

  const SeekToView({Key key, @required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: controller.toggleShowVideoCtrl,
            onDoubleTap: controller.rewind,
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: controller.arrowIconRtLController != null
                    ? Transform.rotate(
                        angle: math.pi / 180 * 180,
                        child: AnimatedArrowIcon(
                          iconSize: VideoBox.centerIconSize,
                          controller: controller.arrowIconRtLController,
                          color: controller.color,
                        ),
                      )
                    : SizedBox(),
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),

        Expanded(
          child: GestureDetector(
            onTap: controller.toggleShowVideoCtrl,
            onDoubleTap: controller.fastForward,
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: controller.arrowIconLtRController != null
                    ? AnimatedArrowIcon(
                        iconSize: VideoBox.centerIconSize,
                        controller: controller.arrowIconLtRController,
                        color: controller.color,
                      )
                    : SizedBox(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
