import 'package:bible_bot/api/api.dart';
import 'package:bible_bot/communications/home_screen_information.dart';
import 'package:bible_bot/communications/request.dart';
import 'package:bible_bot/communications/today_cafeteria_menu.dart';
import 'package:bible_bot/communications/user_information.dart';
import 'package:bible_bot/models/style_model.dart';
import 'package:bible_bot/provider/chapel.dart';
import 'package:bible_bot/provider/timetable.dart';
import 'package:bible_bot/screens/basic_screens/notice_screen.dart';
import 'package:bible_bot/screens/initial/initial_screen.dart';
import 'package:bible_bot/util/storage.dart';
import 'package:bible_bot/widgets/flutter_restart.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginControl {
  var connectionResult;
  var studentInfo;
  String errorMessage = '아이디 또는 패스워드가 잘못 입력되었습니다.';
  final timeStamp = new DateTime.now().millisecondsSinceEpoch;

  String validateEmail(String value) {
    if (value.isEmpty) {
      return '아이디를 입력해주세요';
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return '비밀번호를 입력해주세요';
    } else if (value.length < 4) {
      return '비밀번호가 너무 짧습니다.';
    }

    return null;
  }

  // type:1 은 자동로그인, type:2 는 일반로그인
  Future requestLogin(
      BuildContext context, String themeData, String email, String password,
      {bool autoLoginPermission, int type}) async {
    if (email == null || password == null) {
      email = "";
      password = "";
    }
    if (type == 1) {
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Center(
                child: new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation(Colors.blue[400]),
                    strokeWidth: 5.0)),
          );
        },
      );
    }
    connectionResult = await Api().getLoginAuth(
      email.trim(),
      password.trim(),
    );

    if (connectionResult['result']) {
      UserInformation studentInfo = await Request().getStudentInfo();
      HomeScreenInfomation chapelInfo = await Request().getHomeScreenInfo();
      // 중복
      TodayCafeteriaMenu todayCafeteriaMenuInfo =
          await Request().getTodayCafeteriaMenu(timeStamp);

      if (autoLoginPermission == true) {
        await Storage.setAutoLoginInfo(email, password);
      }

      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => MultiProvider(providers: [
                Provider<StyleModel>.value(
                    value: StyleModel(context, currentTheme: themeData)),
                Provider<String>.value(value: themeData),
                Provider<UserInformation>(create: (context) => studentInfo),
                Provider<HomeScreenInfomation>(create: (context) => chapelInfo),
                Provider<TodayCafeteriaMenu>(
                    create: (context) => todayCafeteriaMenuInfo),
                ChangeNotifierProvider(
                  create: (context) => TimetableProvider(themeData),
                ),
              ], child: InitialScreen())));
    } else if (connectionResult['err'] == "NetworkConnectionError" &&
        type == 2) {
      Flushbar(
        message: "학교 서버에 문제가 발생했습니다. 잠시후 다시 시도해주세요.",
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        icon: Icon(
          Icons.info_outline,
          size: 25.0,
          color: Colors.blue[400],
        ),
        duration: Duration(seconds: 2),
        leftBarIndicatorColor: Colors.blue[400],
      )..show(context);
    } else if (connectionResult['result'] == false &&
        type == 2 &&
        connectionResult['err'] != "server error") {
      if (type != 1) {
        Navigator.pop(context);
      }
      Flushbar(
        message: "$errorMessage",
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        icon: Icon(
          Icons.info_outline,
          size: 25.0,
          color: Colors.blue[400],
        ),
        duration: Duration(seconds: 2),
        leftBarIndicatorColor: Colors.blue[400],
      )..show(context);
    } else if (connectionResult['err'] == "AlertError: '비밀번호가 일치하지 않습니다.'") {
      if (type != 1) {
        Navigator.pop(context);
      }
      // 중복
      TodayCafeteriaMenu todayCafeteriaMenuInfo =
          await Request().getTodayCafeteriaMenu(timeStamp);

      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => MultiProvider(providers: [
                  Provider<StyleModel>.value(value: StyleModel(context)),
                  Provider<String>.value(value: themeData),
                  Provider<TodayCafeteriaMenu>(
                      create: (context) => todayCafeteriaMenuInfo),
                ], child: NoticeScreen())));
      });
    } else if (connectionResult['result'] == false && type == 1) {
      // 비밀번호 변경 됬을 시 재로그인
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('알림'),
            content: Text(connectionResult['err']),
            actions: <Widget>[
              FlatButton(
                  child: Text('확인'), onPressed: () => Navigator.pop(context)),
            ],
          );
        },
      );
      Storage.deleteAutoLoginInfo();
      RestartWidget.of(context).restartApp();
    } else {
      if (type != 1) {
        Navigator.pop(context);
      }
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('알림'),
            content: const Text.rich(
              TextSpan(
                text: '학교 서버 상태가 좋지않습니다.\n',
                children: <TextSpan>[
                  TextSpan(
                      text: '(교내와이파이를 사용하면 접속이 되지 않을 수 있습니다.)',
                      style: TextStyle(fontSize: 12.0, color: Colors.grey))
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('종료'),
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
              ),
            ],
          );
        },
      );
    }
  }
}
