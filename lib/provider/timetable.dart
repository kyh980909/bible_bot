import 'dart:convert';
import 'package:bible_bot/api/api.dart';
import 'package:bible_bot/models/select.dart';
import 'package:bible_bot/models/timetable.dart';
import 'package:bible_bot/util/class_process.dart';
import 'package:bible_bot/util/storage.dart';
import 'package:flutter/material.dart';

class TimetableProvider with ChangeNotifier {
  List<dynamic> _data = List<dynamic>();
  bool _isFetching = false;
  String _themeData;

  TimetableProvider(themeData) {
    _themeData = themeData;
    getTimetable();
  }

  void setSemester(String semester) {
    getTimetable(semester: semester);
    notifyListeners();
  }

  Future<void> getTimetable({String semester}) async {
    _data.clear();
    _isFetching = true;
    semester = await Storage.getTimetableSelected();
    var timetableInfo = await Api()
        .getTimetable(semester: semester)
        .timeout(Duration(seconds: 5));
    _data.add(timetableInfo['result']);

    if (timetableInfo['result']) {
      Timetable timetable =
          Timetable.fromJson(json.decode(timetableInfo['data'])['data']);
      Select select =
          Select.fromJson(json.decode(timetableInfo['data'])['meta']);

      _data.add(ClassProcess(_themeData, timetable).getTimetable());
      _data.add(select);
    } else {
      Map<String, dynamic> error = json.decode(timetableInfo['err'])['error'];
      _data.add(timetableInfo['err']);
      _data.add(error['title']);
      _data.add('인트라넷에서 강의평가를 해주세요.');
    }
    _isFetching = false;
    notifyListeners();
  }

  List<dynamic> getTimetableData() {
    if (_data.isNotEmpty)
      return _data;
    else
      return null;
  }

  bool get isFetching => _isFetching;
}
