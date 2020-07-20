import 'dart:convert';

import 'package:bible_bot/api/api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('api test', () {
    test('login test', () async {
      var result = await Api().getLoginAuth('kyh980909', 'dydgh3258');
      print(result);
      expect(result['result'], true);
    });

    // profile
    test('profile test', () async {
      var result = await Api().getProfile();
      print(result);
      await Api().getProfile();
      expect(result['result'], true);
    });

    test('QR Code test', () async {
      var result = await Api().getQRCode();
      print(result);
      await Api().getQRCode();
      expect(result['result'], true);
    });

    test('chapel test', () async {
      var result = await Api().getChapel(semester: '20201');
      print(result);
      await Api().getChapel(semester: '20201');
      expect(result['result'], true);
    });

    test('course test', () async {
      var result = await Api().getCourse();
      print(result);
      await Api().getCourse();
      expect(result['result'], true);
    });

    test('course code test', () async {
      var result = await Api().getCourseCode(semester: '20201');
      print(result);
      await Api().getCourseCode(semester: '20201');
      expect(result['result'], true);
    });

    test('statement test', () async {
      var result = await Api().getStatement();
      print(result);
      await Api().getStatement();
      expect(result['result'], true);
    });

//    test('timetable test', () async {
//      var result = await Api().getTimetable();
//      print(result);
//      await Api().getTimetable();
//      expect(result['result'], true);
//    });
//
//    test('attendance test', () async {
//      var result = await Api().getAttendance('820');
//      print(result);
//      await Api().getAttendance('820');
//      expect(result['result'], true);
//    });
//
//    test('balance test', () async {
//      var result = await Api().getBalance();
//      print(result);
//      await Api().getBalance();
//      expect(result['result'], true);
//    });
//
//    test('notice test', () async {
//      var result = await Api().getNotice(count: '50');
//      print(result);
//      await Api().getNotice(count: '50');
//      expect(result['result'], true);
//    });

    test('attendance test', () async {
      var result = await Api().getAttendance('1183');
      print(result);
      await Api().getAttendance('1183');
      expect(result['result'], true);
    });

    test('balance test', () async {
      var result = await Api().getBalance();
      print(result);
      await Api().getBalance();
      expect(result['result'], true);
    });

    test('notice test', () async {
      var result = await Api().getNotice(count: '50');
      print(result);
      await Api().getNotice(count: '50');
      expect(result['result'], true);
    });

    test('photo test', () async {
      var result = await Api().getPhoto();
      print(result);
      await Api().getPhoto();
      expect(result['result'], true);
    });

    test('user log test', () async {
      var result = await Api().getUserStudyLog();
      print(result);
      await Api().getUserStudyLog();
      expect(result['result'], true);
    });

    test('aggregate test', () async {
      var studyData = await Api().getUserStudyLog();
      if (studyData['result']) {
        Map<String, dynamic> data = json.decode(studyData['data'])['data'];
        var result = await Api().aggregate(data);
        print(result);
      }
    });

    test('calendar test', () async {
      var result = await Api().getCalendar(kind: 'kbu');
      print(result);
      await Api().getCalendar(kind: 'kbu');
      expect(result['result'], true);
    });

    test('usable test', () async {
      var result = await Api().getUsable();
      print(result);
      await Api().getUsable();
      expect(result['result'], true);
    });
  });
}
