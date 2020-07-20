import 'dart:convert';

import 'package:bible_bot/api/api.dart';
import 'package:bible_bot/communications/statement_information.dart';
import 'package:bible_bot/communications/today_cafeteria_menu.dart';
import 'package:bible_bot/communications/user_information.dart';
import 'package:bible_bot/models/chapel.dart';
import 'package:bible_bot/models/img.dart';
import 'package:bible_bot/models/profile.dart';
import 'package:intl/intl.dart';

import 'home_screen_information.dart';

class Request {
  var studentInfo;
  var studentImg;
  var request;
  Map<String, dynamic> studentTotalInfo;
  Api api = Api();
  Map<String, String> errorStatus = {'status': 'error'};
  Map<String, List<String>> errorMessage;

  Future<UserInformation> getStudentInfo() async {
    studentInfo = await api.getProfile();
    studentInfo = Profile.fromJson(studentInfo);
    studentImg = await Api().getPhoto();
    studentImg = Img.fromJson(studentImg);

    studentTotalInfo = {
      'info': studentInfo,
      'img': studentImg,
    };

    return UserInformation.fromJson(studentTotalInfo);
  }
  Future<HomeScreenInfomation> getHomeScreenInfo() async {
    studentInfo = await api.getChapel();
    Chapel chapel;
    var balanceMoney;
    if(studentInfo['result']) {
      chapel =
      new Chapel.fromJson(json.decode(studentInfo['data'])['data']);
    }
    else {
      var emptyData = {
        'summary': {"주중수업일수": '0', "규정일수": '0', "출석": '0', "지각": '0', "확정": '0'},
        'head': [],
        'body': [],
      };
      chapel = new Chapel.fromJson(emptyData);
    }

    var balance = await api.getBalance();

    if(balance['result']){
      balanceMoney = jsonDecode(balance['data'])['data']['balance'];
    }
    else{
      balanceMoney = '0';
    }

    studentTotalInfo = {
      'chapel': chapel,
      'money': balanceMoney,
    };

    return HomeScreenInfomation.fromJson(studentTotalInfo);
  }

  Future getTodayCafeteriaMenu(timeStamp) async {
    errorMessage = {
      'menus': ["학식이 등록되지 않았습니다."]
    };
    try {
      request = await api.getTodayCafeteriaInfo(timeStamp);
      Map<String, dynamic> menu = request['result']['menu'];
      request = {
        'status': true,
        'lunch': menu['lunch']['menus'].isEmpty ? errorMessage : menu['lunch'],
        'dinner':
            menu['dinner']['menus'].isEmpty ? errorMessage : menu['dinner'],
        'daily': menu['daily']['menus'].isEmpty ? errorMessage : menu['daily'],
        'fix': menu['fix']['menus'].isEmpty ? errorMessage : menu['fix'],
        'lunchPrice':
            menu['lunchPrice'] != null ? menu['lunchPrice'].toString() : "0",
        'dinnerPrice':
            menu['dinnerPrice'] != null ? menu['dinnerPrice'].toString() : "0",
      };

      return TodayCafeteriaMenu.fromJson(request);
    } catch (Exception) {
      print("Cafeteria Menu Error Message : $Exception");
      request = {
        'status': false,
        'lunch': errorMessage,
        'dinner': errorMessage,
        'daily': errorMessage,
        'fix': errorMessage,
        'lunchPrices': "",
        'dinnerPrice': "" ,
      };
      request = TodayCafeteriaMenu.fromJson(request);
      return request;
    }
  }

  Future<Statement> getStatementInfo() async {
    request = await api.getStatement();
    if (request['result']) {
      List<dynamic> data = jsonDecode(request['data'])['data']['body'];
      List expense = [];
      List profit = [];

      for (int i = 0; i < data.length; i++) {
        var dataType = data[i][2];
        if (dataType == '사용' || dataType == '적립취소') {
          // 지출
          expense.add(data[i]);
        } else {
          // 수입
          profit.add(data[i]);
        }
      }
      request = {
        'status': request['result'],
        'entire': data,
        'expense': expense,
        'profit': profit,
      };
    } else {
      request = {
        'status': request['result'],
        'entire': [],
        'expense': [],
        'profit': [],
      };
    }
    return Statement.fromJson(request);
  }

  Future<Map<String, dynamic>> getMscInfo() async {
    Map<String, dynamic> mscInfo;

    try {
      request = await api.getQRCode().timeout(Duration(seconds: 5));
      var decodedRequestData = jsonDecode(request['data']);
      var unixIat = int.parse(
          decodedRequestData['meta']['iat'].toString().substring(0, 10));
      var unixExp = int.parse(
          decodedRequestData['meta']['exp'].toString().substring(0, 10));

      DateTime iat = new DateTime.fromMillisecondsSinceEpoch(unixIat * 1000);
      DateTime exp = new DateTime.fromMillisecondsSinceEpoch(unixExp * 1000);

      var now = DateTime.now().toUtc();
      var unixNow = now.microsecondsSinceEpoch / 1000000;

      var time = decodedRequestData['meta']['exp'] - unixNow;
      var effectiveTime = time.toInt();
      // 41초일때 0초
      mscInfo = {
        'status': true,
        'img': decodedRequestData['data']['img'],
        'iat': iat,
        'exp': exp,
        'effectiveTime': 19,
      };
    } catch (Exception) {
      mscInfo = {
        'status': false,
        'img': "",
        'iat': "",
        'exp': "",
        "effectiveTime": "",
      };
    }

    print(mscInfo);
    return mscInfo;
  }
}
