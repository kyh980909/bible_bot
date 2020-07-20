import 'dart:convert';

import 'package:bible_bot/api/api.dart';
import 'package:bible_bot/models/notice.dart';
import 'package:bible_bot/models/style_model.dart';
import 'package:bible_bot/util/day_of_week.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SchoolNewsScreen extends StatefulWidget {
  @override
  _SchoolNewsScreenState createState() => _SchoolNewsScreenState();
}

class _SchoolNewsScreenState extends State<SchoolNewsScreen> {
  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    final styleModel = Provider.of<StyleModel>(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: styleModel.getBackgroundColor()['reversalColorLevel1']),
            onPressed: () => Navigator.pop(context),
          ),
          brightness: styleModel.getBrightness()['appBarBrightness'],
          // 추가해줘야 statusBar 정상표
          backgroundColor:
              styleModel.getBackgroundColor()['backgroundColorLevel1'],
          title: new Text(
            '공지사항',
            style: styleModel.getTextStyle()['appBarTextStyle'],
          ),

          elevation: 0,
          bottom: TabBar(
            labelColor: styleModel.getBackgroundColor()['reversalColorLevel1'],
            unselectedLabelColor: styleModel.getBackgroundColor()['greyLevel2'],
            unselectedLabelStyle: styleModel.getTextStyle()['bodyTextStyle'],
            labelStyle: styleModel.getTextStyle()['bodyTextStyle'],
            labelPadding: EdgeInsets.symmetric(horizontal: 4.0),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.green[200],
            tabs: <Widget>[
              Tab(text: '전체'),
              Tab(text: '학사/취창업'),
              Tab(text: '장학/등록금'),
              Tab(text: '신앙/채플/봉사'),
            ],
          ),
        ),
        backgroundColor:
            styleModel.getBackgroundColor()['backgroundColorLevel1'],
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            SchoolNewsContent(category: null),
            SchoolNewsContent(category: '1'),
            SchoolNewsContent(category: '2'),
            SchoolNewsContent(category: '3'),
          ],
        ),
      ),
    );
  }
}

class SchoolNewsContent extends StatefulWidget {
  final String category;

  const SchoolNewsContent({Key key, this.category}) : super(key: key);

  @override
  _SchoolNewsContentState createState() => _SchoolNewsContentState();
}

