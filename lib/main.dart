import 'package:billboard/bloc/fileBloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:billboard/routes/routes.dart';
import 'package:billboard/bloc/codeBloc.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

int initScreen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  await prefs.getString("applicationCodeId");
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return BlocProvider(
      blocs: [
        Bloc((a) => CodeBloc()),
        Bloc((b) => FileBloc()),
      ],
      child: MaterialApp(
        title: 'Billboard app',
        debugShowCheckedModeBanner: false,
        initialRoute: initScreen == 0 || initScreen == null
            ? "/code"
            : "/file",
        routes: routes,
      ),
    );
  }
}
