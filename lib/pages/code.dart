import 'package:billboard/bloc/codeBloc.dart';
import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class Code extends StatefulWidget {
  @override
  _CodeState createState() => _CodeState();
}

class _CodeState extends State<Code> {
  final _formKey = GlobalKey<FormState>();
  final CodeBloc countriesBloc =
  BlocProvider.getBloc<CodeBloc>();


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
                          'Select your codes',
                          style: TextStyle(
                              color: Colors.white, fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment(0, -0.8),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      color: Color(0xFF171719),
                      child: Theme(
                        data: new ThemeData(
                          primaryColor: Colors.green,
                          primaryColorDark: Colors.green,
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.green, style: BorderStyle.solid, width: 1.80),
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            underline: SizedBox(),
                            hint:  Text("Select your code", style: TextStyle(fontSize: 17.0, color: Colors.white),),
                            items: <String>['A', 'B', 'C', 'D'].map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            onChanged: (_) {},
                          ),
                        )
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: IntrinsicHeight(
                      child: Container(
                        height: 65,
                        child: RaisedButton(
                          color: Colors.green,
                          onPressed: () {
                            // Validate returns true if the form is valid, otherwise false.
                            if (_formKey.currentState.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              Scaffold
                                  .of(context)
                                  .showSnackBar(SnackBar(content: Text('Processing Data')));
                            }
                          },
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

