import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:video_player/video_player.dart';

import 'video.controller.dart';
import 'widgets/buffer_loading.dart';
import 'widgets/circular_progressIndicator_big.dart';
import 'widgets/seek_to_view.dart';
import 'widgets/video_bottom_ctroller.dart';

export 'video.controller.dart';
export 'package:video_player/video_player.dart';

class VideoBox extends StatefulObserverWidget {
  VideoBox({
    Key key,
    @required this.controller,
    this.afterChildren = const <Widget>[],
    this.beforeChildren = const <Widget>[],
    this.children = const <Widget>[],
  }) : super(key: key);

  static const double centerIconSize = 40.0;

  final VideoController controller;

  /// video / beforeChildren / controllerWidgets-> children / afterChildren
  final List<Widget> afterChildren;

  /// video / beforeChildren / controllerWidgets-> children / afterChildren
  final List<Widget> beforeChildren;
  final List<Widget> children;

  @override
  _VideoBoxState createState() => _VideoBoxState();
}

class _VideoBoxState extends State<VideoBox> with TickerProviderStateMixin {
  VideoController controller;

  @override
  void initState() {
    super.initState();

    controller = widget.controller
      ..initAnimetedIconController(this)
      ..children ??= widget.children
      ..beforeChildren ??= widget.beforeChildren
      ..afterChildren ??= widget.afterChildren;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(iconTheme: IconThemeData(color: controller.color)),
      child: Container(
        color: controller.background,
        child: GestureDetector(
          onTap: controller.toggleShowVideoCtrl,
          child: Stack(
            children: <Widget>[
              if (!controller.initialized) ...[
                if (controller.cover != null)
                  Center(child: controller.cover),
                controller.customLoadingWidget ??
                    Center(
                      child: CircularProgressIndicatorBig(
                        color: controller.circularProgressIndicatorColor,
                      ),
                    ),
              ] else ...[
                Container(
                  child: controller.isShowCover
                      ? Center(child: controller.cover)
                      : Center(
                          child: AspectRatio(
                            aspectRatio: controller.aspectRatio,
                            child: VideoPlayer(controller.videoCtrl),
                          ),
                        ),
                ),

                if (controller.beforeChildren != null)
                  for (Widget item in controller.beforeChildren) item,

                if (controller.controllerWidgets) ...[
                  Positioned.fill(child: SeekToView(controller: controller)),

                  // mask
                  Positioned.fill(
                    child: AnimatedSwitcher(
                      duration: controller.controllerLayerDuration,
                      child: controller.controllerLayer
                          ? Container(
                              color: Colors.transparent,
                              child: Stack(
                                children: <Widget>[
                                  Positioned.fill(
                                      child:
                                          SeekToView(controller: controller)),
                                  controller.isBfLoading
                                      ? SizedBox()
                                      : GestureDetector(
                                        onTap: () {
                                          controller.togglePlay();
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          ),
                                      ),
                                  controller.bottomViewBuilder != null
                                      ? controller.bottomViewBuilder(
                                          context, controller)
                                      : VideoBottomView(
                                          controller: controller),
                                  if (controller.children != null)
                                    for (Widget item in controller.children)
                                      item,
                                ],
                              ),
                            )
                          : SizedBox(),
                    ),
                  ),

                  // buffer loading
                  BufferLoading(controller: controller),
                ],
                if (controller.afterChildren != null)
                  for (Widget item in controller.afterChildren) item,
              ]
            ],
          ),
        ),
      ),
    );
  }
}

abstract class CustomFullScreen {
  const CustomFullScreen();
  /// [VideoController.customFullScreen]example
  ///
  /// You need to return an asynchronous event (usually an asynchronous event waiting for the page to end)
  /// please refer to the example of [VideoController.customFullScreen]
  Future<Object> open(BuildContext context, VideoController controller);
  FutureOr<void> close(BuildContext context, VideoController controller);
}

class KCustomFullScreen extends CustomFullScreen {
  const KCustomFullScreen();
  /// Set to landscape mode
  void _setLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }
  ///
  /// Set to normal mode
  void _setPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void close(BuildContext context, VideoController controller) {
    Navigator.of(context).pop();
  }

  Route<T> _route<T>(VideoController controller) {
    return MaterialPageRoute<T>(
      builder: (_) => KVideoBoxFullScreenPage(controller: controller),
    );
  }

  @override
  Future<Object> open(BuildContext context, VideoController controller) async {
    SystemChrome.setEnabledSystemUIOverlays([]);
    _setLandscape();
    await Navigator.of(context).push(_route(controller));
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _setPortrait();
    return null;
  }
}

class KVideoBoxFullScreenPage extends StatelessWidget {
  final controller;

  const KVideoBoxFullScreenPage({Key key, @required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: VideoBox(controller: controller),
      ),
    );
  }
}
