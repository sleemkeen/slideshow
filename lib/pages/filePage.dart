import 'package:billboard/bloc/codeBloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilePage extends StatefulWidget {
  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  final CodeBloc _codeBloc =
  BlocProvider.getBloc<CodeBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialCodeId();
  }

  Future initialCodeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("shared ${await prefs.getString("applicationCodeId")}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
      ),
    );
  }
}
