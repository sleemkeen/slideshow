import 'dart:async';
import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:billboard/models/apiResponse.dart';
import 'package:billboard/models/fileModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:billboard/utils/strings.dart';

class FileBloc extends BlocBase {
  final fileStream = BehaviorSubject<FileModel>();
  FileModel getCode;
  static const headers = {
    'Content-Type': 'application/json',
    'Accept' : 'application/json',
  };

  //output
  Stream<FileModel> get outputToken =>
      fileStream.stream;

  //input
  Sink<FileModel> get inputToken => fileStream.sink;

  FileBloc();

  Future<APIResponse<FileModel>> getTokens() {
    return http.get(AppStrings.baseUrl + AppStrings.fetchCode).then((data) {
      if (data.statusCode == 200) {
        final responseData = json.decode(data.body);
        getCode = FileModel.fromJson(responseData);
        print(getCode);
        fileStream.add(getCode);
        return APIResponse<FileModel>(
            error: false, data: getCode);
      } else {
        return APIResponse<FileModel>(
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
    fileStream.close();
    super.dispose();
  }
}