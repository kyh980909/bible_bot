import 'package:bible_bot/models/style_model.dart';
import 'package:bible_bot/screens/body_screens/home_screens/campus_map.dart';
import 'package:bible_bot/screens/body_screens/home_screens/schedule.dart';
import 'package:bible_bot/screens/body_screens/home_screens/school_news.dart';
import 'package:bible_bot/screens/body_screens/home_screens/today_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class NonMemberScreen extends StatefulWidget {
  @override
  _NonMemberScreenState createState() => _NonMemberScreenState();
}

class _NonMemberScreenState extends State<NonMemberScreen> {
  final timeStamp = new DateTime.now().millisecondsSinceEpoch;

  List<Widget> _todayMenu = [
    TodayMenu(
      title: "LUNCH",
    ),
    TodayMenu(title: "DINNER"),
    TodayMenu(title: "DAILY"),
    TodayMenu(title: "FIX")
  ];

  Future getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return '현재버전: ${packageInfo.version}';
  }

  @override
  Widget build(BuildContext context) {
    StyleModel styleModel = Provider.of<StyleModel>(context);
    String themeData = Provider.of<String>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('비회원페이지',
            style: styleModel.getTextStyle()['subtitleTextStyle'],
            overflow: TextOverflow.ellipsis),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: styleModel.getBackgroundColor()['reversalColorLevel1']),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        brightness: styleModel.getBrightness()['appBarBrightness'],
        backgroundColor:
            styleModel.getBackgroundColor()['backgroundColorLevel1'],
      ),
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        color: styleModel.getBackgroundColor()['backgroundColorLevel2'],
        child: Column(
          children: <Widget>[
            Container(
              height: 30.0,
            ),
            Flexible(
              flex: 2,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Text(
                            "오늘의 학식",
                            style: styleModel.getTextStyle()['bodyTextStyle'],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: _todayMenu[index]);
                        },
                        itemCount: _todayMenu.length,
                        itemWidth:
                            styleModel.getContextSize()['screenWidthLevel3'],
                        viewportFraction: 0.8,
                        scale: 0.9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(height: 10.0),
            Flexible(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: RaisedButton(
                        highlightElevation: 0,
                        highlightColor:
                            styleModel.getBackgroundColor()['highLightColor'],
                        focusElevation: 0,
                        elevation: 0,
                        splashColor:
                            styleModel.getBackgroundColor()['splashColor'],
                        color: styleModel.getBackgroundColor()['greyLevel6'],
                        onPressed: () {
                          Navigator.of(context).push(
                            new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MultiProvider(providers: [
                                Provider<StyleModel>.value(
                                    value: StyleModel(context,
                                        currentTheme: themeData)),
                                Provider<String>.value(value: themeData),
                              ], child: SchoolNewsScreen()),
                            ),
                          );
                        },
                        child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  flex: 3,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "공지사항",
                                      overflow: TextOverflow.ellipsis,
                                      style: styleModel
                                          .getTextStyle()['bodyTextStyle'],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: styleModel
                                          .getIconColor()['themeIconColor'],
                                      size: styleModel
                                          .getContextSize()['smallIconSize'],
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: RaisedButton(
                        highlightElevation: 0,
                        highlightColor:
                            styleModel.getBackgroundColor()['highLightColor'],
                        focusElevation: 0,
                        elevation: 0,
                        splashColor:
                            styleModel.getBackgroundColor()['splashColor'],
                        color: styleModel.getBackgroundColor()['greyLevel8'],
                        onPressed: () {
                          Navigator.of(context).push(
                            new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MultiProvider(providers: [
                                Provider<StyleModel>.value(
                                    value: StyleModel(context,
                                        currentTheme: themeData)),
                                Provider<String>.value(value: themeData),
                              ], child: Schedule()),
                            ),
                          );
                        },
                        child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  flex: 3,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "학사일정",
                                      overflow: TextOverflow.ellipsis,
                                      style: styleModel
                                          .getTextStyle()['bodyTextStyle'],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: styleModel
                                          .getIconColor()['themeIconColor'],
                                      size: styleModel
                                          .getContextSize()['smallIconSize'],
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: RaisedButton(
                        highlightElevation: 0,
                        highlightColor:
                            styleModel.getBackgroundColor()['highLightColor'],
                        focusElevation: 0,
                        elevation: 0,
                        splashColor:
                            styleModel.getBackgroundColor()['splashColor'],
                        color: styleModel.getBackgroundColor()['greyLevel6'],
                        onPressed: () {
                          Navigator.of(context).push(
                            new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MultiProvider(providers: [
                                Provider<StyleModel>.value(
                                    value: StyleModel(context,
                                        currentTheme: themeData)),
                                Provider<String>.value(value: themeData),
                              ], child: CampusMapScreen()),
                            ),
                          );
                        },
                        child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  flex: 3,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "캠퍼스맵",
                                      overflow: TextOverflow.ellipsis,
                                      style: styleModel
                                          .getTextStyle()['bodyTextStyle'],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: styleModel
                                          .getIconColor()['themeIconColor'],
                                      size: styleModel
                                          .getContextSize()['smallIconSize'],
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FutureBuilder(
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
                          ],
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
