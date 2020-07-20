import 'dart:convert';
import 'package:bible_bot/api/api_info.dart';
import 'package:bible_bot/models/studyLog.dart';
import 'package:bible_bot/util/storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../models/studyLog.dart';
import '../util/http_data_process.dart';

class Api {
  final String _url = ApiInfo.url;
  var auth;
  var response;
  Map<String, dynamic> result = {};
  Map<String, dynamic> jwt;
  Map<String, String> body = {};
  Map<String, String> header = {};
  var storageData;
  String requestType;

  Future<Map<String, dynamic>> getTodayCafeteriaInfo(timeStamp) async {
    response = await http
        .get('${ApiInfo.baseServerUrl}/api/menu/menu/${timeStamp.toString()}')
        .timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      result = {
        'status': "ok",
        'result': jsonDecode(utf8.decode(response.bodyBytes)),
      };
    } else {
      result = {'status': false, 'err': utf8.decode(response.bodyBytes)};
    }
    return result;
  }

  // 로그인 요청
  Future<Map<String, dynamic>> getLoginAuth(String id, String pw) async {
    body = {'id': id, 'pw': pw};
    try {
      response = await http
          .post('$_url/auth/login', body: convert.jsonEncode(body))
          .timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          result = {
            'result': false,
            'err': json.decode(response.body)['data']['error']['title']
          };
        } else {
          result = {'result': true};
          auth = response.headers['authorization'];
          Storage.setAuthorization(auth);
        }
      } else {
        result = {'result': false, 'err': utf8.decode(response.bodyBytes)};
      }
    } catch (Exception) {
      result = {'result': false, 'err': 'server error'};
    }

    return result;
  }

  // qrcode 요청
  Future<Map<String, dynamic>> getQRCode() async {
    header = {'Authorization': await Storage.getAuthorization()};

    response = await http
        .post('$_url/msc/code', headers: header)
        .timeout(new Duration(seconds: 10));
    return HttpDataPorcess.auth(response, kind: 'qrcode');
  }

  // msc 요청
  Future<Map<String, dynamic>> getMsc() async {
    header = {'Authorization': await Storage.getAuthorization()};

    response = await http.get('$_url/auth/msc', headers: header);
    return HttpDataPorcess.auth(response);
  }

  // img 요청
  Future<Map<String, dynamic>> getPhoto() async {
    requestType = 'studentImg';
    header = {'Authorization': await Storage.getAuthorization()};
    storageData = await Storage.getLocalData(requestType);
    if (storageData != null) {
      // 내부 데이터가 있을 경우 헤더에 ETag를 담아 요청
      header['If-None-Match'] = storageData[1]; // 1은 etag
    }

    response = await http.get('$_url/users/photo', headers: header);
    return HttpDataPorcess.auth(response, kind: requestType);
  }

  // profile 요청
  Future<Map<String, dynamic>> getProfile({List fields}) async {
    requestType = 'profile';
    storageData = await Storage.getLocalData(requestType);
    header = {
      'Authorization': await Storage.getAuthorization(),
    };
    if (storageData != null) {
      // 내부 데이터가 있을 경우 헤더에 ETag를 담아 요청
      header['If-None-Match'] = storageData[1]; // 1은 etag
    }

    response = await http.get(
        fields == null
            ? '$_url/users/profile'
            : '$_url/users/profile?fields=${fields.toString()}',
        headers: header);

    return await HttpDataPorcess.auth(response, kind: requestType);
  }

  // chapel 요청
  Future<Map<String, dynamic>> getChapel({String semester, List fields}) async {
    requestType = 'chapel';
    storageData = await Storage.getLocalData(requestType);
    header = {
      'Authorization': await Storage.getAuthorization(),
    };
    if (storageData != null) {
      header['If-None-Match'] = storageData[1];
    }

    response = await http.get(
        semester == null
            ? fields == null
                ? '$_url/users/chapel'
                : '$_url/users/chapel?fields=$fields'
            : fields == null
                ? '$_url/users/chapel?semester=$semester'
                : '$_url/users/chapel?semester=$semester&fields=$fields',
        headers: header);

    return await HttpDataPorcess.auth(response, kind: requestType);
  }

  // course 요청
  Future<Map<String, dynamic>> getCourse({String semester, List fields}) async {
    requestType = 'course${semester ?? ''}';
    storageData = await Storage.getLocalData(requestType);
    header = {
      'Authorization': await Storage.getAuthorization(),
    };

    if (storageData != null) {
      header['If-None-Match'] = storageData[1];
      if (DateTime.parse(storageData[2])
          .add(Duration(minutes: 5))
          .isAfter(DateTime.now())) {
        return result = {
          'result': true,
          'data': storageData[0],
          'etag': storageData[1]
        };
      }
    }

    response = await http.get(
        semester == null
            ? fields == null
                ? '$_url/users/course'
                : '$_url/users/course?fields=${fields.toString()}'
            : fields == null
                ? '$_url/users/course?semester=$semester'
                : '$_url/users/course?semester=$semester&fields=${fields.toString()}',
        headers: header);

    return await HttpDataPorcess.auth(response, kind: requestType);
  }

  // course_code 요청
  Future<Map<String, dynamic>> getCourseCode(
      {String semester, List fields}) async {
    requestType = 'courseCode';
    storageData = await Storage.getLocalData(requestType);
    header = {
      'Authorization': await Storage.getAuthorization(),
    };
    if (storageData != null) {
      header['If-None-Match'] = storageData[1];
    }

    response = await http.get(
        semester == null
            ? fields == null
                ? '$_url/users/course-code'
                : '$_url/users/course-code?fields=$fields'
            : fields == null
                ? '$_url/users/course-code?semester=$semester'
                : '$_url/users/course-code?semester=$semester&fields=$fields',
        headers: header);

    return await HttpDataPorcess.auth(response, kind: requestType);
  }

  // 마일리지 변동사항 요청
  Future<Map<String, dynamic>> getStatement({List fields}) async {
    requestType = 'statement';
    storageData = await Storage.getLocalData(requestType);
    Map<String, String> header = {
      'Authorization': await Storage.getAuthorization(),
    };
    if (storageData != null) {
      header['If-None-Match'] = storageData[1];
    }
    try {
      var response = await http.get(
          fields == null
              ? '$_url/users/statement'
              : '$_url/users/statement?fields=${fields.toString()}',
          headers: header);

      return await HttpDataPorcess.auth(response, kind: requestType);
    } catch (Exception) {
      print("Statement Error Message : Exception");
      return response = {'result': false, 'state': Exception};
    }
  }

  // 시간표 요청
  Future<Map<String, dynamic>> getTimetable(
      {String semester, List fields}) async {
    requestType = 'timetable$semester';
    storageData = await Storage.getLocalData(requestType);
    header = {
      'Authorization': await Storage.getAuthorization(),
    };
    if (storageData != null) {
      header['If-None-Match'] = storageData[1];
      if (DateTime.parse(storageData[2])
          .add(Duration(minutes: 5))
          .isAfter(DateTime.now())) {
        return result = {
          'result': true,
          'data': storageData[0],
          'etag': storageData[1]
        };
      }
    }

    var response = await http.get(
        semester == null
            ? fields == null
                ? '$_url/users/timetable'
                : '$_url/users/timetable?fields=$fields'
            : fields == null
                ? '$_url/users/timetable?semester=$semester'
                : '$_url/users/timetable?semester=$semester&fields=$fields',
        headers: header);
    return await HttpDataPorcess.auth(response, kind: requestType);
  }

  // 출석 요청
  Future<Map<String, dynamic>> getAttendance(String lmsCode,
      {List fields}) async {
    requestType = 'attendance$lmsCode';
    storageData = await Storage.getLocalData(requestType);
    header = {
      'Authorization': await Storage.getAuthorization(),
    };
    if (storageData != null) {
      header['If-None-Match'] = storageData[1];
      if (DateTime.parse(storageData[2])
          .add(Duration(minutes: 5))
          .isAfter(DateTime.now())) {
        return result = {
          'result': true,
          'data': storageData[0],
          'etag': storageData[1]
        };
      }
    }

    var response = await http.get(
        fields == null
            ? '$_url/users/attendance/$lmsCode'
            : '$_url/usersf/attendance/$lmsCode?semester=$fields',
        headers: header);

    return await HttpDataPorcess.auth(response, kind: requestType);
  }

  // 마일리지 잔액 요청
  Future<Map<String, dynamic>> getBalance({List fields}) async {
    requestType = 'balance';
    storageData = await Storage.getLocalData(requestType);
    header = {
      'Authorization': await Storage.getAuthorization(),
    };
    if (storageData != null) {
      header['If-None-Match'] = storageData[1];
    }

    var response = await http.get(
        fields == null
            ? '$_url/users/balance'
            : '$_url/users/balance"?fields=${fields.toString()}',
        headers: header);

    return await HttpDataPorcess.auth(response, kind: requestType);
  }

  // 공지사항 요청
  Future<Map<String, dynamic>> getNotice(
      {List fields,
      String maxId,
      String sinceId,
      String count,
      String category}) async {
    requestType = 'notice';
    storageData = await Storage.getLocalData(requestType);
    if (storageData != null) {
      header['If-None-Match'] = storageData[1];
    }
    var response;
    if (category == null) {
      response = await http.get(
          maxId == null
              ? fields == null
                  ? '$_url/info/notice?count=$count'
                  : '$_url/info/notice?count=$count&fields=$fields'
              : fields == null
                  ? '$_url/info/notice?count=$count&max_id=$maxId'
                  : '$_url/info/notice?count=$count&max_id=$maxId&fields=$fields',
          headers: header);
    } else {
      response = await http.get(
          maxId == null
              ? fields == null
                  ? '$_url/info/notice?count=$count&category=$category'
                  : '$_url/info/notice?count=$count&fields=$fields&category=$category'
              : fields == null
                  ? '$_url/info/notice?count=$count&max_id=$maxId&category=$category'
                  : '$_url/info/notice?count=$count&max_id=$maxId&fields=$fields&category=$category',
          headers: header);
    }

    if (count == '50') {
      return await HttpDataPorcess.auth(response, kind: requestType);
    } else {
      if (response.statusCode == 200) {
        result = {
          'result': true,
          'data': utf8.decode(response.bodyBytes),
          'etag': response.headers['etag'] ?? ''
        };
      } else {
        result = {'result': false, 'err': response.body};
      }
      return result;
    }
  }

  /*

  is_manual : 0 - 집계 하는거고, 1 - 집계 안함
  admin_dept : 어떤 어드민 계정으로 찍었는지 설명


   */

  // 사용자의 스터디 기록 요청
  Future<Map<String, dynamic>> getUserStudyLog({List fields}) async {
    requestType = 'userStudyLog';
    storageData = await Storage.getLocalData(requestType);
    header = {
      'Authorization': await Storage.getAuthorization(),
    };
    if (storageData != null) {
      header['If-None-Match'] = storageData[1];
    }

    var response = await http.get(
        fields == null
            ? '$_url/msc/user-log?dept=교수학습센터'
            : '$_url/msc/user-log?dept=교수학습센터&fields=$fields',
        headers: header);

    return await HttpDataPorcess.auth(response, kind: requestType);
  }

  Future<StudyLog> getStudyData() async {
    try {
      var logData = await getUserStudyLog();
      var decodedLogData = jsonDecode(logData['data']);
      var studyLog = decodedLogData['data']['data'].reversed;
      studyLog = List.from(studyLog);
      if (logData['result']) {
        result = {
          'status': true,
          'studyLog': studyLog,
          'dataLength': decodedLogData['data']['data'].length
        };
      } else {
        result = {
          'status': false,
          'studyLog': [],
          'dataLength': 0,
        };
      }
    } catch (Exception) {
      result = {
        'status': false,
        'studyLog': [],
        'dataLength': 0,
      };
    }

    return StudyLog.fromJson(result);
  }

  // 스터디 기록 집계 api
  Future<Map<String, dynamic>> aggregate(Map<String, dynamic> data) async {
    var response =
        await http.post('$_url/msc/aggregate', body: json.encode(data));

    if (response.statusCode == 200) {
      result = {'result': true, 'data': json.decode(response.body)['data']};
    } else {
      result = {
        'result': false,
        'err': json.decode(response.body)['error']['title']
      };
    }

    return result;
  }

  Future<Aggregate> getAggregate() async {
    var aggregateData;
    try {
      var studyData = await Api().getUserStudyLog();
      if (studyData['result']) {
        Map<String, dynamic> data = json.decode(studyData['data'])['data'];
        int dataLength = data['data'].length;

        if (dataLength > 1) {
          // studyData의 전체 데이터
          var userId = data['data'][0]['user_univ_id']; // 데이터에서 하나 빼옴
          aggregateData = await Api().aggregate(data);
          var detailData = aggregateData['data'][userId]['detail'].reversed;
          detailData = List.from(detailData);
          result = {
            'status': true,
            'total_secondes': aggregateData['data'][userId]['total_seconds'],
            'detail': detailData,
          };
        } else {
          result = {
            'status': false,
            'total_secondes': 0,
            'detail': [],
          };
        }
      } else {
        result = {
          'status': false,
          'total_secondes': 0,
          'detail': [],
        };
      }
    } catch (Exception) {
      result = {
        'status': false,
        'total_secondes': 0,
        'detail': [],
      };
    }
/*
{result: true, data: {"meta":{},
"data":{"data":[{"is_manual":0,
"access_datetime":"2020-04-09 14:46:21",
"updated_datetime":"2020-04-09 14:46:21",
"disabled_aggregate":0,
"admin_dept":"테스트",
"user_univ_id":"201504018"},

 */

    return Aggregate.fromJson(result);
  }

  Future<Map<String, dynamic>> getCalendar({String kind, List fields}) async {
    requestType = '${kind}Calendar';
    storageData = await Storage.getLocalData(requestType);
    if (storageData != null) {
      header['If-None-Match'] = storageData[1];
    }

    var response = await http.get(
        fields == null
            ? '$_url/info/calendar/$kind'
            : '$_url/info/calendar/$kind?fields=$fields',
        headers: header);
    return await HttpDataPorcess.auth(response, kind: requestType);
  }

  Future<Map<String, dynamic>> getUsable({List fields}) async {
    requestType = 'usable';
    storageData = await Storage.getLocalData(requestType);
    if (storageData != null) {
      header['If-None-Match'] = storageData[1];
    }

    var response = await http.get(
        fields == null ? '$_url/msc/usable' : '$_url/msc/usable?fields=$fields',
        headers: header);
    return await HttpDataPorcess.auth(response, kind: requestType);
  }
}
