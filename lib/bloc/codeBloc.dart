import 'dart:async';
import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:billboard/models/apiResponse.dart';
import 'package:billboard/models/codeModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:billboard/utils/strings.dart';

class CodeBloc extends BlocBase {
  final codeStream = BehaviorSubject<List<CodeModel>>();
  List codeList = <CodeModel>[];
  String finalValue = "";

  //output
  Stream<List<CodeModel>> get outputCode =>
      codeStream.stream;

  CodeBloc();

  Future<APIResponse<List<CodeModel>>> getTokens() {
    return http.get(AppStrings.baseUrl + AppStrings.fetchCode).then((data) {
      if (data.statusCode == 200) {
        final responseData = json.decode(data.body);
        var items = responseData['data'];
        for(var item in items) {
          codeList.add(CodeModel.fromJson(item));
        }
        codeStream.sink.add(codeList);
        return APIResponse<List<CodeModel>>(
            error: false, data: codeList);
      } else {
        return APIResponse<List<CodeModel>>(
            error: true, errorMessage: AppStrings.errorMessage);
      }
    }).catchError((_) => APIResponse<List<CodeModel>>(
        error: true, errorMessage: AppStrings.errorMessage));
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    codeStream.close();
    super.dispose();
  }
}