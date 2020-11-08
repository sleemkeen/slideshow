import 'dart:async';
import 'package:billboard/bloc/fileBloc.dart';
import 'package:billboard/components/phoenixCode.dart';
import 'package:billboard/components/videComponent.dart';
import 'package:billboard/services/rebirthComponent.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_browser/web_browser.dart';
import '../models/fileModel.dart';

class FilePage extends StatefulWidget {
  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  final FileBloc _fileBloc = BlocProvider.getBloc<FileBloc>();
  static PageController _controller;
  int fetchInitial;
  static Key _key(int index) => Key(index.toString());
  bool downloading = false;
  var progressString = "";
  int current = 0;
  bool isOnPageTurning = false;
  int nextPage = 0;
  int durations;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Exit Billboard'),
        content: new Text("This will reset Billboard select type"),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: new GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: Text("NO"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: new GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setInt("initScreen", 0).whenComplete(() async {
                  await prefs.setString("commonValue", "");
                  SystemNavigator.pop();
                });
              },
              child: Text("YES"),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  Future initiatePrevious() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var commonValue = await prefs.getString("commonValue");
    if(commonValue == "codes") {
      await _fileBloc.getAdByCode(1);
    } else {
      await _fileBloc.getAdByTag(1);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _animateSlider(int duration) {
    Future.delayed(Duration(seconds: duration)).then((_) async {
      nextPage = _controller.page.round() + 1;
      for(var i = 0; i < _fileBloc.fileList.length; i++) {
        if(i == nextPage) {
          durations = int.parse(_fileBloc.fileList[i].duration);
        }
      }
      if (nextPage == _fileBloc.fileList.length) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var initialCount = await prefs.getInt("applicationCycleCount");
        var newCounts = initialCount;
//        var newCounts = initialCount == null || initialCount == 0 ? 1 : initialCount;
        if(newCounts != int.parse(_fileBloc.maxCountJson)) {
          newCounts = newCounts + 1;
          await prefs.setInt("applicationCycleCount", newCounts);
          var commonCount = await prefs.getInt("applicationCycleCount");
          var commonValue = await prefs.getString("commonValue");
          if(commonValue == "codes") {
            _fileBloc.getAdByCode(commonCount).whenComplete(() {
              Phoenix.rebirth(context);
            });
          } else {
            _fileBloc.getAdByTag(commonCount).whenComplete(() {
              Phoenix.rebirth(context);
            });
          }
        } else {
          await prefs.setInt("applicationCycleCount", 1);
          var commonValue = await prefs.getString("commonValue");
          if(commonValue == "codes") {
            _fileBloc.getAdByCode(1).whenComplete(() {
              Phoenix.rebirth(context);
            });
          } else {
            _fileBloc.getAdByTag(1).whenComplete(() {
              Phoenix.rebirth(context);
            });
          }
        }
      } else {
        _controller.jumpToPage(nextPage);
        _animateSlider(durations);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
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
                    if(savedItem.length == 0) {
                      if(int.parse(_fileBloc.maxCountJson) == 0) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("There's no advert available for this Billboard",
                                  textScaleFactor: 0.81,
                                  style: TextStyle(color: Colors.white),),
                                SizedBox(height: 25),
                                Container(
                                  height: 40,
                                  child: RaisedButton(
                                    onPressed: () async {
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      await prefs.setInt("initScreen", 0).whenComplete(() async {
                                        await prefs.setString("commonValue", "");
                                        PhoenixCode.rebirth(context);
                                      });
                                    },
                                    color: Colors.green,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25)
                                    ),
                                    child: Text("Go back",
                                      textScaleFactor: 0.81,
                                      style: TextStyle(color: Colors.white, fontSize: 13),),
                                  ),
                                )
                              ],
                            )
                        );
                      } else {
                        initiatePrevious();
                        return Container();
                      }
                    }
                    durations = int.parse(_fileBloc.fileList[0].duration);
                    _animateSlider(durations);
                    return PageView.builder(
                      itemCount: savedItem.length,
                      itemBuilder: (BuildContext context, int index) {
                        if(savedItem[index].type.toLowerCase() == "image") {
                          return CachedNetworkImage(
                            imageUrl: savedItem[index].url,
                            placeholder: (context, url) => Container(),
                            fadeInDuration: Duration(milliseconds: 500),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.transparent,),
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
          ],
        ),
      ),
    );
  }
}
