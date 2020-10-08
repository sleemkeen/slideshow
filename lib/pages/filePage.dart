import 'dart:async';
import 'package:billboard/bloc/fileBloc.dart';
import 'package:billboard/components/videComponent.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
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
  static PageController _controller;
  static Key _key(int index) => Key(index.toString());
  int current = 0;
  bool isOnPageTurning = false;
  int nextPage = 0;
  int durations;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    super.dispose();
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
        _fileBloc.getAdverts().whenComplete(() {
          Phoenix.rebirth(context);
        });
      } else {
        _controller.jumpToPage(nextPage);
        _animateSlider(durations);
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
                        color: Colors.transparent,
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
                        return VideoKeepAlive(
                          url: savedItem[index].url,
                          key: _key(index),
                        );
                      }
                      return Container(
                        color: Color(0xFF171719),
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
