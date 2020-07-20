import 'package:flutter/material.dart';

class AttendanceModel {
  String code;
  String lectureName;
  String kind;
  String gpa;
  String professorName;
  String date;
  String place;

  AttendanceModel(
      {this.code,
      this.lectureName,
      this.kind,
      this.gpa,
      this.professorName,
      this.date,
      this.place});

  factory AttendanceModel.process(List<dynamic> data, String place) {
    if (data != null) {
      if (place == '') place = '미정';
      return new AttendanceModel(
          code: data[0],
          lectureName: data[1],
          kind: data[2],
          gpa: data[3],
          professorName: data[4],
          date: data[5],
          place: place);
    } else {
      return new AttendanceModel(
          code: '',
          lectureName: '',
          kind: '',
          gpa: '',
          professorName: '',
          date: '',
          place: '');
    }
  }
}

class AttendanceProvider {
  final BuildContext context;
  AttendanceModel attendanceModel;
  final color;
  final selected;

  AttendanceProvider(
    this.context,
    this.attendanceModel,
    this.color,
    this.selected,
  );
}
