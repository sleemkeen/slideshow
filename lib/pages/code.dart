import 'package:billboard/bloc/codeBloc.dart';
import 'package:billboard/models/codeModel.dart';
import 'package:billboard/models/tagModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Code extends StatefulWidget {
  @override
  _CodeState createState() => _CodeState();
}

class _CodeState extends State<Code> {
  final _formKey = GlobalKey<FormState>();
  final CodeBloc _codeBloc = BlocProvider.getBloc<CodeBloc>();
  var currentSelectedType;
  var currentSelectedTag;
  var currentSelectedValue;
  List<String> adType = ["Fetch by codes", "Fetch by tags"];
  bool showTagType = false;
  bool showCodeType = false;
  bool showType = false;
  bool checkValue = false;


  @override
  void initState() {
    super.initState();
    initialBool();
    _codeBloc.getTokens();
    _codeBloc.getTags();
  }

  initialBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("applicationCodeBool", false);
  }

  initialCodeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("applicationCodeBool", true);
    await prefs.setString("applicationCodeId", _codeBloc.finalValue);
    await prefs.setInt("initScreen", 1);
  }

  initialTagId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("applicationTagId", _codeBloc.tagValue);
    await prefs.setInt("initScreen", 1);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Color(0xFF171719),
            child: Container(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20),
                    height: 80,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black, Colors.transparent]
                        )
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 40.0),
                        Text(
                          'Billboard selection type',
                          style: TextStyle(
                              color: Colors.white, fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      alignment: Alignment(0, -0.8),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      color: Color(0xFF171719),
                      child: ListView(
                        children: [
                          Theme(
                            data: new ThemeData(
                              primaryColor: Colors.green,
                              primaryColorDark: Colors.green,
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.green.withOpacity(0.7), style: BorderStyle.solid, width: 1.80),
                                ),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  hint: Text("Fetch billboards by criteria", style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w600),),
                                  value: currentSelectedType,
                                  style: TextStyle(color: Colors.white),
                                  dropdownColor: Colors.black,
                                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.green,),
                                  items: adType.map((String value) {
                                    return new DropdownMenuItem<String>(
                                      value: value,
                                      child: new Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      checkValue = false;
                                    });
                                    if(value == "Fetch by codes") {
                                      setState(() {
                                        showType = true;
                                        showCodeType = true;
                                        showTagType = false;
                                      });
                                    } else if(value == "Fetch by tags") {
                                      setState(() {
                                        showType = true;
                                        showCodeType = false;
                                        showTagType = true;
                                      });
                                    }
                                    setState(() {
                                      currentSelectedType = value;
                                    });
                                  },
                                ),
                              )
                            )
                          ),
                          SizedBox(height: 50),
                          showType ? Text(showCodeType ? "Codes" : "Tags", style: TextStyle(color: Colors.white),) : Container(),
                          SizedBox(height: 10,),
                          showCodeType ? Container(
                            width: MediaQuery.of(context).size.width,
                            child: StreamBuilder(
                              stream: _codeBloc.outputCode,
                              builder: (context, AsyncSnapshot<List<CodeModel>> savedCode) {
                                if (!savedCode.hasData)
                                  return Container(
                                    color: Color(0xFF171719),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
                                    child: SpinKitRotatingPlain(
                                      color: Colors.white,
                                      size: 40.0,
                                    ),
                                  );
                                final savedItem = savedCode.data;
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.green.withOpacity(0.6), style: BorderStyle.solid, width: 1.80),
                                  ),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    underline: SizedBox(),
                                    hint: Text("Select your code", style: TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.w600),),
                                    value: currentSelectedValue,
                                    style: TextStyle(color: Colors.white),
                                    dropdownColor: Colors.black,
                                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.green.withOpacity(0.5), size: 18,),
                                    items: savedItem.map((CodeModel value) {
                                      return new DropdownMenuItem<String>(
                                        value: value.id.toString(),
                                        child: new Text(value.codes),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      _codeBloc.finalValue = value;
                                      setState(() {
                                        checkValue = true;
                                        currentSelectedValue = value;
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ) : Container(),
                          showTagType ? Theme(
                              data: new ThemeData(
                                primaryColor: Colors.green,
                                primaryColorDark: Colors.green,
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: StreamBuilder(
                                  stream: _codeBloc.outputTag,
                                  builder: (context, AsyncSnapshot<List<TagModel>> savedTag) {
                                    if (!savedTag.hasData)
                                      return Container(
                                        color: Color(0xFF171719),
                                        width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height,
                                        child: SpinKitRotatingPlain(
                                          color: Colors.white,
                                          size: 40.0,
                                        ),
                                      );
                                    final savedItem = savedTag.data;
                                    return Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.green.withOpacity(0.6), style: BorderStyle.solid, width: 1.80),
                                      ),
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        underline: SizedBox(),
                                        hint: Text("Select your Tag", style: TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.w600),),
                                        value: currentSelectedTag,
                                        style: TextStyle(color: Colors.white),
                                        dropdownColor: Colors.black,
                                        icon: Icon(Icons.keyboard_arrow_down, color: Colors.green.withOpacity(0.5), size: 18,),
                                        items: savedItem.map((TagModel value) {
                                          return new DropdownMenuItem<String>(
                                            value: value.tag,
                                            child: new Text(value.tag),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          _codeBloc.tagValue = value;
                                          setState(() {
                                            checkValue = true;
                                            currentSelectedTag = value;
                                          });
                                        },
                                      ),
                                    );
                                  },
                                ),
                              )
                          ) : Container(),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: IntrinsicHeight(
                      child: Container(
                        height: 65,
                        child: RaisedButton(
                          color: Colors.green,
                          onPressed: checkValue ? () async {
                            if(showCodeType) {
                              if(_codeBloc.finalValue == "") {
                                print("Empty code");
                              } else {

                                await initialCodeId();
                                Navigator.pushNamed(context, '/file');
                              }
                            } else if(showTagType) {
                              if(_codeBloc.tagValue == "") {
                                print("Empty tag");
                              } else {
                                print("Tag ${_codeBloc.tagValue}");
                                await initialTagId();
                                Navigator.pushNamed(context, '/file');
                              }
                            }
                          } : null,
                          child: Text('Continue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

