import 'dart:async';
import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:billboard/models/apiResponse.dart';
import 'package:billboard/models/fileModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:billboard/utils/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileBloc extends BlocBase {
  final fileStream = BehaviorSubject<List<FileModel>>();
  List fileList = <FileModel>[];
  String codeInt;

  //output
  Stream<List<FileModel>> get outputFile =>
      fileStream.stream;

  FileBloc() {
    getAdverts();
  }

  Future initialCodeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    codeInt = await prefs.getString("applicationCodeId");
//    print("code id is $codeInt");
  }

  Future<APIResponse<List<FileModel>>> getAdverts() async {
    await initialCodeId();
    return http.get(AppStrings.baseUrl + AppStrings.fetchFile + codeInt).then((data) {
      print(data.statusCode);
      if (data.statusCode == 200) {
        final responseData = json.decode(data.body);
        var items = responseData['data'];
        fileList.clear();
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

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    fileStream.close();
    super.dispose();
  }
}