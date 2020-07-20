import 'dart:convert';
import 'package:bible_bot/api/api.dart';
import 'package:bible_bot/util/storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class HttpDataPorcess {
  static Future<Map<String, dynamic>> auth(Response response,
      {String kind}) async {
    Map<String, dynamic> result = {};

    if (response.statusCode == 401) {
      Map<String, dynamic> userInfo = await Storage.getAutoLoginInfo();
      Map<String, dynamic> loginResult =
          await Api().getLoginAuth(userInfo['id'], userInfo['pw']);
      // 세션 만료됬을 떄 재요청
      if (loginResult['result']) {
        String auth = await Storage.getAuthorization();
        if (kind == 'qrcode') {
          response = await http.post(response.request.url,
              headers: {'Authorization': auth}).timeout(Duration(seconds: 10));
        } else {
          response = await http.get(response.request.url,
              headers: {'Authorization': auth}).timeout(Duration(seconds: 5));
        }
        print('토큰 재발급');
      }
    }
    if (response.statusCode == 200) {
      result = {
        'result': true,
        'data': utf8.decode(response.bodyBytes),
        'etag': response.headers['etag'] ?? ''
      };
      // 받은 데이터, etag 내부 저장소에 저장
      await Storage.setLocalData(result, kind);
    } else if (response.statusCode == 304) {
      // etag 같을 때
      var storageData = await Storage.getLocalData(kind);
      result = {'result': true, 'data': storageData[0], 'etag': storageData[1]};
      Storage.setLocalData(result, kind);
      // Storage.setTime(kind);
    } else if (response.statusCode == 204) {
      result = {
        'result': false,
        'statusCode': response.statusCode,
        'err': "신입생"
      };
    } else {
      result = {
        'result': false,
        'statusCode': response.statusCode,
        'err': response.body
      };
    }

    return result;
  }
}
