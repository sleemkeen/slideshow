import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
  bool isShowing = false;
  static const key = 'customCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 4),
      maxNrOfCacheObjects: 100,
      repo: JsonCacheInfoRepository(databaseName: key),
//      fileSystem: IOFileSystem(key),
      fileService: HttpFileService(),
    ),
  );

  @override
  void initState() {
    super.initState();
    getControllerForVideo();
  }


  Future<VideoPlayerController> getControllerForVideo() async {
    var fileInfo = await instance.getSingleFile(widget.url);
    _controller = VideoPlayerController.file(fileInfo)..initialize().then((_) {
      _controller.setVolume(0.0);
      setState(() {
        _controller.play();
        isShowing = true;
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
      child: isShowing ? AnimatedOpacity(
        opacity: isShowing ? 1 : 0,
        duration: Duration(seconds: 1),
        child: Center(
          child: _controller.value.initialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : Container(),
        ),
      ) : Container(color: Color(0xFF171719)),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}