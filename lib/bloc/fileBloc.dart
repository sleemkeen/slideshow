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
  String tagInt;
  String maxCountJson = "";
  //output
  Stream<List<FileModel>> get outputFile =>
      fileStream.stream;

  FileBloc() {
    print("Got here");
    initialCycleCount();
    initialCodeId();
  }

  Future initialCycleCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("applicationCycleCount", 1);
  }

  Future initialCodeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var commonBool = await prefs.getBool("applicationCodeBool");
    codeInt = await prefs.getString("applicationCodeId");
    tagInt = await prefs.getString("applicationTagId");
    if(commonBool == true) {
      print("true");
      await prefs.setString("commonValue", "codes");
      getAdByCode(1);
    } else {
      print("false");
      await prefs.setString("commonValue", "tag");
      getAdByTag(1);
    }
  }

  Future initiateCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tagInt = await prefs.getString("applicationTagId");
    var commonCount = await prefs.getInt("applicationCycleCount");
    var commonValue = await prefs.getString("commonValue");
    if(commonValue == "codes") {
      getAdByCode(commonCount);
    } else {
      getAdByTag(commonCount);
    }
  }

  Future<APIResponse<List<FileModel>>> getAdByCode(int cycleNumber) async {
    return http.get(AppStrings.baseUrl + AppStrings.fetchByCode + codeInt + '/' + cycleNumber.toString()).then((data) {
      print(data.statusCode);
      if (data.statusCode == 200) {
        final responseData = json.decode(data.body);
        List items = responseData['data'];
        print("item is $items");
        if(items.isEmpty) {
          maxCountJson = "0";
        } else {
          maxCountJson = responseData['max_count'];
        }
        print("Max count is $maxCountJson");
        fileList.clear();
        for(var item in items) {
          fileList.add(FileModel.fromJson(item));
        }
        print("Code data : $fileList");
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

  Future<APIResponse<List<FileModel>>> getAdByTag(int cycleNumber) async {
    return http.get(AppStrings.baseUrl + AppStrings.fetchByTag + tagInt + '/' + cycleNumber.toString()).then((data) {
      print(data.statusCode);
      if (data.statusCode == 200) {
        final responseData = json.decode(data.body);
        List items = responseData['data'];
        if(items.isEmpty) {
          maxCountJson = "0";
        } else {
          maxCountJson = responseData['max_count'];
        }
        print("items data is $items");
        print("Max count is $maxCountJson");
        fileList.clear();
        for(var item in items) {
          fileList.add(FileModel.fromJson(item));
        }
        print("Tag data : $fileList");
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