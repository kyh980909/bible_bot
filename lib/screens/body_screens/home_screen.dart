import 'dart:async';
import 'dart:convert';
import 'package:bible_bot/models/chapel.dart';
import 'package:bible_bot/models/style_model.dart';
import 'package:bible_bot/provider/chapel.dart';
import 'package:bible_bot/provider/timetable.dart';
import 'package:bible_bot/screens/body_screens/home_screens/chapel.dart';
import 'package:bible_bot/screens/body_screens/home_screens/lecture.dart';
import 'package:bible_bot/screens/body_screens/home_screens/today_menu.dart';
import 'package:bible_bot/util/text_util.dart';
import 'package:bible_bot/widgets/width_division_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ChapelProvider _chapelProvider;
  double percent;
  List<Widget> _todayMenu = [
    TodayMenu(title: "LUNCH"),
    TodayMenu(title: "DINNER"),
    TodayMenu(title: "DAILY"),
    TodayMenu(title: "FIX")
  ];
  static var now = new DateTime.now();
  var chapelInquiryYear = DateFormat("yy").format(now);
  var chapelInquiryMonth = DateFormat("MM").format(now);

  @override
  Widget build(BuildContext context) {
    StyleModel styleModel = Provider.of<StyleModel>(context);
    String themeData = Provider.of<String>(context);

    final timetableData = Provider.of<TimetableProvider>(context);
    final chapelData = Provider.of<ChapelProvider>(context);

    _chapelProvider = chapelData;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: chapelData.isFetching
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : buildContainer(styleModel, _chapelProvider.getChapelData(),
                      context, themeData),
            ),
            WidthDivisionLine(),
            Flexible(
              flex: 5,
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Text(
                                "오늘의 학식",
                                style: styleModel
                                    .getTextStyle()['smallBodyTextStyle'],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: Swiper(
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                  padding: const EdgeInsets.only(bottom: 24.0),
                                  child: _todayMenu[index]);
                            },
                            itemCount: _todayMenu.length,
                            itemWidth: styleModel
                                .getContextSize()['screenWidthLevel3'],
                            viewportFraction: 0.8,
                            scale: 0.9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            WidthDivisionLine(),
            Flexible(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: timetableData.isFetching
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : timetableData.getTimetableData()[0] == true
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                        child: ClassLeftTime(
                                      classData:
                                          timetableData.getTimetableData()[1],
                                    )),
                                  )
                                : Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            timetableData.getTimetableData()[2],
                                            style: styleModel.getTextStyle()[
                                                'titleTextStyle'],
                                          ),
                                          SizedBox(height: 4.0),
                                          Text(
                                              timetableData
                                                  .getTimetableData()[3],
                                              style: styleModel.getTextStyle()[
                                                  'bodyTextStyle']),
                                          Center(
                                            child: IconButton(
                                              icon: Icon(Icons.refresh),
                                              onPressed: () {
                                                timetableData
                                                    .getTimetable(); // 새로고침
                                                // timetableData.getTimetableData();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
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
    );
  }

  Container buildContainer(StyleModel styleModel, Map<String, dynamic> data,
      BuildContext context, String themeData) {
    if (data['result']) {
      String year = data['select'].selected.substring(2, 4);
      String semester = data['select'].selected[4];
      Summary chapelSummary = data['summary'];

      if (int.parse(chapelSummary.dayOfRule) > 0) {
        percent = int.parse(chapelSummary.confirm) /
                    int.parse(chapelSummary.dayOfRule) >
                1
            ? 1
            : int.parse(chapelSummary.confirm) /
                int.parse(chapelSummary.dayOfRule);
      } else {
        percent = 0.0;
      }

      return Container(
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Text(
                    "채플 ($year-$semester학기)",
                    overflow: TextOverflow.ellipsis,
                    style: styleModel.getTextStyle()['smallBodyTextStyle'],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: LinearPercentIndicator(
                          animation: true,
                          lineHeight: 20.0,
                          animationDuration: 100,
                          percent: percent,
                          center: Text(
                            "${chapelSummary.confirm} / ${chapelSummary.dayOfRule} ",
                            overflow: TextOverflow.ellipsis,
                            style:
                                styleModel.getTextStyle()['smallBodyTextStyle'],
                          ),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: Colors.green[200],
                          backgroundColor:
                              styleModel.getBackgroundColor()['greyLevel4'],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          highlightElevation: 0,
                          highlightColor:
                              styleModel.getBackgroundColor()['highLightColor'],
                          focusElevation: 0,
                          elevation: 0,
                          splashColor:
                              styleModel.getBackgroundColor()['splashColor'],
                          color: Colors.transparent,
                          onPressed: () {
                            Navigator.of(context).push(
                              new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    MultiProvider(providers: [
                                  Provider<StyleModel>.value(
                                      value: StyleModel(context,
                                          currentTheme: themeData)),
                                  Provider<String>.value(value: themeData),
                                ], child: ChapelScreen()),
                              ),
                            );
                          },
                          child: Row(children: <Widget>[
                            Flexible(
                              flex: 5,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "",
                                  overflow: TextOverflow.ellipsis,
                                  style: styleModel
                                      .getTextStyle()['smallBodyTextStyle'],
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
                          ]),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Text('${json.decode(data['err'])['error']['title']}'),
            ),
            Flexible(
              flex: 1,
              child: IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: styleModel.getIconColor()['themeIconColor'],
                ),
                onPressed: () {
                  _chapelProvider.getChapel();
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}

class ClassLeftTime extends StatefulWidget {
  final Map<String, dynamic> classData;

  ClassLeftTime({Key key, @required this.classData}) : super(key: key);

  @override
  _ClassLeftTimeState createState() => _ClassLeftTimeState();
}

class _ClassLeftTimeState extends State<ClassLeftTime>
    with WidgetsBindingObserver {
  int leftTime = 0; // 남은 시간
  bool noClass = true; // 공강일때
  String msg = '';
  String currentClassName = '';
  double percentage;
  Timer timer;
  int status; // 현재 상태
  int classLength; // 당일 수업 개수

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    updateTime(); // 남은시간 바로 띄어주기
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => updateTime());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timer.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      timer.cancel();
      // went to Background
    }
    if (state == AppLifecycleState.resumed) {
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) => updateTime());
      // came back to Foreground
    }
  }

  void updateTime() {
    DateFormat df = DateFormat.Hms();
    int todayClass;
    Map<String, dynamic> classData = widget.classData;
    List currentClass;

    switch (DateTime.now().weekday) {
      case DateTime.monday:
        todayClass = 0;
        break;
      case DateTime.tuesday:
        todayClass = 1;
        break;
      case DateTime.wednesday:
        todayClass = 2;
        break;
      case DateTime.thursday:
        todayClass = 3;
        break;
      case DateTime.friday:
        todayClass = 4;
        break;
      default:
        todayClass = null;
        break;
    }
    if (todayClass == null) {
      status = 3;
      msg = '주말 입니다 :D';
    } else {
      currentClass = classData[dayEng[todayClass]];
      currentClass.isEmpty ? noClass = true : noClass = false; // 공강 체크
      if (!noClass) {
        int nextClass = utilTime.hourToSecond(currentClass[0][2]);
        int currentTime = utilTime.hourToSecond(df.format(DateTime.now()));
        int lastClass = utilTime
            .hourToSecond(currentClass[currentClass.length - 1][3]); // 수업 끝난 시간
        int breakTime;
        if (currentTime >= lastClass) {
          status = 3;
        } else {
          classLength = currentClass.length;
          currentTime = utilTime.hourToSecond(df.format(DateTime.now()));
          int index = 0;
          for (var lecture in currentClass) {
            if (currentTime < utilTime.hourToSecond(lecture[2]) + 1) {
              // 수업전
              status = 1;
              nextClass = utilTime.hourToSecond(lecture[2]);
              leftTime = nextClass - currentTime;
              currentClassName = lecture[0];
              if (index == 0) {
                percentage = (nextClass - leftTime) / nextClass;
              } else {
                breakTime = utilTime.minuteToSecond(currentClass[index - 1][5]);
                percentage = (breakTime - leftTime) / breakTime;
              }
              break;
            } else if (currentTime > utilTime.hourToSecond(lecture[2]) &&
                currentTime < utilTime.hourToSecond(lecture[3])) {
              // 수업중
              status = 2;
              nextClass = utilTime.hourToSecond(lecture[3]);
              leftTime = nextClass - currentTime;
              currentClassName = lecture[0];
              break;
            }
            index++;
          }
        }
        if (mounted) {
          setState(() {
            switch (status) {
              case 1:
                msg = utilTime.secondToHour(leftTime);
                break;
              case 2:
                msg = utilTime.secondToHour(leftTime);
                break;
              case 3:
                msg = '오늘도 수고 많았어요 :D';
                break;
            }
          });
        }
      } else {
        status = 3;
        msg = '오늘은 수업이 없습니다!';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final styleModel = Provider.of<StyleModel>(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: 20,
      child: status == 2
          ? Column(
              children: <Widget>[
                statusMsgContainer(styleModel, size),
                Expanded(
                  child: Image.asset(
                    'images/study.gif',
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ],
            )
          : status == 1
              ? runningMan(styleModel, size)
              : Column(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                    Flexible(
                      flex: 3,
                      child: Image.asset(
                        'images/end.gif',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          msg,
                          style:
                              styleModel.getTextStyle()['bodyTitleTextStyle'],
                        ),
                      ),
                    )
                  ],
                ),
    );
  }

  Column sign(StyleModel styleModel, Size size) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 0.5,
                height: size.height * 0.02,
                color: styleModel.getBackgroundColor()['reversalColorLevel1']),
            SizedBox(width: 30),
            Container(
                width: 0.5,
                height: size.height * 0.02,
                color: styleModel.getBackgroundColor()['reversalColorLevel1']),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(width: 5, height: 3, color: Colors.grey),
            SizedBox(width: 25),
            Container(width: 5, height: 3, color: Colors.grey),
          ],
        ),
        Container(
          height: size.height * 0.04,
          width: textDynamicSize(currentClassName, size.height),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: Colors.green[200],
          ),
          child: Text(
            currentClassName,
            textScaleFactor: 1.1,
            style:
                styleModel.getTextStyle(color: Colors.white)['bodyTextStyle'],
          ),
        ),
      ],
    );
  }

  Column runningMan(StyleModel styleModel, Size size) {
    return Column(
      children: <Widget>[
        Container(
          child: statusMsgContainer(styleModel, size),
        ),
        Expanded(
          child: Image.asset(
            'images/hodadak.gif',
            fit: BoxFit.fitHeight,
          ),
        ),
      ],
    );
  }

  Column statusMsgContainer(StyleModel styleModel, Size size) {
    return Column(
      children: <Widget>[
        sign(styleModel, size),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(status == 1 ? '시작까지' : '종료까지',
                style: styleModel.getTextStyle(
                    fontWeight: FontWeight.normal)['bodyTextStyle']),
            SizedBox(width: 10.0),
            Text(
              msg,
              style: styleModel.getTextStyle(
                  fontSize: 0.04, fontWeight: FontWeight.w100)['bodyTextStyle'],
            ),
            SizedBox(width: 10.0),
            Text('남았어요',
                style: styleModel.getTextStyle(
                    fontWeight: FontWeight.normal)['bodyTextStyle'])
          ],
        ),
      ],
    );
  }
}
