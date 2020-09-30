import 'dart:async';
import 'package:better_player/better_player.dart';
import 'package:billboard/bloc/fileBloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:web_browser/web_browser.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _animateSlider(int duration) {
    Future.delayed(Duration(seconds: duration)).then((_) {
      nextPage = _controller.page.round() + 1;
      for(var i = 0; i < _fileBloc.fileList.length; i++) {
        if(i == nextPage) {
          if(_fileBloc.fileList[i].type.toString().toLowerCase() == "video") {
            if(int.parse(_fileBloc.fileList[i].video_duration.toString().split(".").first) < int.parse(_fileBloc.fileList[i].duration)) {
              var videoDuration = int.parse(_fileBloc.fileList[i].video_duration.toString().split(".").first);
              var paidDuration = int.parse(_fileBloc.fileList[i].duration);
              if(videoDuration < paidDuration) {
                durations = videoDuration;
              } else {
                durations = paidDuration;
              }
            }
          } else {
            durations = int.parse(_fileBloc.fileList[i].duration);
          }
        }
      }
      if (nextPage == _fileBloc.fileList.length) {
        nextPage = 0;
        durations = int.parse(_fileBloc.fileList[0].duration);
        _controller.animateToPage(nextPage,
            duration: Duration(milliseconds: 1), curve: Curves.linear)
            .then((_) => _animateSlider(durations));
      } else {
        _controller.animateToPage(nextPage,
            duration: Duration(seconds: 1), curve: Curves.linear)
            .then((_) => _animateSlider(durations));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(color: Colors.red[100], height: double.infinity),
          Container(
              color: Color(0xFF171719),
              child: StreamBuilder(
                stream: _fileBloc.outputFile,
                builder: (context, AsyncSnapshot<List<FileModel>> savedFile) {
                  if (!savedFile.hasData)
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: SpinKitRotatingPlain(
                        color: Colors.white,
                        size: 40.0,
                      ),
                    );
                  final savedItem = savedFile.data;
                  if(_fileBloc.fileList[0].type.toString().toLowerCase() == "video") {
                    if(int.parse(_fileBloc.fileList[0].video_duration.toString().split(".").first) < int.parse(_fileBloc.fileList[0].duration)) {
                      var videoDuration = int.parse(_fileBloc.fileList[0].video_duration.toString().split(".").first);
                      var paidDuration = int.parse(_fileBloc.fileList[0].duration);
                      if(videoDuration < paidDuration) {
                        durations = videoDuration;
                      } else {
                        durations = paidDuration;
                      }
                    }
                  } else {
                    durations = int.parse(_fileBloc.fileList[0].duration);
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) => _animateSlider(durations));
                  return PageView.builder(
                    itemCount: savedItem.length,
                    itemBuilder: (BuildContext context, int index) {
                      if(savedItem[index].type.toLowerCase() == "image") {
                        return Container(
                          child: FadeInImage.memoryNetwork(placeholder: kTransparentImage,
                              image: savedItem[index].url, fit: BoxFit.contain,)
                        );
                      }
                      if(savedItem[index].type.toLowerCase() == "video") {
                        return Container(
                          child: AspectRatio(
                            aspectRatio: 3 / 2,
                            child: BetterPlayerListVideoPlayer(
                              BetterPlayerDataSource(
                                  BetterPlayerDataSourceType.NETWORK, savedItem[index].url),
                              key: Key(savedItem[index].hashCode.toString()),
                              playFraction: 0.8,
                              configuration: BetterPlayerConfiguration(
                                autoPlay: true,
                                aspectRatio: 3 / 2,
                                looping: true,
                                controlsConfiguration: BetterPlayerControlsConfiguration(
                                  showControlsOnInitialize: false,
                                  showControls: false,
                                  enableFullscreen: true,
                                  controlsHideTime: Duration(milliseconds: 2)
                                )
                              ),
                            ),
                          ),
                        );
                      }
                      return Container(
                        child: WebBrowser (
                          initialUrl: savedItem[index].url,
                          javascript: true,
                        ),
                      );
                    },
                    controller: _controller,
                    physics: NeverScrollableScrollPhysics(),
                  );
                }
              )
    ),
          Container(color: Colors.transparent,)
        ],
      ),
    );
  }
}
