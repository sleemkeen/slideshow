import 'dart:async';
import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:billboard/models/apiResponse.dart';
import 'package:billboard/models/fileModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:billboard/utils/strings.dart';

class FileBloc extends BlocBase {
  final fileStream = BehaviorSubject<List<FileModel>>();
  List fileList = <FileModel>[];
  String finalValue = "";
  FileModel getFile;


  static const headers = {
    'Content-Type': 'application/json',
    'Accept' : 'application/json',
  };

  //output
  Stream<List<FileModel>> get outputFile =>
      fileStream.stream;

  FileBloc();

  Future<APIResponse<List<FileModel>>> getTokens() {
    return http.get(AppStrings.baseUrl + AppStrings.fetchFile + "1").then((data) {
      if (data.statusCode == 200) {
        final responseData = json.decode(data.body);
        var items = responseData['data'];
        for(var item in items) {
          fileList.add(FileModel.fromJson(item));
        }
        fileStream.sink.add(fileList);
        return APIResponse<List<FileModel>>(
            error: false, data: fileList);
      } else {
        return APIResponse<List<FileModel>>(
            error: true, errorMessage: AppStrings.errorMessage);
      }
    }).catchError((_) => APIResponse<List<FileModel>>(
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