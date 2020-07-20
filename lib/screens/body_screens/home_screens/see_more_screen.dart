import 'package:bible_bot/communications/home_screen_information.dart';
import 'package:bible_bot/communications/user_information.dart';
import 'package:bible_bot/models/style_model.dart';
import 'package:bible_bot/screens/body_screens/home_screens/developer_screen.dart';
import 'package:bible_bot/screens/body_screens/home_screens/schedule.dart';
import 'package:bible_bot/screens/body_screens/home_screens/school_news.dart';
import 'package:bible_bot/screens/popup_menu/license.dart';
import 'package:bible_bot/screens/popup_menu/setting_list/theme.dart';
import 'package:bible_bot/util/show_amount.dart';
import 'package:bible_bot/util/storage.dart';
import 'package:bible_bot/widgets/flutter_restart.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'campus_map.dart';
import 'mileage_screen.dart';
import 'study_screen.dart';

class SeeMoreScreen extends StatefulWidget {
  @override
  _SeeMoreScreenState createState() => _SeeMoreScreenState();
}

class _SeeMoreScreenState extends State<SeeMoreScreen> {
  Future getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return '현재버전: ${packageInfo.version}';
  }

  @override
  Widget build(BuildContext context) {
    StyleModel styleModel = Provider.of<StyleModel>(context);
    UserInformation studentInfo = Provider.of<UserInformation>(context);
    HomeScreenInfomation homeScreenInfo =
        Provider.of<HomeScreenInfomation>(context);
    String themeData = Provider.of<String>(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    height: double.infinity,
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "${studentInfo.profile.name}님",
                                      style: styleModel
                                          .getTextStyle()['subtitleTextStyle'],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "좋은 하루 보내세요!",
                                      style: styleModel
                                          .getTextStyle()['bodyTextStyle'],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 24.0, top: 8.0, bottom: 8.0),
                              child: RaisedButton(
                                highlightElevation: 0,
                                highlightColor: styleModel
                                    .getBackgroundColor()['highLightColor'],
                                focusElevation: 0,
                                elevation: 0,
                                splashColor: styleModel
                                    .getBackgroundColor()['splashColor'],
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(8.0),
                                    side: BorderSide(
                                        color: styleModel.getBackgroundColor()[
                                            'greyLevel2'])),
                                onPressed: () {
                                  Storage.deleteAutoLoginInfo();
                                  RestartWidget.of(context).restartApp();
                                },
                                child: Text(
                                  "LOGOUT",
                                  style: styleModel
                                      .getTextStyle()['smallBodyTextStyle'],
                                  textScaleFactor: 1.1,
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                child: Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                    child: Container(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.green[200],
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: Column(
                                children: <Widget>[
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 18.0, bottom: 8.0),
                                        child: Text(
                                          "마일리지 잔액",
                                          overflow: TextOverflow.ellipsis,
                                          style: styleModel
                                              .getTextStyle()['bodyTextStyle'],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Text(
                                            "${showAmount(homeScreenInfo.balance)}원",
                                            overflow: TextOverflow.ellipsis,
                                            style: styleModel.getTextStyle()[
                                                'subtitleTextStyle'],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment.centerRight,
                                  child: RaisedButton(
                                    highlightElevation: 0,
                                    highlightColor: styleModel
                                        .getBackgroundColor()['highLightColor'],
                                    focusElevation: 0,
                                    elevation: 0,
                                    splashColor: Colors.transparent,
                                    color: Colors.transparent,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              MultiProvider(providers: [
                                            Provider<StyleModel>.value(
                                                value: StyleModel(context,
                                                    currentTheme: themeData)),
                                            Provider<String>.value(
                                                value: themeData),
                                          ], child: MileageNewVersion()),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          "내역확인",
                                          overflow: TextOverflow.ellipsis,
                                          style: styleModel.getTextStyle()[
                                              'smallBodyTextStyle'],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: styleModel
                                              .getIconColor()['themeIconColor'],
                                          size: styleModel.getContextSize()[
                                              'smallIconSize'],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: RaisedButton(
                                  highlightElevation: 0,
                                  highlightColor: styleModel
                                      .getBackgroundColor()['highLightColor'],
                                  focusElevation: 0,
                                  elevation: 0,
                                  splashColor: styleModel
                                      .getBackgroundColor()['splashColor'],
                                  color: Colors.transparent,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            MultiProvider(providers: [
                                          Provider<StyleModel>.value(
                                              value: StyleModel(context,
                                                  currentTheme: themeData)),
                                          Provider<String>.value(
                                              value: themeData),
                                        ], child: SchoolNewsScreen()),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Icon(
                                                Icons.notifications_active,
                                                size:
                                                    styleModel.getContextSize()[
                                                        'bigIconSize'],
                                                color: Colors.yellow[200]),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Text(
                                              "공지사항",
                                              overflow: TextOverflow.ellipsis,
                                              style: styleModel.getTextStyle()[
                                                  'bodyTextStyle'],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: RaisedButton(
                                  highlightElevation: 0,
                                  highlightColor: styleModel
                                      .getBackgroundColor()['highLightColor'],
                                  focusElevation: 0,
                                  elevation: 0,
                                  splashColor: styleModel
                                      .getBackgroundColor()['splashColor'],
                                  color: Colors.transparent,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            MultiProvider(providers: [
                                          Provider<StyleModel>.value(
                                              value: StyleModel(context,
                                                  currentTheme: themeData)),
                                        ], child: CampusMapScreen()),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Icon(
                                              Icons.location_on,
                                              size: styleModel.getContextSize()[
                                                  'bigIconSize'],
                                              color: Colors.greenAccent,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Text(
                                              "캠퍼스맵",
                                              overflow: TextOverflow.ellipsis,
                                              style: styleModel.getTextStyle()[
                                                  'bodyTextStyle'],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: RaisedButton(
                                  highlightElevation: 0,
                                  highlightColor: styleModel
                                      .getBackgroundColor()['highLightColor'],
                                  focusElevation: 0,
                                  elevation: 0,
                                  splashColor: styleModel
                                      .getBackgroundColor()['splashColor'],
                                  color: Colors.transparent,
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute<void>(
                                            builder: (BuildContext context) {
                                      return MultiProvider(providers: [
                                        Provider<String>.value(
                                            value: themeData),
                                        Provider<StyleModel>.value(
                                            value: StyleModel(context,
                                                currentTheme: themeData))
                                      ], child: License());
                                    }));
                                  },
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Icon(Icons.content_paste,
                                                size:
                                                    styleModel.getContextSize()[
                                                        'bigIconSize'],
                                                color: Colors.brown),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Text(
                                              "라이센스",
                                              overflow: TextOverflow.ellipsis,
                                              style: styleModel.getTextStyle()[
                                                  'bodyTextStyle'],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: RaisedButton(
                                  highlightElevation: 0,
                                  highlightColor: styleModel
                                      .getBackgroundColor()['highLightColor'],
                                  focusElevation: 0,
                                  elevation: 0,
                                  splashColor: styleModel
                                      .getBackgroundColor()['splashColor'],
                                  color: Colors.transparent,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            MultiProvider(providers: [
                                          Provider<StyleModel>.value(
                                              value: StyleModel(context,
                                                  currentTheme: themeData)),
                                          Provider<String>.value(
                                              value: themeData),
                                        ], child: Schedule()),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Icon(
                                              Icons.calendar_today,
                                              size: styleModel.getContextSize()[
                                                  'bigIconSize'],
                                              color: styleModel
                                                      .getBackgroundColor()[
                                                  'reversalColorLevel1'],
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Text(
                                              "학사일정",
                                              overflow: TextOverflow.ellipsis,
                                              style: styleModel.getTextStyle()[
                                                  'bodyTextStyle'],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: RaisedButton(
                                  highlightElevation: 0,
                                  highlightColor: styleModel
                                      .getBackgroundColor()['highLightColor'],
                                  focusElevation: 0,
                                  elevation: 0,
                                  splashColor: styleModel
                                      .getBackgroundColor()['splashColor'],
                                  color: Colors.transparent,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            MultiProvider(providers: [
                                          Provider<StyleModel>.value(
                                              value: StyleModel(context,
                                                  currentTheme: themeData)),
                                          Provider<String>.value(
                                              value: themeData),
                                        ], child: DeveloperScreen()),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Icon(
                                              Icons.group,
                                              size: styleModel.getContextSize()[
                                                  'bigIconSize'],
                                              color: Colors.orangeAccent[100],
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Text(
                                              "만든이들",
                                              overflow: TextOverflow.ellipsis,
                                              style: styleModel.getTextStyle()[
                                                  'bodyTextStyle'],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: RaisedButton(
                                  highlightElevation: 0,
                                  highlightColor: styleModel
                                      .getBackgroundColor()['highLightColor'],
                                  focusElevation: 0,
                                  elevation: 0,
                                  splashColor: styleModel
                                      .getBackgroundColor()['splashColor'],
                                  color: Colors.transparent,
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute<void>(
                                            builder: (BuildContext context) {
                                      return MultiProvider(providers: [
                                        Provider<String>.value(
                                            value: themeData),
                                        Provider<StyleModel>.value(
                                            value: StyleModel(context,
                                                currentTheme: themeData))
                                      ], child: ThemeScreen());
                                    }));
                                  },
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Icon(
                                              Icons.title,
                                              size: styleModel.getContextSize()[
                                                  'bigIconSize'],
                                              color: Colors.purple[200],
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Text(
                                              "테마",
                                              overflow: TextOverflow.ellipsis,
                                              style: styleModel.getTextStyle()[
                                                  'bodyTextStyle'],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: RaisedButton(
                                  highlightElevation: 0,
                                  highlightColor: styleModel
                                      .getBackgroundColor()['highLightColor'],
                                  focusElevation: 0,
                                  elevation: 0,
                                  splashColor: styleModel
                                      .getBackgroundColor()['splashColor'],
                                  color: Colors.transparent,
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute<void>(
                                            builder: (BuildContext context) {
                                      return MultiProvider(providers: [
                                        Provider<String>.value(
                                            value: themeData),
                                        Provider<StyleModel>.value(
                                            value: StyleModel(context,
                                                currentTheme: themeData))
                                      ], child: StudyScreen());
                                    }));
                                  },
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Icon(
                                              Icons.class_,
                                              size: styleModel.getContextSize()[
                                                  'bigIconSize'],
                                              color: Colors.cyan,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Text(
                                              "스터디실",
                                              overflow: TextOverflow.ellipsis,
                                              style: styleModel.getTextStyle()[
                                                  'bodyTextStyle'],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: Container(),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: FutureBuilder(
                            future: getVersion(),
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.hasData ? snapshot.data : '',
                                textScaleFactor: 1,
                                style: styleModel
                                    .getTextStyle()['smallBodyTextStyle'],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
