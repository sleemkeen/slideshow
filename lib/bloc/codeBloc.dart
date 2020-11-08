import 'dart:async';
import 'dart:convert';
import 'package:billboard/models/tagModel.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:billboard/models/apiResponse.dart';
import 'package:billboard/models/codeModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:billboard/utils/strings.dart';

class CodeBloc extends BlocBase {
  final codeStream = BehaviorSubject<List<CodeModel>>();
  final tagStream = BehaviorSubject<List<TagModel>>();
  List codeList = <CodeModel>[];
  List tagsList = <TagModel>[];
  String finalValue = "";
  String tagValue = "";

  //output
  Stream<List<CodeModel>> get outputCode =>
      codeStream.stream;
  Stream<List<TagModel>> get outputTag =>
      tagStream.stream;

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

  Future<APIResponse<List<TagModel>>> getTags() {
    return http.get(AppStrings.baseUrl + AppStrings.fetchTag).then((data) {
      if (data.statusCode == 200) {
        final responseData = json.decode(data.body);
        var items = responseData['data'];
        for(var item in items) {
          tagsList.add(TagModel.fromJson(item));
        }
        tagStream.sink.add(tagsList);
        return APIResponse<List<TagModel>>(error: false, data: tagsList);
      } else {
        return APIResponse<List<TagModel>>(error: true, errorMessage: AppStrings.errorMessage);
      }
    }).catchError((_) => APIResponse<List<TagModel>>(
        error: true, errorMessage: AppStrings.errorMessage));
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    codeStream.close();
    tagStream.close();
    super.dispose();
  }
}