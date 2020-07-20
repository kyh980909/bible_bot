import 'dart:async';
import 'package:bible_bot/communications/request.dart';
import 'package:bible_bot/communications/today_cafeteria_menu.dart';
import 'package:bible_bot/provider/chapel.dart';
import 'package:bible_bot/screens/basic_screens/notice_screen.dart';
import 'package:bible_bot/screens/login_screens/login_control.dart';
import 'package:bible_bot/util/storage.dart';
import 'package:bible_bot/widgets/flutter_restart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'models/style_model.dart';
import 'screens/basic_screens/splash_screen.dart';

void main() {
  // flutter 업그레이드 후 오류발생 => 아래 구문으로 해결
  WidgetsFlutterBinding.ensureInitialized();
  // syncfusion calendar license key
  SyncfusionLicense.registerLicense(
      "NT8mJyc2IWhia31ifWN9Z2doYmF8YGJ8ampqanNiYmlmamlmanMDHmg4Kjtqa2NqY2oTND4yOj99MDw+");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChapelProvider(),
        )
      ],
      child: RestartWidget(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "성서봇",
          home: BibleBot(),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('ko'),
            const Locale('en'),
          ],
        ),
      ),
    ),
  );

  // 가로모드 방지
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class BibleBot extends StatefulWidget {
  @override
  _BibleBotState createState() => _BibleBotState();
}

class _BibleBotState extends State<BibleBot> {
  final timeStamp = new DateTime.now().millisecondsSinceEpoch;

  void autoLoginCheck() async {
    String themeData = await StyleModel(context).getSettingMode();
    Map<String, dynamic> autoLoginPermission = await Storage.getAutoLoginInfo();

    if (autoLoginPermission['permission'] == true) {
      await LoginControl().requestLogin(context, themeData,
          autoLoginPermission['id'], autoLoginPermission['pw'],
          type: 1);
    } else {
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
    }
  }

  @override
  void initState() {
    super.initState();
    autoLoginCheck();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [Provider<StyleModel>.value(value: StyleModel(context))],
        child: Scaffold(
          body: SplashPage(),
        ));
  }
}
