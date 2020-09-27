import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:billboard/routes/routes.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:billboard/bloc/codeBloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return BlocProvider(
      blocs: [
        Bloc((a) => CodeBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        initialRoute:"/code",
        routes: routes,
      ),
    );
  }
}
