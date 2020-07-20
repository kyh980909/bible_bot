import 'package:bible_bot/api/api.dart';
import 'package:bible_bot/models/style_model.dart';
import 'package:bible_bot/util/time.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import '../../../models/style_model.dart';

class StudyScreen extends StatefulWidget {
  @override
  _StudyScreenState createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  Future studyData;
  Future aggregateData;
  DateTime start;
  DateTime end;

  @override
  void initState() {
    studyData = getStudyData();
    aggregateData = getAggregateData();
    super.initState();
  }

  getStudyData() async {
    return Api().getStudyData();
  }

  getAggregateData() async {
    return Api().getAggregate();
  }

  @override
  Widget build(BuildContext context) {
    StyleModel styleModel = Provider.of<StyleModel>(context);
    String theme = Provider.of<String>(context);
    return DefaultTabController(
      length: 2,
      child: new Scaffold(
        body: new NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                floating: false,
                pinned: true,
                title: Text(
                  "이용내역",
                  style: styleModel.getTextStyle()['appBarTextStyle'],
                ),
                backgroundColor:
                    styleModel.getBackgroundColor()['backgroundColorLevel1'],
                leading: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: styleModel
                          .getBackgroundColor()['reversalColorLevel1']),
                  onPressed: () => Navigator.pop(context),
                ),
                brightness: styleModel.getBrightness()['appBarBrightness'],
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    tabs: [
                      new Tab(text: "스터디 출석 현황"),
                      new Tab(text: '전체 출입 데이터'),
                    ],
                    labelStyle: styleModel.getTextStyle()['bodyTitleTextStyle'],
                    unselectedLabelStyle:
                        styleModel.getTextStyle()['bodyTextStyle'],
                    indicatorColor:
                        styleModel.getBackgroundColor()['greenLevel1'],
                    indicatorWeight: 3.0,
                    labelColor:
                        styleModel.getBackgroundColor()['reversalColorLevel1'],
                    unselectedLabelColor:
                        styleModel.getBackgroundColor()['greyLevel2'],
                  ),
                  styleModel,
                ),
              )
            ];
          },
          body: TabBarView(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: double.infinity,
                child: FutureBuilder(
                  future: aggregateData,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Container(
                          color: styleModel
                              .getBackgroundColor()['backgroundColorLevel1'],
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      default:
                        if (snapshot.connectionState == ConnectionState.done) {
                          var log = snapshot.data;
                          var logStatus = log.status;
                          List logStudyLog = log.studyLog;
                          int totalMinute = log.totalSecond;
                          String secondToHour;
                          var splicedTime;
                          Time time = Time();
                          String hour;
                          String minute;
                          String second;

                          if (totalMinute > 0) {
                            secondToHour = time.secondToHour(totalMinute);
                            splicedTime = secondToHour.split(":");

                            hour = splicedTime[0];
                            minute = splicedTime[1];
                            second = splicedTime[2];
                          } else {
                            secondToHour = "";
                          }

                          if (start != null && end != null) {
                            logStudyLog = logStudyLog
                                .where((date) =>
                                    DateTime.parse(date['from'])
                                        .isAfter(start) &&
                                    DateTime.parse(date['from']).isBefore(end))
                                .toList();
                          }
                          if (logStatus) {
                            return Container(
                              color: styleModel.getBackgroundColor()[
                                  'backgroundColorLevel2'],
                              child: Column(
                                children: <Widget>[
                                  studyTotalTimeText(
                                      hour, minute, second, styleModel),
                                  studyLogListView(
                                      styleModel, time, logStudyLog),
                                ],
                              ),
                            );
                          } else {
                            return Container(
                              color: styleModel.getBackgroundColor()[
                                  'backgroundColorLevel1'],
                              alignment: Alignment.center,
                              child: Text(
                                "조회할 데이터가 없습니다.",
                                style: styleModel
                                    .getTextStyle()['subtitleTextStyle'],
                              ),
                            );
                          }
                        } else {
                          return Container(
                            color: styleModel
                                .getBackgroundColor()['backgroundColorLevel1'],
                            alignment: Alignment.center,
                            child: Text(
                              "조회할 데이터가 없습니다.",
                              style: styleModel
                                  .getTextStyle()['subtitleTextStyle'],
                            ),
                          );
                        }
                    }
                  },
                ),
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                child: FutureBuilder(
                  future: studyData,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Container(
                          color: styleModel
                              .getBackgroundColor()['backgroundColorLevel1'],
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      default:
                        if (snapshot.connectionState == ConnectionState.done) {
                          var log = snapshot.data;
                          List logStudyLog = log.studyLog;

                          if (start != null && end != null) {
                            logStudyLog = logStudyLog
                                .where((date) =>
                                    DateTime.parse(date['updated_datetime'])
                                        .isAfter(start) &&
                                    DateTime.parse(date['updated_datetime'])
                                        .isBefore(end))
                                .toList();
                          }
                          if (log.dataLength > 0) {
                            return Container(
                              color: styleModel.getBackgroundColor()[
                                  'backgroundColorLevel2'],
                              child: ListView.separated(
                                  padding: EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    String accessDataTime =
                                        logStudyLog[index]['access_datetime'];
                                    String updatedDateTime =
                                        logStudyLog[index]['updated_datetime'];
                                    int disabledAggregate = logStudyLog[index]
                                        ['disabled_aggregate'];
                                    String admin =
                                        logStudyLog[index]['admin_dept'];

                                    Text statusNotice = disabledAggregate == 0
                                        ? Text("정상처리",
                                            textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.blue[400],
                                                fontWeight: FontWeight.w400))
                                        : Text(
                                            "삭제처리",
                                            textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.deepOrange,
                                                fontWeight: FontWeight.w400),
                                          );

                                    return Container(
                                      height: styleModel.getContextSize()[
                                          'screenHeightLevel8.5'],
                                      child: Card(
                                        margin: EdgeInsets.only(
                                            left: 0,
                                            right: 0,
                                            top: 4,
                                            bottom: 0),
                                        elevation: 2,
                                        child: Container(
                                          color:
                                              styleModel.getBackgroundColor()[
                                                  'backgroundColorLevel1'],
                                          child: Column(
                                            children: <Widget>[
                                              Flexible(
                                                flex: 2,
                                                child: Container(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: styleModel
                                                            .getBackgroundColor()[
                                                        'backgroundColorLevel3'],
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Flexible(
                                                        flex: 1,
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 14.0),
                                                            child: statusNotice,
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        flex: 1,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            right: 14.0,
                                                          ),
                                                          child: Container(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: Text(
                                                                "갱신 $updatedDateTime",
                                                                textScaleFactor:
                                                                    0.9,
                                                                style: styleModel
                                                                        .getTextStyle()[
                                                                    'smallBodyTextStyle']),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 3,
                                                child: Container(
                                                    color: styleModel
                                                            .getBackgroundColor()[
                                                        'backgroundColorLevel1'],
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 14.0),
                                                        child: Text(
                                                          "$accessDataTime 출입",
                                                          style: styleModel
                                                                  .getTextStyle(
                                                                      fontSize:
                                                                          0.017)[
                                                              'bodyTextStyle'],
                                                          textScaleFactor: 0.9,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              Flexible(
                                                flex: 2,
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                    top: BorderSide(
                                                      color: styleModel
                                                              .getBackgroundColor()[
                                                          'greyLevel4'],
                                                    ),
                                                  )),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Flexible(
                                                        flex: 1,
                                                        child: Container(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 14.0),
                                                            child: Text(
                                                              '작성부서  ',
                                                              style: styleModel
                                                                      .getTextStyle(
                                                                          color:
                                                                              Colors.deepOrange[400])[
                                                                  'smallBodyTextStyle'],
                                                              textScaleFactor:
                                                                  1,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        flex: 1,
                                                        child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text('$admin',
                                                              textScaleFactor:
                                                                  1,
                                                              style: styleModel
                                                                      .getTextStyle()[
                                                                  'smallBodyTextStyle']),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                      height: 0,
                                      color: styleModel.getBackgroundColor()[
                                          'backgroundColorLevel1'],
                                    );
                                  },
                                  itemCount: logStudyLog.length),
                            );
                          } else {
                            return Container(
                              color: styleModel.getBackgroundColor()[
                                  'backgroundColorLevel1'],
                              alignment: Alignment.center,
                              child: Text(
                                "조회할 데이터가 없습니다.",
                                style: styleModel
                                    .getTextStyle()['subtitleTextStyle'],
                              ),
                            );
                          }
                        } else {
                          return Container(
                            color: styleModel
                                .getBackgroundColor()['backgroundColorLevel1'],
                            alignment: Alignment.center,
                            child: Text(
                              "조회할 데이터가 없습니다.",
                              style: styleModel
                                  .getTextStyle()['subtitleTextStyle'],
                            ),
                          );
                        }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Flexible studyLogListView(
      StyleModel styleModel, Time time, List logStudyLog) {
    return Flexible(
      flex: 12,
      child: ListView.separated(
          padding: EdgeInsets.all(0),
          itemBuilder: (context, index) {
            return Container(
              height: styleModel.getContextSize()['screenHeightLevel8'] + 10,
              child: Card(
                margin: EdgeInsets.only(left: 0, right: 0, top: 4, bottom: 0),
                elevation: 2,
                child: Container(
                  color:
                      styleModel.getBackgroundColor()['backgroundColorLevel1'],
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        flex: 5,
                        child: Container(
                            color: styleModel
                                .getBackgroundColor()['backgroundColorLevel1'],
                            alignment: Alignment.centerLeft,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    flex: 3,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                          border: Border(
                                        right: BorderSide(
                                          color:
                                              styleModel.getBackgroundColor()[
                                                  'greyLevel4'],
                                        ),
                                      )),
                                      child: Column(
                                        children: <Widget>[
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              alignment: Alignment.bottomCenter,
                                              child: Text(
                                                '인정시간  ',
                                                style:
                                                    styleModel.getTextStyle()[
                                                        'smallBodyTextStyle'],
                                                textScaleFactor: 1,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              alignment: Alignment.topCenter,
                                              child: Text(
                                                  '${time.secondToHour(logStudyLog[index]['seconds'])}',
                                                  textScaleFactor: 1,
                                                  style: styleModel
                                                          .getTextStyle()[
                                                      'bodyTitleTextStyle']),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20.0),
                                  Flexible(
                                    flex: 7,
                                    child: Column(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                color: styleModel
                                                        .getBackgroundColor()[
                                                    'greyLevel4'],
                                              )),
                                              color: styleModel
                                                      .getBackgroundColor()[
                                                  'backgroundColorLevel1'],
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Flexible(
                                                  flex: 1,
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "입실시간",
                                                      style: styleModel
                                                              .getTextStyle(
                                                                  color: Colors
                                                                          .blue[
                                                                      400])[
                                                          'subtitleTextStyle'],
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "${logStudyLog[index]['from']}",
                                                      style: styleModel
                                                              .getTextStyle()[
                                                          'bodyTitleTextStyle'],
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
                                            child: Column(
                                              children: <Widget>[
                                                Flexible(
                                                  flex: 1,
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "퇴실시간",
                                                      style: styleModel
                                                              .getTextStyle(
                                                                  color: Colors
                                                                      .deepOrange)[
                                                          'subtitleTextStyle'],
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "${logStudyLog[index]['to']}",
                                                      style: styleModel
                                                              .getTextStyle()[
                                                          'bodyTitleTextStyle'],
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
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 0,
              color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
            );
          },
          itemCount: logStudyLog.length),
    );
  }

  Flexible studyTotalTimeText(
      String hour, String minute, String second, StyleModel styleModel) {
    return Flexible(
      flex: 2,
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                daterangeContainer(styleModel, start ?? "날짜를 선택해주세요"),
                daterangeContainer(styleModel, end ?? "날짜를 선택해주세요")
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              "학습 인정 시간 $hour시 $minute분 $second초",
              style: styleModel.getTextStyle()['subtitleTextStyle'],
              textScaleFactor: 1,
            )
          ],
        ),
      ),
    );
  }

  Flexible daterangeContainer(StyleModel styleModel, dynamic date) {
    return Flexible(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: InkWell(
          onTap: () async {
            final List<DateTime> picked = await DateRagePicker.showDatePicker(
                context: context,
                initialFirstDate: new DateTime.now(),
                initialLastDate: new DateTime.now(),
                firstDate: new DateTime(2015),
                lastDate: new DateTime(9999));
            if (picked != null && picked.length == 2) {
              setState(() {
                start = picked[0];
                end = picked[1]
                    .add(Duration(hours: 23))
                    .add(Duration(minutes: 59));
              });
            }
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green[200]),
                borderRadius: BorderRadius.circular(5.0)),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 5.0, bottom: 5.0),
              child: Text(
                  date.runtimeType == String
                      ? "날짜를 선택해 주세요"
                      : DateFormat('M월 dd일 (E)', 'ko').format(date),
                  style: styleModel.getTextStyle()['bodyTitleTextStyle'],
                  textScaleFactor: 1),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar, this.styleModel);

  final TabBar _tabBar;
  final StyleModel styleModel;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
