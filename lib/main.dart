import 'package:billboard/bloc/fileBloc.dart';
import 'package:billboard/components/phoenixCode.dart';
import 'package:billboard/services/rebirthComponent.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:billboard/routes/routes.dart';
import 'package:billboard/bloc/codeBloc.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

int initScreen;
String initType;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initType = await prefs.getString("commonValue");
  if(initType == null || initType == "") {
    await prefs.setInt("initScreen", 0);
  } else {
    await prefs.setInt("initScreen", 1);
  }
  initScreen = await prefs.getInt("initScreen");
  await prefs.getString("applicationCodeId");
  runApp(PhoenixCode(child: MyApp()));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return PhoenixReborn(
      child: BlocProvider(
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
      ),
    );
  }
}
