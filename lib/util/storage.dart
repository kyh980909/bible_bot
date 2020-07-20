import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  // Authorization 가져오기
  static getAuthorization() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('auth');
  }

  // Authorization 저장
  static setAuthorization(String auth) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('auth', auth);
  }

  // 인자로 받은 종류의 data, etag 불러오기
  static getLocalData(String kind) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getStringList(kind);
  }

  // 인자로 받은 종류의 data, etag 저장
  static setLocalData(Map<String, dynamic> data, String kind) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> dataList = List<String>();
    dataList.add(data['data'].toString());
    dataList.add(data['etag'].toString());
    dataList.add(DateTime.now().toString());
    pref.setStringList(kind, dataList);
    // switch (kind) {
    //   case 'image':
    //     pref.setStringList('image', dataList);
    //     break;
    //   case 'profile':
    //     pref.setStringList('profile', dataList);
    //     break;
    //   case 'chapel':
    //     pref.setStringList('chapel', dataList);
    //     break;
    //   case 'course':
    //     pref.setStringList('course', dataList);
    //     break;
    //   case 'courseCode':
    //     pref.setStringList('courseCode', dataList);
    //     break;
    //   case 'statement':
    //     pref.setStringList('statement', dataList);
    //     break;
    //   case 'timetable':
    //     pref.setStringList('timetable', dataList);
    //     break;
    //   case 'attendance':
    //     pref.setStringList('attendance', dataList);
    //     break;
    //   case 'balance':
    //     pref.setStringList('balance', dataList);
    //     break;
    //   case 'notice':
    //     pref.setStringList('notice', dataList);
    //     break;
    //   case 'studentImg':
    //     pref.setStringList('studentImg', dataList);
    //     break;
    //   case 'userStudyLog':
    //     pref.setStringList('userStudyLog', dataList);
    //     break;
    //   case 'kbuCalendar':
    //     pref.setStringList('kbuCalendar', dataList);
    //     break;
    //   case 'holidayCalendar':
    //     pref.setStringList('holidayCalendar', dataList);
    //     break;
    //   case 'usable':
    //     pref.setStringList('usable', dataList);
    //     break;
    //   default:
    //     break;
    // }
  }

  static setTime(String kind) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(kind, DateTime.now().toString());
  }

  static setTimetableSelected(String selected) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('timetableSelected', selected);
  }

  static getTimetableSelected() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('timetableSelected');
  }

  static setChapelSelected(String selected) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('chapelSelected', selected);
  }

  static getChapelSelected() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('chapelSelected');
  }

  static setCourseCode(String semester, String data) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(semester, data);
  }

  static getCourseCode(String semester) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(semester);
  }

  static dataClear() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('timetable');
  }

  static setAutoLoginInfo(String id, String password) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('id', id);
    pref.setString('password', password);
    pref.setBool('autoLoginPermission', true);
  }

  static getAutoLoginInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String email = pref.getString("id");
    String password = pref.getString("password");
    bool permission = pref.getBool("autoLoginPermission");
    Map<String, dynamic> autoLoginInfo = {
      'id': email,
      'pw': password,
      "permission": permission
    };

    return autoLoginInfo;
  }

  static deleteAutoLoginInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('id', "");
    pref.setString("password", "");
    pref.setBool('autoLoginPermission', false);
    pref.clear();
  }
}
