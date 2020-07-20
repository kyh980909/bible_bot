import 'dart:convert';

class UserLog {
  final int isManual;
  final String accessDatetime;
  final String updatedDatetime;
  final int disabledAggregate;
  final String adminDept;
  final String userUnivId;

  UserLog(
      {this.isManual,
      this.accessDatetime,
      this.updatedDatetime,
      this.disabledAggregate,
      this.adminDept,
      this.userUnivId});

  factory UserLog.fromJson(Map<dynamic, dynamic> json) {
    json = jsonDecode(json['data'])['data'];
    return new UserLog(
        isManual: json['is_manual'],
        accessDatetime: json['access_datetime'],
        updatedDatetime: json['updated_datetime'],
        disabledAggregate: json['disabled_aggregate'],
        adminDept: json['admin_dept'],
        userUnivId: json['user_univ_id']);
  }
}
