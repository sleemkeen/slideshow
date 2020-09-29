import 'dart:async';
import 'package:better_player/better_player.dart';
import 'package:billboard/bloc/fileBloc.dart';
import 'package:billboard/components/videoBox/video.controller.dart';
import 'package:billboard/components/videoBox/video_box.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';

import '../models/fileModel.dart';

class FilePage extends StatefulWidget {
  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  final FileBloc _fileBloc = BlocProvider.getBloc<FileBloc>();
  final PageController _controller = PageController();
  int nextPage = 0;
  int durations;
  Timer _timer;
  bool checkTimer = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
    _controller.dispose();
  }

  void _animateSlider(int duration) {
    Future.delayed(Duration(seconds: durations)).then((_) {
      nextPage = _controller.page.round() + 1;
      for(var i = 0; i < _fileBloc.fileList.length; i++) {
        if(i == nextPage) {
          durations = int.parse(_fileBloc.fileList[i].duration);
        }
      }
      print(durations);
      if (nextPage == _fileBloc.fileList.length) {
        nextPage = 0;
        durations = int.parse(_fileBloc.fileList[0].duration);
      }
      _controller.animateToPage(nextPage,
              duration: Duration(seconds: 1), curve: Curves.linear)
          .then((_) => _animateSlider(durations));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(color: Colors.red[100], height: double.infinity),
          Container(
              color: Colors.white,
              child: StreamBuilder(
                stream: _fileBloc.outputFile,
                builder: (context, AsyncSnapshot<List<FileModel>> savedFile) {
                  if (!savedFile.hasData)
                    return Container();
                  final savedItem = savedFile.data;
                  durations = int.parse(savedItem[0].duration);
                  WidgetsBinding.instance.addPostFrameCallback((_) => _animateSlider(durations));
                  return PageView.builder(
                    itemCount: savedItem.length,
                    itemBuilder: (BuildContext context, int index) {
                      if(savedItem[index].type.toLowerCase() == "image") {
                        return Container(
                          color: Color(0xFF171719),
                          child: FadeInImage.memoryNetwork(placeholder: kTransparentImage,
                              image: savedItem[index].url, fit: BoxFit.contain,)
                        );
                      }
                      if(savedItem[index].type.toLowerCase() == "video") {
                        print("index $index");
//                        print(savedItem[index].url);
//                        var existingItem = vcs.firstWhere((itemToCheck) => itemToCheck.value == savedItem[index].url, orElse: () => null);
//                        vcs.insert(0, VideoController(source: VideoPlayerController.network(savedItem[index].url.toString()))
//                          ..initialize());
//                        print("vid ${vcs[0].value}");
//                        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//                          if(timer.tick == 2) {
//                            _timer.cancel();
//                            setState(() {
//                              checkTimer = true;
//                            });
//                          }
//                        });
                        return AspectRatio(
                          aspectRatio: 16 / 9,
                          child: BetterPlayerListVideoPlayer(
                            BetterPlayerDataSource(
                                BetterPlayerDataSourceType.NETWORK, savedItem[index].url),
                            key: Key(savedItem.hashCode.toString()),
                          ),
                        );

                      }
                      return Container(
                        color: Colors.orange,
                        child: Center(
                          child: Text(savedItem[index].id.toString()),
                        ),
                      );
                    },
                    controller: _controller,
                    reverse: false,
                    physics: NeverScrollableScrollPhysics(),
                  );
                }
              )
    ),
        ],
      ),
    );
  }
}
