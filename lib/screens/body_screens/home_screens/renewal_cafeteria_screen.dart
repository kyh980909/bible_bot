import 'package:bible_bot/communications/request.dart';
import 'package:bible_bot/util/day_of_week.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/style_model.dart';
import '../../../widgets/width_division_line.dart';

class RenewalCafeteria extends StatefulWidget {
  @override
  _RenewalCafeteriaState createState() => _RenewalCafeteriaState();
}

class _RenewalCafeteriaState extends State<RenewalCafeteria> {
  static var now = new DateTime.now();
  var today = DateFormat("yyyy-MM-dd").format(now); // 소수점
  var day = DateFormat("MM월 dd").format(now);
  String dayOfWeek = getDayOfWeek(now.weekday);
  DateTime todayMenu;
  var timeStamp = now.millisecondsSinceEpoch;
  @override
  Widget build(BuildContext context) {

    final styleModel = Provider.of<StyleModel>(context);
    return DefaultTabController(
      length: 2,
      child: new Scaffold(
        body: new NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                automaticallyImplyLeading: true,
                backgroundColor:
                    styleModel.getBackgroundColor()['backgroundColorLevel1'],
                leading: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: styleModel
                          .getBackgroundColor()['reversalColorLevel1']),
                  onPressed: () => Navigator.pop(context),
                ),
                brightness: styleModel.getBrightness()['appBarBrightness'],
                title: Text("학생식당",
                    style: styleModel.getTextStyle()['appBarTextStyle'],
                    overflow: TextOverflow.ellipsis),
                floating: true,
                pinned: true,
                snap: true,
                bottom: TabBar(
                    labelColor:styleModel.getBackgroundColor()['reversalColorLevel1'],
                    unselectedLabelColor:
                        styleModel.getBackgroundColor()['greyLevel2'],
                    unselectedLabelStyle:
                        styleModel.getTextStyle()['bodyTitleTextStyle'],
                    labelStyle: styleModel.getTextStyle()['bodyTitleTextStyle'],
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "식 단",
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text("정 보"),
                        ),
                      ),
                    ]),
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
              Container(
                color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
                child: FutureBuilder(
                    future: Request().getTodayCafeteriaMenu(timeStamp),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Stack(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Card(
                                    color: styleModel.getBackgroundColor()[
                                        'backgroundColorLevel1'],
                                    margin: EdgeInsets.only(top: 1.0),
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 2.0,
                                    child: Container(
                                      height: styleModel.getContextSize()[
                                          'screenHeightLevel10'],
                                      child: Row(
                                        children: <Widget>[
                                          // 왼쪽 화살표
                                          Flexible(
                                            flex: 1,
                                            child: RaisedButton(
                                              highlightElevation: 0,
                                              highlightColor: styleModel
                                                      .getBackgroundColor()[
                                                  'highLightColor'],
                                              focusElevation: 0,
                                              elevation: 0,
                                              splashColor: styleModel
                                                      .getBackgroundColor()[
                                                  'splashColor'],
                                              color: Colors.transparent,
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                child: Icon(
                                                  Icons.arrow_back_ios,
                                                  color: styleModel
                                                          .getBackgroundColor()[
                                                      'reversalColorLevel2'],
                                                ),
                                              ),
                                              onPressed: () async {
                                                setState(() {

                                                  todayMenu =
                                                      DateTime.parse(today).add(
                                                          Duration(days: -1));
                                                  dayOfWeek = getDayOfWeek(
                                                      todayMenu.weekday);
                                                  today =
                                                      DateFormat("yyyy-MM-dd")
                                                          .format(todayMenu);
                                                  day = DateFormat("MM월 dd")
                                                      .format(todayMenu);
                                                  timeStamp = todayMenu.millisecondsSinceEpoch;
                                                });
                                              },
                                            ),
                                          ),
                                          // 센터 출력
                                          Flexible(
                                            flex: 3,
                                            child: Center(
                                              child: Text(
                                                "$day일 ($dayOfWeek)",
                                                style:
                                                    styleModel.getTextStyle()[
                                                        'subtitleTextStyle'],
                                              ),
                                            ),
                                          ),
                                          // 오른쪽 화살
                                          Flexible(
                                            flex: 1,
                                            child: RaisedButton(
                                              highlightElevation: 0,
                                              highlightColor: styleModel
                                                      .getBackgroundColor()[
                                                  'highLightColor'],
                                              focusElevation: 0,
                                              elevation: 0,
                                              splashColor: styleModel
                                                      .getBackgroundColor()[
                                                  'splashColor'],
                                              color: Colors.transparent,
                                              child: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: styleModel
                                                          .getBackgroundColor()[
                                                      'reversalColorLevel2'],
                                                ),
                                              ),
                                              onPressed: () async {
                                                setState(() {
                                                  todayMenu =
                                                      DateTime.parse(today).add(
                                                          Duration(days: 1));
                                                  dayOfWeek = getDayOfWeek(
                                                      todayMenu.weekday);
                                                  today =
                                                      DateFormat("yyyy-MM-dd")
                                                          .format(todayMenu);
                                                  day = DateFormat("MM월 dd")
                                                      .format(todayMenu);
                                                  timeStamp = todayMenu.millisecondsSinceEpoch;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 3.0,
                                    color: styleModel
                                        .getBackgroundColor()['greyLevel5'],
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Card(
                                      color: styleModel.getBackgroundColor()[
                                          'backgroundColorLevel1'],
                                      margin: EdgeInsets.zero,
                                      clipBehavior: Clip.antiAlias,
                                      elevation: 2.0,
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            // 메인 타이틀
                                            Flexible(
                                              flex: 5,
                                              child: Column(
                                                children: <Widget>[
                                                  Flexible(
                                                    flex: 1,
                                                    child: Container(
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 24.0),
                                                          child: Text(
                                                            "메인메뉴",
                                                            style: styleModel
                                                                    .getTextStyle()[
                                                                'titleTextStyle'],
                                                          ),
                                                        )),
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Flexible(
                                                            flex: 1,
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Icon(
                                                                Icons
                                                                    .priority_high,
                                                                size: styleModel
                                                                        .getContextSize()[
                                                                    'middleIconSize'],
                                                                color: Colors
                                                                    .redAccent,
                                                              ),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: 8,
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0),
                                                                child: Text(
                                                                  "재고 소진시 판매하지 않을 수 있습니다.",
                                                                  style: styleModel
                                                                          .getTextStyle()[
                                                                      'smallBodyTextStyle'],
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            WidthDivisionLine(),
                                            // 중식
                                            Flexible(
                                              flex: 4,
                                              child: Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Flexible(
                                                      flex: 1,
                                                      child: Container(),
                                                    ),
                                                    Flexible(
                                                        flex: 7,
                                                        child: Column(
                                                          children: <Widget>[
                                                            Flexible(
                                                              flex: 1,
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Flexible(
                                                                    flex: 4,
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(left: 14.0),
                                                                        child:
                                                                            Text(
                                                                          "",
                                                                          style:
                                                                              styleModel.getTextStyle()['subtitleTextStyle'],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Flexible(
                                                                    flex: 1,
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(right: 8.0),
                                                                        child:
                                                                            Text(
                                                                          "",
                                                                          style:
                                                                              styleModel.getTextStyle(color: Colors.grey)['bodyTextStyle'],
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
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          14.0),
                                                                  child: Text(
                                                                    "",
                                                                    style: styleModel
                                                                        .getTextStyle(
                                                                            color:
                                                                                Colors.grey)['bodyTextStyle'],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            WidthDivisionLine(),
                                            // 석식
                                            Flexible(
                                              flex: 4,
                                              child: Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Flexible(
                                                      flex: 1,
                                                      child: Container(),
                                                    ),
                                                    Flexible(
                                                        flex: 7,
                                                        child: Column(
                                                          children: <Widget>[
                                                            Flexible(
                                                              flex: 1,
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Flexible(
                                                                    flex: 4,
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(left: 14.0),
                                                                        child:
                                                                            Text(
                                                                          "",
                                                                          style:
                                                                              styleModel.getTextStyle()['subtitleTextStyle'],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Flexible(
                                                                    flex: 1,
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(right: 8.0),
                                                                        child:
                                                                            Text(
                                                                          "",
                                                                          style:
                                                                              styleModel.getTextStyle(color: Colors.grey)['bodyTextStyle'],
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
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          14.0),
                                                                  child: Text(
                                                                    "",
                                                                    style: styleModel
                                                                        .getTextStyle(
                                                                            color:
                                                                                Colors.grey)['bodyTextStyle'],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 5.0,
                                    color: styleModel
                                        .getBackgroundColor()['greyLevel5'],
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Card(
                                      color: styleModel.getBackgroundColor()[
                                          'backgroundColorLevel1'],
                                      margin: EdgeInsets.zero,
                                      clipBehavior: Clip.antiAlias,
                                      elevation: 2.0,
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            // 메인 타이틀
                                            Flexible(
                                              flex: 5,
                                              child: Column(
                                                children: <Widget>[
                                                  Flexible(
                                                    flex: 1,
                                                    child: Container(
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 24.0),
                                                          child: Text(
                                                            "사이드메뉴",
                                                            style: styleModel
                                                                    .getTextStyle()[
                                                                'titleTextStyle'],
                                                          ),
                                                        )),
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Flexible(
                                                            flex: 1,
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Icon(
                                                                Icons
                                                                    .priority_high,
                                                                size: styleModel
                                                                        .getContextSize()[
                                                                    'middleIconSize'],
                                                                color: Colors
                                                                    .redAccent,
                                                              ),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: 8,
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0),
                                                                child: Text(
                                                                  "재고 소진시 판매하지 않을 수 있습니다.",
                                                                  style: styleModel
                                                                          .getTextStyle()[
                                                                      'smallBodyTextStyle'],
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            WidthDivisionLine(),
                                            // 데일리 메뉴
                                            Flexible(
                                              flex: 4,
                                              child: Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Flexible(
                                                      flex: 1,
                                                      child: Container(),
                                                    ),
                                                    Flexible(
                                                        flex: 7,
                                                        child: Column(
                                                          children: <Widget>[
                                                            Flexible(
                                                              flex: 1,
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Flexible(
                                                                    flex: 4,
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(left: 14.0),
                                                                        child:
                                                                            Text(
                                                                          "",
                                                                          style:
                                                                              styleModel.getTextStyle()['subtitleTextStyle'],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Flexible(
                                                                    flex: 1,
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(right: 8.0),
                                                                        child:
                                                                            Text(
                                                                          "",
                                                                          style:
                                                                              styleModel.getTextStyle(color: Colors.grey)['bodyTextStyle'],
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
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          14.0),
                                                                  child: Text(
                                                                    "",
                                                                    style: styleModel
                                                                        .getTextStyle(
                                                                            color:
                                                                                Colors.grey)['bodyTextStyle'],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            WidthDivisionLine(),
                                            // 석식
                                            Flexible(
                                              flex: 4,
                                              child: Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Flexible(
                                                      flex: 1,
                                                      child: Container(),
                                                    ),
                                                    Flexible(
                                                        flex: 7,
                                                        child: Column(
                                                          children: <Widget>[
                                                            Flexible(
                                                              flex: 1,
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Flexible(
                                                                    flex: 4,
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(left: 14.0),
                                                                        child:
                                                                            Text(
                                                                          "",
                                                                          style:
                                                                              styleModel.getTextStyle()['subtitleTextStyle'],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Flexible(
                                                                    flex: 1,
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(right: 8.0),
                                                                        child:
                                                                            Text(
                                                                          "",
                                                                          style:
                                                                              styleModel.getTextStyle(color: Colors.grey)['bodyTextStyle'],
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
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          14.0),
                                                                  child: Text(
                                                                    "",
                                                                    style: styleModel
                                                                        .getTextStyle(
                                                                            color:
                                                                                Colors.grey)['bodyTextStyle'],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                color: Colors.black26,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ],
                          );
                        default:
                          var cafeteriaMenu = snapshot.data;
                          var lunchPrices = cafeteriaMenu.lunchPrice;
                          var dinnerPrices = cafeteriaMenu.dinnerPrice;



                          return Column(
                            children: <Widget>[
                              Card(
                                color: styleModel.getBackgroundColor()[
                                    'backgroundColorLevel1'],
                                margin: EdgeInsets.only(top: 1.0),
                                clipBehavior: Clip.antiAlias,
                                elevation: 2.0,
                                child: Container(
                                  height: styleModel
                                      .getContextSize()['screenHeightLevel10'],
                                  child: Row(
                                    children: <Widget>[
                                      // 왼쪽 화살표
                                      Flexible(
                                        flex: 1,
                                        child: RaisedButton(
                                          highlightElevation: 0,
                                          highlightColor:
                                              styleModel.getBackgroundColor()[
                                                  'highLightColor'],
                                          focusElevation: 0,
                                          elevation: 0,
                                          splashColor:
                                              styleModel.getBackgroundColor()[
                                                  'splashColor'],
                                          color: Colors.transparent,
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Icon(
                                              Icons.arrow_back_ios,
                                              color: styleModel
                                                      .getBackgroundColor()[
                                                  'reversalColorLevel2'],
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              now = now.add(Duration(days:-1));
                                              todayMenu = DateTime.parse(today)
                                                  .add(Duration(days: -1));
                                              dayOfWeek = getDayOfWeek(
                                                  todayMenu.weekday);
                                              today = DateFormat("yyyy-MM-dd")
                                                  .format(todayMenu);
                                              day = DateFormat("MM월 dd")
                                                  .format(todayMenu);
                                              timeStamp = now.millisecondsSinceEpoch;
                                            });
                                          },
                                        ),
                                      ),
                                      // 센터 출력
                                      Flexible(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                            "$day일 ($dayOfWeek)",
                                            style: styleModel.getTextStyle()[
                                                'subtitleTextStyle'],
                                          ),
                                        ),
                                      ),
                                      // 오른쪽 화살
                                      Flexible(
                                        flex: 1,
                                        child: RaisedButton(
                                          highlightElevation: 0,
                                          highlightColor:
                                              styleModel.getBackgroundColor()[
                                                  'highLightColor'],
                                          focusElevation: 0,
                                          elevation: 0,
                                          splashColor:
                                              styleModel.getBackgroundColor()[
                                                  'splashColor'],
                                          color: Colors.transparent,
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: styleModel
                                                      .getBackgroundColor()[
                                                  'reversalColorLevel2'],
                                            ),
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              now = now.add(Duration(days:1));
                                              todayMenu = DateTime.parse(today)
                                                  .add(Duration(days: 1));
                                              dayOfWeek = getDayOfWeek(
                                                  todayMenu.weekday);
                                              today = DateFormat("yyyy-MM-dd")
                                                  .format(todayMenu);
                                              day = DateFormat("MM월 dd")
                                                  .format(todayMenu);
                                              timeStamp = now.millisecondsSinceEpoch;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 3.0,
                                color: styleModel
                                    .getBackgroundColor()['greyLevel5'],
                              ),
                              Flexible(
                                flex: 1,
                                child: Card(
                                  color: styleModel.getBackgroundColor()[
                                      'backgroundColorLevel1'],
                                  margin: EdgeInsets.zero,
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 2.0,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        // 메인 타이틀
                                        Flexible(
                                          flex: 5,
                                          child: Column(
                                            children: <Widget>[
                                              Flexible(
                                                flex: 1,
                                                child: Container(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 24.0),
                                                      child: Text(
                                                        "메인메뉴",
                                                        style: styleModel
                                                                .getTextStyle()[
                                                            'titleTextStyle'],
                                                      ),
                                                    )),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Flexible(
                                                        flex: 1,
                                                        child: Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Icon(
                                                            Icons.priority_high,
                                                            size: styleModel
                                                                    .getContextSize()[
                                                                'middleIconSize'],
                                                            color: Colors
                                                                .redAccent,
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        flex: 8,
                                                        child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0),
                                                            child: Text(
                                                              "재고 소진시 판매하지 않을 수 있습니다.",
                                                              style: styleModel
                                                                      .getTextStyle()[
                                                                  'smallBodyTextStyle'],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        WidthDivisionLine(),
                                        // 중식
                                        Flexible(
                                          flex: 4,
                                          child: Container(
                                            child: Row(
                                              children: <Widget>[
                                                Flexible(
                                                  flex: 1,
                                                  child: Container(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 14.0),
                                                      child: Image.asset(
                                                          "images/cafeteria_lunch.png",
                                                          width: styleModel
                                                                  .getContextSize()[
                                                              'bigIconSize']),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                    flex: 7,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Flexible(
                                                          flex: 1,
                                                          child: Row(
                                                            children: <Widget>[
                                                              Flexible(
                                                                flex: 4,
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            14.0),
                                                                    child: Text(
                                                                      "${cafeteriaMenu.lunch['menus'].length > 1 ? cafeteriaMenu.lunch['menus'][1] : cafeteriaMenu.lunch['menus'].join(',')}",
                                                                      style: styleModel
                                                                              .getTextStyle()[
                                                                          'subtitleTextStyle'],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Flexible(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            8.0),
                                                                    child: Text(
                                                                      "",
                                                                      style: styleModel.getTextStyle(
                                                                          color:
                                                                              Colors.grey)['bodyTextStyle'],
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
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          14.0),
                                                              child: Text(
                                                                "${cafeteriaMenu.lunch['menus'].join(',')}",
                                                                style: styleModel
                                                                        .getTextStyle(
                                                                            color:
                                                                                Colors.grey)[
                                                                    'bodyTextStyle'],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                        WidthDivisionLine(),
                                        // 석식
                                        Flexible(
                                          flex: 4,
                                          child: Container(
                                            child: Row(
                                              children: <Widget>[
                                                Flexible(
                                                  flex: 1,
                                                  child: Container(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 14.0),
                                                      child: Image.asset(
                                                          "images/cafeteria_dinner.png",
                                                          width: styleModel
                                                                  .getContextSize()[
                                                              'bigIconSize']),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                    flex: 7,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Flexible(
                                                          flex: 1,
                                                          child: Row(
                                                            children: <Widget>[
                                                              Flexible(
                                                                flex: 4,
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            14.0),
                                                                    child: Text(
                                                                      "${cafeteriaMenu.dinner['menus'].length > 1 ? cafeteriaMenu.dinner['menus'][2] : cafeteriaMenu.dinner['menus'].join(',')}",
                                                                      style: styleModel
                                                                              .getTextStyle()[
                                                                          'subtitleTextStyle'],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Flexible(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            8.0),
                                                                    child: Text(
                                                                      "",
                                                                      style: styleModel.getTextStyle(
                                                                          color:
                                                                              Colors.grey)['bodyTextStyle'],
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
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          14.0),
                                                              child: Text(
                                                                "${cafeteriaMenu.dinner['menus'].join(',')}",
                                                                style: styleModel
                                                                        .getTextStyle(
                                                                            color:
                                                                                Colors.grey)[
                                                                    'bodyTextStyle'],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 5.0,
                                color: styleModel
                                    .getBackgroundColor()['greyLevel5'],
                              ),
                              Flexible(
                                flex: 1,
                                child: Card(
                                  color: styleModel.getBackgroundColor()[
                                      'backgroundColorLevel1'],
                                  margin: EdgeInsets.zero,
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 2.0,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        // 메인 타이틀
                                        Flexible(
                                          flex: 5,
                                          child: Column(
                                            children: <Widget>[
                                              Flexible(
                                                flex: 1,
                                                child: Container(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 24.0),
                                                      child: Text(
                                                        "사이드메뉴",
                                                        style: styleModel
                                                                .getTextStyle()[
                                                            'titleTextStyle'],
                                                      ),
                                                    )),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Flexible(
                                                        flex: 1,
                                                        child: Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Icon(
                                                            Icons.priority_high,
                                                            size: styleModel
                                                                    .getContextSize()[
                                                                'middleIconSize'],
                                                            color: Colors
                                                                .redAccent,
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        flex: 8,
                                                        child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0),
                                                            child: Text(
                                                              "재고 소진시 판매하지 않을 수 있습니다.",
                                                              style: styleModel
                                                                      .getTextStyle()[
                                                                  'smallBodyTextStyle'],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        WidthDivisionLine(),
                                        // 데일리 메뉴
                                        Flexible(
                                          flex: 4,
                                          child: Container(
                                            child: Row(
                                              children: <Widget>[
                                                Flexible(
                                                  flex: 1,
                                                  child: Container(),
                                                ),
                                                Flexible(
                                                    flex: 7,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Flexible(
                                                          flex: 1,
                                                          child: Row(
                                                            children: <Widget>[
                                                              Flexible(
                                                                flex: 4,
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            14.0),
                                                                    child: Text(
                                                                      "${cafeteriaMenu.daily['menus'].length > 1 ? cafeteriaMenu.daily['menus'][0] : cafeteriaMenu.daily['menus'].join(',')}",
                                                                      style: styleModel
                                                                              .getTextStyle()[
                                                                          'subtitleTextStyle'],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Flexible(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            8.0),
                                                                    child: Text(
                                                                      "",
                                                                      style: styleModel.getTextStyle(
                                                                          color:
                                                                              Colors.grey)['bodyTextStyle'],
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
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          14.0),
                                                              child: Text(
                                                                "${cafeteriaMenu.daily['menus'].join(',')}",
                                                                style: styleModel
                                                                        .getTextStyle(
                                                                            color:
                                                                                Colors.grey)[
                                                                    'bodyTextStyle'],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                        WidthDivisionLine(),
                                        Flexible(
                                          flex: 4,
                                          child: Container(
                                            child: Row(
                                              children: <Widget>[
                                                Flexible(
                                                  flex: 1,
                                                  child: Container(),
                                                ),
                                                Flexible(
                                                    flex: 7,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Flexible(
                                                          flex: 1,
                                                          child: Row(
                                                            children: <Widget>[
                                                              Flexible(
                                                                flex: 4,
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            14.0),
                                                                    child: Text(
                                                                      "${cafeteriaMenu.fix['menus'].length > 1 ? cafeteriaMenu.fix['menus'][0] : cafeteriaMenu.fix['menus'].join(',')}",
                                                                      style: styleModel
                                                                              .getTextStyle()[
                                                                          'subtitleTextStyle'],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Flexible(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            8.0),
                                                                    child: Text(
                                                                      "",
                                                                      style: styleModel.getTextStyle(
                                                                          color:
                                                                              Colors.grey)['bodyTextStyle'],
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
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          14.0),
                                                              child: Text(
                                                                "${cafeteriaMenu.fix['menus'].join(', ')}",
                                                                style: styleModel
                                                                        .getTextStyle(
                                                                            color:
                                                                                Colors.grey)[
                                                                    'bodyTextStyle'],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                      }
                    }),
              ),
              // 정보
              Container(
                color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 10.0,
                      color: styleModel.getBackgroundColor()['greyLevel5'],
                    ),
                    Flexible(
                      flex: 1,
                      child: Card(
                        color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Flexible(
                                flex: 2,
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 24.0),
                                    child: Text(
                                      "운영시간",
                                      style: styleModel
                                          .getTextStyle()['titleTextStyle'],
                                    ),
                                  ),
                                ),
                              ),
                              WidthDivisionLine(),
                              Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(
                                        flex: 2,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                flex: 1,
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  width: double.infinity,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Image.asset(
                                                        "images/sun.png"),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 2,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    width: double.infinity,
                                                    child: Text(
                                                      "중 식",
                                                      style: styleModel
                                                              .getTextStyle()[
                                                          'bodyTitleTextStyle'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 4,
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 14.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Flexible(
                                                  flex: 1,
                                                  child: Container(
                                                    width: double.infinity,
                                                    child: Text(
                                                      "오전 11:00 ~ 12:00",
                                                      style: styleModel
                                                              .getTextStyle()[
                                                          'bodyTextStyle'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 8.0,
                                                    ),
                                                    child: Container(
                                                      width: double.infinity,
                                                      child: Text(
                                                        "오후 12:30 ~ 16:00",
                                                        style: styleModel
                                                                .getTextStyle()[
                                                            'bodyTextStyle'],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
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
                              WidthDivisionLine(),
                              Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(
                                        flex: 2,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                flex: 1,
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  width: double.infinity,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Image.asset(
                                                        "images/moon.png"),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 2,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    width: double.infinity,
                                                    child: Text(
                                                      "석 식",
                                                      style: styleModel
                                                              .getTextStyle()[
                                                          'bodyTitleTextStyle'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 4,
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 14.0),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8.0,
                                              ),
                                              child: Container(
                                                width: double.infinity,
                                                child: Text(
                                                  "오후 16:00 ~ 19:00",
                                                  style:
                                                      styleModel.getTextStyle()[
                                                          'bodyTextStyle'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
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
                    ),
                    WidthDivisionLine(),
                    Flexible(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Row(children: <Widget>[
                            Flexible(
                                flex: 2,
                                child: Container(
                                    alignment: Alignment.topRight,
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Text(
                                      " ",
                                      style: styleModel
                                          .getTextStyle()['bodyTextStyle'],
                                    ))),
                            Flexible(
                              flex: 3,
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "",
                                  style: styleModel
                                      .getTextStyle()['bodyTitleTextStyle'],
                                ),
                              ),
                            )
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
