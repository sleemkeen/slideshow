import 'dart:async';
import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:billboard/models/apiResponse.dart';
import 'package:billboard/models/codeModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:billboard/utils/strings.dart';

class CodeBloc extends BlocBase {
  final codeStream = BehaviorSubject<CodeModel>();
  CodeModel getCode;
  static const headers = {
    'Content-Type': 'application/json',
    'Accept' : 'application/json',
  };

  //output
  Stream<CodeModel> get outputToken =>
      codeStream.stream;

  //input
  Sink<CodeModel> get inputToken => codeStream.sink;

  CodeBloc();

  Future<APIResponse<CodeModel>> getTokens() {
    return http.get(AppStrings.baseUrl + AppStrings.fetchCode).then((data) {
      if (data.statusCode == 200) {
        final responseData = json.decode(data.body);
        getCode = CodeModel.fromJson(responseData);
        print(getCode);
        codeStream.add(getCode);
        return APIResponse<CodeModel>(
            error: false, data: getCode);
      } else {
        return APIResponse<CodeModel>(
            error: true, errorMessage: AppStrings.errorMessage);
      }
    }).catchError((_) => APIResponse<String>(
        error: true, errorMessage: AppStrings.errorMessage));
  }

  sendToken() async {

  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    codeStream.close();
    super.dispose();
  }
}