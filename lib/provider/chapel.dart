import 'dart:convert';
import 'package:bible_bot/api/api.dart';
import 'package:bible_bot/models/chapel.dart';
import 'package:bible_bot/models/select.dart';
import 'package:bible_bot/util/storage.dart';
import 'package:flutter/material.dart';

class ChapelProvider with ChangeNotifier {
  Map<String, dynamic> _data = Map<String, dynamic>();
  bool _isFetching = false;

  ChapelProvider() {
    getChapel();
  }

  void setSemester(String semester) {
    getChapel(semester: semester);
    notifyListeners();
  }

  Future<void> getChapel({String semester}) async {
    _data.clear();
    _isFetching = true;
    semester = await Storage.getChapelSelected();
    var chapelInfo =
        await Api().getChapel(semester: semester).timeout(Duration(seconds: 5));
    _data['result'] = chapelInfo['result'];

    if (chapelInfo['result']) {
      Chapel chapel = Chapel.fromJson(json.decode(chapelInfo['data'])['data']);
      Select select = Select.fromJson(json.decode(chapelInfo['data'])['meta']);
      _data['summary'] = chapel.summary;
      _data['table_head'] = chapel.tableHead;
      _data['table_body'] = chapel.tableBody;
      _data['select'] = select;
    } else {
      Map<String, dynamic> error = json.decode(chapelInfo['err'])['error'];
      _data['err'] = chapelInfo['err'];
      _data['err_title'] = error['title'];
    }
    _isFetching = false;
    notifyListeners();
  }

  Map<String, dynamic> getChapelData() {
    if (_data.isNotEmpty)
      return _data;
    else
      return null;
  }

  bool get isFetching => _isFetching;
}
