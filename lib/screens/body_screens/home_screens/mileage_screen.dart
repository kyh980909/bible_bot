import 'package:bible_bot/communications/request.dart';
import 'package:bible_bot/models/style_model.dart';
import 'package:bible_bot/screens/error_screens/commonErrorScreen.dart';
import 'package:bible_bot/screens/error_screens/empty_state.dart';
import 'package:bible_bot/util/day_of_week.dart';
import 'package:bible_bot/util/show_amount.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MileageNewVersion extends StatefulWidget {
  @override
  _MileageNewVersionState createState() => _MileageNewVersionState();
}

class _MileageNewVersionState extends State<MileageNewVersion> {
  var place;
  DateTime datetime;
  var today;
  var weekday;
  var expenditureAmount;
  var expenditureDetails;
  var type;

  @override
  Widget build(BuildContext context) {
    final styleModel = Provider.of<StyleModel>(context);

    return DefaultTabController(
      length: 3,
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
                title: Text(
                  "이용내역",
                  style: styleModel.getTextStyle()['appBarTextStyle'],
                ),
                floating: true,
                pinned: true,
                snap: true,
                bottom: new TabBar(
                  tabs: [
                    new Tab(text: "전 체"),
                    new Tab(text: '수 입'),
                    new Tab(text: '지 출'),
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
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
              Container(
                color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
                child: FutureBuilder(
                    future: Request().getStatementInfo(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Container(
                            color: styleModel
                                .getBackgroundColor()['backgroundColorLevel3'],
                            child: Center(child: CircularProgressIndicator()),
                          );
                        default:
                          var statement = snapshot.data;
                          if (statement.status) {
                            if (statement.entire.length > 0) {
                              return Container(
                                  color: styleModel
                                      .getBackgroundColor()['greyLevel5'],
                                  child: ListView.separated(
                                      padding: EdgeInsets.all(0),
                                      itemBuilder: (context, index) {
                                        datetime = DateTime.parse(
                                            statement.entire[index][0]);
                                        today = DateFormat("yy/MM/dd")
                                            .format(datetime);
                                        weekday =
                                            getDayOfWeek(datetime.weekday);
                                        expenditureAmount = showAmount(
                                            statement.entire[index][3]);
                                        expenditureDetails =
                                            statement.entire[index][4];
                                        type = statement.entire[index][2];
                                        type == "사용"
                                            ? type = "지출"
                                            : type = "수입";

                                        var todayNotices =
                                            DateFormat("yy/MM/dd")
                                                .format(DateTime.now());

                                        try {
                                          place = expenditureDetails.substring(
                                              4, 6);
                                        } catch (Exception) {
                                          place = "예외";
                                        }
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
                                              color: styleModel
                                                      .getBackgroundColor()[
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
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 14.0,
                                                        ),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Container(
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                              child: Text(
                                                                  "$today ($weekday)",
                                                                  textScaleFactor:
                                                                      1,
                                                                  style: styleModel
                                                                          .getTextStyle()[
                                                                      'smallBodyTextStyle']),
                                                            ),
                                                            todayNotices ==
                                                                    today
                                                                ? Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0),
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomCenter,
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            13.0,
                                                                        width:
                                                                            40.0,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.redAccent,
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(3.0)),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "TODAY",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 10.0,
                                                                              fontWeight: FontWeight.bold),
                                                                          textScaleFactor:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Container()
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 3,
                                                    child: Container(
                                                        color: styleModel
                                                                .getBackgroundColor()[
                                                            'backgroundColorLevel1'],
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 14.0),
                                                            child: Text(
                                                              "$expenditureDetails",
                                                              style: styleModel
                                                                      .getTextStyle(
                                                                          fontSize:
                                                                              0.017)[
                                                                  'bodyTextStyle'],
                                                              textScaleFactor:
                                                                  0.9,
                                                              overflow:
                                                                  TextOverflow
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
                                                                        left:
                                                                            14.0),
                                                                child: Text(
                                                                    "$type  ",
                                                                    textScaleFactor:
                                                                        1,
                                                                    style: styleModel.getTextStyle(
                                                                        color: type ==
                                                                                "지출"
                                                                            ? Colors.deepOrange
                                                                            : Colors.blue[400])['bodyTextStyle']),
                                                              ),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: 1,
                                                            child: Container(
                                                              child: Text(
                                                                  '$expenditureAmount원',
                                                                  textScaleFactor:
                                                                      1,
                                                                  style: styleModel.getTextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal)['bodyTextStyle']),
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
                                          color:
                                              styleModel.getBackgroundColor()[
                                                  'backgroundColorLevel1'],
                                        );
                                      },
                                      itemCount: statement.entire.length));
                            } else {
                              return EmptyStatesScreen();
                            }
                          } else {
                            return CommonErrorScreen();
                          }
                      }
                    }),
              ),
              // 수입
              Container(
                color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
                child: FutureBuilder(
                    future: Request().getStatementInfo(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Container(
                            color: styleModel
                                .getBackgroundColor()['backgroundColorLevel3'],
                            child: Center(child: CircularProgressIndicator()),
                          );
                        default:
                          var statement = snapshot.data;
                          if (statement.status) {
                            if (statement.profit.length > 0) {
                              return Container(
                                  color: styleModel
                                      .getBackgroundColor()['greyLevel5'],
                                  child: ListView.separated(
                                      padding: EdgeInsets.all(0),
                                      itemBuilder: (context, index) {
                                        datetime = DateTime.parse(
                                            statement.profit[index][0]);
                                        today = DateFormat("yy/MM/dd")
                                            .format(datetime);
                                        weekday =
                                            getDayOfWeek(datetime.weekday);
                                        expenditureAmount = showAmount(
                                            statement.profit[index][3]);
                                        expenditureDetails =
                                            statement.profit[index][4];
                                        type = statement.profit[index][2];
                                        type == "사용"
                                            ? type = "지출"
                                            : type = "수입";
                                        var todayNotices =
                                            DateFormat("yy/MM/dd")
                                                .format(DateTime.now());

                                        try {
                                          place = expenditureDetails.substring(
                                              4, 6);
                                        } catch (Exception) {
                                          place = "예외";
                                        }
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
                                              color: styleModel
                                                      .getBackgroundColor()[
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
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 14.0,
                                                        ),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Container(
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                              child: Text(
                                                                  "$today ($weekday)",
                                                                  textScaleFactor:
                                                                      1,
                                                                  style: styleModel
                                                                          .getTextStyle()[
                                                                      'smallBodyTextStyle']),
                                                            ),
                                                            todayNotices ==
                                                                    today
                                                                ? Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0),
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomCenter,
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            13.0,
                                                                        width:
                                                                            40.0,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.redAccent,
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(3.0)),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "TODAY",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 10.0,
                                                                              fontWeight: FontWeight.bold),
                                                                          textScaleFactor:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Container()
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 3,
                                                    child: Container(
                                                        color: styleModel
                                                                .getBackgroundColor()[
                                                            'backgroundColorLevel1'],
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 14.0),
                                                            child: Text(
                                                              "$expenditureDetails",
                                                              style: styleModel
                                                                      .getTextStyle(
                                                                          fontSize:
                                                                              0.017)[
                                                                  'bodyTextStyle'],
                                                              textScaleFactor:
                                                                  0.9,
                                                              overflow:
                                                                  TextOverflow
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
                                                                        left:
                                                                            14.0),
                                                                child: Text(
                                                                    "$type  ",
                                                                    textScaleFactor:
                                                                        1,
                                                                    style: styleModel.getTextStyle(
                                                                        color: type ==
                                                                                "지출"
                                                                            ? Colors.deepOrange
                                                                            : Colors.blue[400])['bodyTextStyle']),
                                                              ),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: 1,
                                                            child: Container(
                                                              child: Text(
                                                                  '$expenditureAmount원',
                                                                  textScaleFactor:
                                                                      1,
                                                                  style: styleModel.getTextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal)['bodyTextStyle']),
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
                                          color:
                                              styleModel.getBackgroundColor()[
                                                  'backgroundColorLevel1'],
                                        );
                                      },
                                      itemCount: statement.profit.length));
                            } else {
                              return EmptyStatesScreen();
                            }
                          } else {
                            return CommonErrorScreen();
                          }
                      }
                    }),
              ),
              // 지출
              Container(
                color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
                child: FutureBuilder(
                    future: Request().getStatementInfo(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Container(
                            color: styleModel
                                .getBackgroundColor()['backgroundColorLevel3'],
                            child: Center(child: CircularProgressIndicator()),
                          );
                        default:
                          var statement = snapshot.data;
                          if (statement.status) {
                            if (statement.expense.length > 0) {
                              return Container(
                                  color: styleModel
                                      .getBackgroundColor()['greyLevel5'],
                                  child: ListView.separated(
                                      padding: EdgeInsets.all(0),
                                      itemBuilder: (context, index) {
                                        datetime = DateTime.parse(
                                            statement.expense[index][0]);
                                        today = DateFormat("yy/MM/dd")
                                            .format(datetime);
                                        weekday =
                                            getDayOfWeek(datetime.weekday);
                                        expenditureAmount = showAmount(
                                            statement.expense[index][3]);
                                        expenditureDetails =
                                            statement.expense[index][4];
                                        type = statement.expense[index][2];
                                        type == "사용"
                                            ? type = "지출"
                                            : type = "수입";

                                        var todayNotices =
                                            DateFormat("yy/MM/dd")
                                                .format(DateTime.now());

                                        try {
                                          place = expenditureDetails.substring(
                                              4, 6);
                                        } catch (Exception) {
                                          place = "예외";
                                        }

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
                                              color: styleModel
                                                      .getBackgroundColor()[
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
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 14.0,
                                                        ),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Container(
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                              child: Text(
                                                                  "$today ($weekday)",
                                                                  textScaleFactor:
                                                                      1,
                                                                  style: styleModel
                                                                          .getTextStyle()[
                                                                      'smallBodyTextStyle']),
                                                            ),
                                                            todayNotices ==
                                                                    today
                                                                ? Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0),
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomCenter,
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            13.0,
                                                                        width:
                                                                            40.0,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.redAccent,
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(3.0)),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "TODAY",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 10.0,
                                                                              fontWeight: FontWeight.bold),
                                                                          textScaleFactor:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Container()
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 3,
                                                    child: Container(
                                                        color: styleModel
                                                                .getBackgroundColor()[
                                                            'backgroundColorLevel1'],
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 14.0),
                                                            child: Text(
                                                              "$expenditureDetails",
                                                              style: styleModel
                                                                      .getTextStyle(
                                                                          fontSize:
                                                                              0.017)[
                                                                  'bodyTextStyle'],
                                                              textScaleFactor:
                                                                  0.9,
                                                              overflow:
                                                                  TextOverflow
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
                                                                        left:
                                                                            14.0),
                                                                child: Text(
                                                                    "$type  ",
                                                                    textScaleFactor:
                                                                        1,
                                                                    style: styleModel.getTextStyle(
                                                                        color: type ==
                                                                                "지출"
                                                                            ? Colors.deepOrange
                                                                            : Colors.blue[400])['bodyTextStyle']),
                                                              ),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: 1,
                                                            child: Container(
                                                              child: Text(
                                                                  '$expenditureAmount원',
                                                                  textScaleFactor:
                                                                      1,
                                                                  style: styleModel.getTextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal)['bodyTextStyle']),
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
                                          color:
                                              styleModel.getBackgroundColor()[
                                                  'backgroundColorLevel1'],
                                        );
                                      },
                                      itemCount: statement.expense.length));
                            } else {
                              return EmptyStatesScreen();
                            }
                          } else {
                            return CommonErrorScreen();
                          }
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
