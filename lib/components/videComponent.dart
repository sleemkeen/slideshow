import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoKeepAlive extends StatefulWidget {
  final Key key;
  final String url;
  VideoKeepAlive({this.key, this.url});

  @override
  _VideoKeepAlive createState() => _VideoKeepAlive();
}

class _VideoKeepAlive extends State<VideoKeepAlive> with AutomaticKeepAliveClientMixin {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    print('building '+widget.key.toString());
    _controller = VideoPlayerController.network(
        widget.url)
      ..initialize().then((_) {
        _controller.setVolume(0.0);
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
        });
      });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    print('initiating '+widget.key.toString());
    return Material(
      color: Color(0xFF171719),
      child: Center(
        child: _controller.value.initialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : Container(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}