class _SchoolNewsContentState extends State<SchoolNewsContent>
    with AutomaticKeepAliveClientMixin {
  int count = 50; // 처음 한번은 50개 가져옴
  int maxId;
  bool check = false;
  bool lock = true;
  bool err = false;
  ScrollController _scrollController;
  List<Notice> notices = new List<Notice>();

  getNotice(int count, {int maxId}) async {
    try {
      Map<String, dynamic> recvData = maxId == null
          ? await Api()
              .getNotice(count: count.toString(), category: widget.category)
          : await Api().getNotice(
              count: count.toString(),
              maxId: maxId.toString(),
              category: widget.category);

      if (recvData['result']) {
        err = false;
        if (mounted) {
          setState(() {
            for (List list in json.decode(recvData['data'])['data']['body']) {
              Notice notice = new Notice.fromList(list);
              notices.add(notice);
            }
            lock = true;
          });
          this.maxId = notices[notices.length - 1].id - 1;
          this.count = 10; // 한번 가져온 이후 10개씩 가져옴
        }
      } else {
        if (mounted) {
          setState(() {
            err = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          err = true;
          check = true;
          lock = true;
        });
      }
    }
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (lock) {
        // 스크롤 업데이트를 한번만 하게 lock 걸기
        lock = false;
        if (mounted) {
          setState(() {
            getNotice(count, maxId: this.maxId);
          });
        }
      }
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    super.initState();
    getNotice(count);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final styleModel = Provider.of<StyleModel>(context);
    final themeData = Provider.of<String>(context);
    return noticeList(styleModel, themeData);
  }

  ListView noticeList(StyleModel styleModel, String themeData) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return Divider(
            height: 0,
            endIndent: 0,
            indent: styleModel.getContextSize()['screenWidthLevel8'] + 20,
            color: Colors.transparent);
      },
      controller: _scrollController,
      itemCount: notices.length + 1,
      itemBuilder: (context, index) {
        if (err) {
          return Container(
            child: Center(
              child: RaisedButton(
                color: Colors.green[200],
                onPressed: () => getNotice(count),
                child: Text(
                  '새로고침',
                  style: styleModel.getTextStyle(
                      color: Colors.white)['bodyTextStyle'],
                ),
              ),
            ),
          );
        }
        if (index == notices.length) {
          return Container(
            height: styleModel.getContextSize()['screenHeightLevel3'],
            color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        } else {
          var dateTime = notices[index].datetime;
          var dateOfPreparation = DateFormat("yy/MM/dd")
              .format(DateTime.parse(notices[index].datetime));
          var day = getDayOfWeek(DateTime.parse(dateTime).weekday);
          var todayNotices = DateFormat("yy/MM/dd").format(DateTime.now());
          return Container(
            color: styleModel.getBackgroundColor()['greyLevel5'],
            child: Card(
              elevation: 2,
              margin: EdgeInsets.only(top: 4.0),
              child: Container(
                height: styleModel.getContextSize()['screenHeightLevel8.5'],
                width: double.infinity,
                child: RaisedButton(
                  highlightElevation: 0,
                  padding: EdgeInsets.all(0),
                  highlightColor:
                      styleModel.getBackgroundColor()['highLightColor'],
                  focusElevation: 0,
                  elevation: 0,
                  splashColor: styleModel.getBackgroundColor()['splashColor'],
                  color:
                      styleModel.getBackgroundColor()['backgroundColorLevel2'],
                  onPressed: () {
                    Navigator.of(context).push(
                      new MaterialPageRoute(
                        builder: (BuildContext context) => MultiProvider(
                          providers: [
                            Provider<StyleModel>.value(
                                value: StyleModel(context,
                                    currentTheme: themeData)),
                            Provider<String>.value(value: themeData),
                          ],
                          child: NewsWebview(
                            url: notices[index].url,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.bottomLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                              '$dateOfPreparation ($day)',
                                              textScaleFactor: 1,
                                              style: styleModel.getTextStyle()[
                                                  'smallBodyTextStyle']),
                                        ),
                                        Container(
                                          alignment: Alignment.bottomLeft,
                                          child: todayNotices ==
                                                  dateOfPreparation
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Container(
                                                    height: 13.0,
                                                    width: 40.0,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: Colors.redAccent,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  3.0)),
                                                    ),
                                                    child: Text(
                                                      "TODAY",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textScaleFactor: 1,
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Flexible(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 14.0),
                                        child: Text('${notices[index].id}',
                                            style: styleModel.getTextStyle(
                                                    color: Colors.green[300])[
                                                'smallBodyTextStyle']),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '${notices[index].title}',
                              style: styleModel.getTextStyle(
                                  fontSize: 0.017)['bodyTextStyle'],
                              textScaleFactor: 0.9,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              border: Border(
                            top: BorderSide(
                              color:
                                  styleModel.getBackgroundColor()['greyLevel4'],
                            ),
                          )),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        '작성자  ',
                                        style: styleModel.getTextStyle(
                                                color: Colors.deepOrange[400])[
                                            'bodyTextStyle'],
                                        textScaleFactor: 1,
                                        strutStyle: StrutStyle(height: 2.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    child: Text(
                                      '${notices[index].author}',
                                      style: styleModel.getTextStyle(
                                          fontWeight: FontWeight
                                              .normal)['bodyTextStyle'],
                                      textScaleFactor: 1,
                                      strutStyle: StrutStyle(height: 2.0),
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
            ),
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class NewsWebview extends StatefulWidget {
  final String url;

  NewsWebview({Key key, @required this.url}) : super(key: key);

  @override
  _NewsWebviewState createState() => _NewsWebviewState();
}

class _NewsWebviewState extends State<NewsWebview> {
  @override
  Widget build(BuildContext context) {
    final styleModel = Provider.of<StyleModel>(context);
    return Scaffold(
      backgroundColor: styleModel.getBackgroundColor()['backgroundColorLevel1'],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: styleModel.getBackgroundColor()['reversalColorLevel1']),
          onPressed: () => Navigator.pop(context),
        ),
        brightness: styleModel.getBrightness()['appBarBrightness'],
        // 추가해줘야 statusBar 정상표시
        backgroundColor:
            styleModel.getBackgroundColor()['backgroundColorLevel1'],
        title: new Text('공지사항',
            style: styleModel.getTextStyle()['appBarTextStyle']),
        elevation: 0,
      ),
      body: WebviewScaffold(
        url: widget.url,
        hidden: true,
        withZoom: true,
      ),
    );
  }
}
