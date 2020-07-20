// import 'package:bible_bot/communications/user_information.dart';
import 'dart:convert';

import 'package:bible_bot/api/api.dart';
import 'package:bible_bot/models/style_model.dart';
import 'package:bible_bot/provider/chapel.dart';
import 'package:bible_bot/screens/body_screens/home_screen.dart';
import 'package:bible_bot/screens/body_screens/home_screens/lecture.dart';
import 'package:bible_bot/screens/body_screens/home_screens/mobile_id_card.dart';
import 'package:bible_bot/screens/body_screens/home_screens/see_more_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class InitialScreen extends StatefulWidget {
  static bool displayIsLock = false;

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  int _selectedIndex = 0;
  static var themeData;
  String appBarTitleText = "성서봇";
  List<dynamic> usablePlace;
  ChapelProvider _chapelProvider;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        setState(() {
          appBarTitleText = "성서봇";
        });
        break;
      case 1:
        setState(() {
          appBarTitleText = "모바일 학생증";
        });
        break;
      case 2:
        setState(() {
          appBarTitleText = "수업";
        });
        break;
      case 3:
        setState(() {
          appBarTitleText = "더보기";
        });
        break;
    }
  }

  // 네비게이션 스크린
  final List<Widget> _bodyScreens = [
    HomeScreen(),
    MobileIdCard(),
    LectureScreen(),
    SeeMoreScreen(),
  ];

  Future getUsable() async {
    var result = await Api().getUsable();
    if (result['result']) {
      usablePlace = json.decode(result['data'])['data']['data'];
    } else {
      usablePlace = (json.decode(result['err'])['error']['title']);
    }
  }

  @override
  void initState() {
    getUsable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final styleModel = Provider.of<StyleModel>(context);
    themeData = Provider.of<String>(context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: styleModel.getBackgroundColor()['greyLevel9'],
        systemNavigationBarIconBrightness:
            styleModel.getBrightness()['statusIconBrightness'],
        statusBarIconBrightness:
            styleModel.getBrightness()['statusIconBrightness'],
        statusBarColor:
            styleModel.getBackgroundColor()['backgroundColorLevel1']));

    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor:
                    styleModel.getBackgroundColor()['backgroundColorLevel2'],
                title: Text(
                  "알림",
                  style: styleModel.getTextStyle()['bodyTextStyle'],
                ),
                content: Text(
                  "어플을 종료하시겠습니까?",
                  style: styleModel.getTextStyle()['smallBodyTextStyle'],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("YES",
                        style: styleModel.getTextStyle()['smallBodyTextStyle']),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                  FlatButton(
                    child: Text("NO",
                        style: styleModel.getTextStyle()['smallBodyTextStyle']),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          brightness: styleModel.getBrightness()['appBarBrightness'],
          // 추가해줘야 statusBar 정상표시
          backgroundColor:
              styleModel.getBackgroundColor()['backgroundColorLevel1'],
          title: new Text(
            appBarTitleText,
            style: styleModel.getTextStyle()['appBarTextStyle'],
          ),
          elevation: 0,

          actions: appBarTitleText == '모바일 학생증'
              ? <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.info,
                      color: styleModel.getIconColor()['themeIconColor'],
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: styleModel
                                .getBackgroundColor()['backgroundColorLevel2'],
                            title: Text('모바일 학생증 사용가능처',
                                style: styleModel
                                    .getTextStyle()['bodyTitleTextStyle']),
                            content: Container(
                              width: styleModel
                                  .getContextSize()['screenWidthLevel9'],
                              height: styleModel
                                  .getContextSize()['screenHeightLevel9'],
                              child: ListView.builder(
                                  itemCount: usablePlace.length,
                                  itemBuilder: (context, index) {
                                    return Text(usablePlace[index],
                                        style: styleModel.getTextStyle(
                                            fontWeight: FontWeight
                                                .normal)['bodyTextStyle']);
                                  }),
                            ),
                          );
                        },
                      );
                    },
                  )
                ]
              : null,
        ),
        body: _bodyScreens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: styleModel.getBackgroundColor()['greyLevel9'],
          selectedLabelStyle: styleModel.getTextStyle()['smallBodyTextStyle'],
          unselectedLabelStyle: styleModel.getTextStyle()['smallBodyTextStyle'],
          unselectedItemColor: styleModel.getBackgroundColor()['greyLevel1'],
          selectedItemColor:
              styleModel.getBackgroundColor()['reversalColorLevel1'],
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: new Icon(
                  Icons.home,
                  size: styleModel.getContextSize()['bigIconSize'],
                ),
              ),
              title: new Text('', overflow: TextOverflow.ellipsis),
            ),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Icon(
                    Icons.assignment_ind,
                    size: styleModel.getContextSize()['bigIconSize'],
                  ),
                ),
                title: new Text('', overflow: TextOverflow.ellipsis)),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Icon(
                  Icons.event_note,
                  size: styleModel.getContextSize()['bigIconSize'],
                ),
              ),
              title: new Text('', overflow: TextOverflow.ellipsis),
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Icon(
                  Icons.more_horiz,
                  size: styleModel.getContextSize()['bigIconSize'],
                ),
              ),
              title: new Text('', overflow: TextOverflow.ellipsis),
            ),
          ],
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
        ),
      ),
    );
  }
}
