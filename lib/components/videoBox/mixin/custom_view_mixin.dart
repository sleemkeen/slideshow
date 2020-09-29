import 'package:flutter/material.dart';

import '../video.controller.dart';
import '../video_box.dart';

typedef BottomViewBuilder = Widget Function(
  BuildContext context,
  VideoController controller,
);

mixin CustomViewMixin {
  List<Widget> children;
  List<Widget> beforeChildren;
  List<Widget> afterChildren;


  Widget customLoadingWidget;

  /// [customLoadingWidget]
  /// This widget will be displayed when the video enters the buffer.
  /// Set like [customLoadingWidget]
  Widget customBufferedWidget;

  CustomFullScreen customFullScreen;


  BottomViewBuilder bottomViewBuilder;

  Color background;

  /// icons
  Color color;
  
  Color bufferColor;
  Color inactiveColor;
  Color circularProgressIndicatorColor;

  /// padding
  ///
  /// Padding of bottom controller
  EdgeInsets bottomPadding;
}
