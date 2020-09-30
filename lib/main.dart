import 'package:billboard/bloc/fileBloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:billboard/routes/routes.dart';
import 'package:billboard/bloc/codeBloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc((a) => CodeBloc()),
        Bloc((b) => FileBloc()),
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
