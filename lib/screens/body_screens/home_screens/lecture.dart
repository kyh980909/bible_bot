import 'dart:async';
import 'dart:convert';
import 'package:bible_bot/api/api.dart';
import 'package:bible_bot/models/attendance.dart';
import 'package:bible_bot/models/lecture.dart';
import 'package:bible_bot/models/style_model.dart';
import 'package:bible_bot/provider/attendance.dart';
import 'package:bible_bot/provider/timetable.dart';
import 'package:bible_bot/screens/error_screens/empty_state.dart';
import 'package:bible_bot/util/attendance_info_prettify.dart';
import 'package:bible_bot/util/day_of_week.dart';
import 'package:bible_bot/util/storage.dart';
import 'package:bible_bot/util/time.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

final List dayEng = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday'];
final List dayKor = ['월', '화', '수', '목', '금'];
Time utilTime = new Time();

class LectureScreen extends StatefulWidget {
  @override
  _LectureScreenState createState() => _LectureScreenState();
}

class _LectureScreenState extends State<LectureScreen>
    with WidgetsBindingObserver {
  List<Widget> time = new List<Widget>();
  List<Widget> grid = new List<Widget>();
  List<List<Widget>> widgetList = new List<List<Widget>>(5);
  Map<String, List> lectureInfo = new Map<String, List>();

  int timeHeight;
  double paddingSize; // 가변적 패딩 사이즈
  String semester;
  String theme;
  TimetableProvider _timetableProvider;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getLecture();
    _timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => updateDrawLine());
    updateDrawLine();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _timer.cancel();
      // went to Background
    }
    if (state == AppLifecycleState.resumed) {
      _timer =
          Timer.periodic(Duration(seconds: 1), (Timer t) => updateDrawLine());
      // came back to Foreground
    }
  }

  void choiceAction(String selected) async {
    semester = await Storage.getTimetableSelected();
    // 현재 선택된 학기를 선택 하지 않을경우에만 리빌드
    if (semester != selected) {
      Storage.setTimetableSelected(selected);
      getLecture(semester: semester);
      _timetableProvider.setSemester(selected);
    }
  }

  Future getLecture({String semester}) async {
    semester = await Storage.getTimetableSelected();
    var lectureData = await Api().getCourse(semester: semester);
    if (semester == null)
      semester = json.decode(lectureData['data'])['meta']['selected'];

    if (await Storage.getCourseCode(semester) == null) {
      // 과목코드가 내부 저장소에 없을때
      var courseCode =
          await Api().getCourseCode(semester: semester); // 과목코드 api 호출
      if (courseCode['result']) {
        // 데이터 호출 성공시
        var courseCodeData =
            json.decode(courseCode['data'])['data']; // 과목코드 json 디코딩후 데이터만 추출
        Storage.setCourseCode(semester,
            json.encode(courseCodeData)); // 추출된 과목코드 다시 json 인코딩후 내부 저장소에 저장
      }
    }
    if (lectureData['result']) {
      Lecture lecture =
          Lecture.fromJson(json.decode(lectureData['data'])['data']);
      for (var data in lecture.tableBody) {
        lectureInfo[data[1]] = data;
      }
    }
  }

  makeTime(firstHour, lastHour, maxHeight, StyleModel styleModel) {
    time.clear();
    timeHeight = lastHour - firstHour + 1;
    for (int i = firstHour; i <= lastHour; i++) {
      time.add(Container(
          alignment: Alignment.topRight,
          decoration: BoxDecoration(
              color: styleModel.getBackgroundColor()['backgroundColorLevel4'],
              border: Border(
                  top: BorderSide(
                      color: styleModel
                          .getDivisionLineStyle()['divisionLineColor']),
                  right: BorderSide(
                      color: styleModel
                          .getDivisionLineStyle()['divisionLineColor']))),
          height: maxHeight / timeHeight,
          width: double.infinity,
          child: Text(i.toString(),
              style: styleModel.getTextStyle()['smallBodyTextStyle'])));
    }
  }

  @override
  Widget build(BuildContext context) {
    final styleModel = Provider.of<StyleModel>(context);
    final themeData = Provider.of<String>(context);
    final timetable = Provider.of<TimetableProvider>(context);

    _timetableProvider = timetable;
    theme = themeData;

    Size size = MediaQuery.of(context).size;
    if (size.width < 414)
      paddingSize = 3.0;
    else if (size.width < 500)
      paddingSize = 3.0;
    else if (size.width < 900)
      paddingSize = 7.0;
    else
      paddingSize = 8.0;

    return Scaffold(
        backgroundColor:
            styleModel.getBackgroundColor()['backgroundColorLevel1'],
        body: timetableWidget(timetable, size, styleModel, themeData));
  }

  Widget timetableWidget(TimetableProvider timetableData, Size size,
      StyleModel styleModel, themeData) {
    final left = 1;
    final right = 15;
    final top = 1;
    final bottom = 34;

    if (!timetableData.isFetching) {
      if (timetableData.getTimetableData() == null)
        return EmptyStatesScreen(); //timetableData.getTimetableData()[1] 에러 텍스트
      if (timetableData.getTimetableData()[0] == false) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  timetableData.getTimetableData()[2],
                  style: styleModel.getTextStyle()['titleTextStyle'],
                ),
                SizedBox(height: 4.0),
                Text(timetableData.getTimetableData()[3],
                    style: styleModel.getTextStyle()['bodyTextStyle'])
              ],
            ),
          ),
        );
      }
      int firstHour = timetableData.getTimetableData()[1]['firstHour'];
      int lastHour = timetableData.getTimetableData()[1]['lastHour'];
      List<String> selectable = timetableData.getTimetableData()[2].selectable;
      return Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: selectSemester(styleModel, selectable, timetableData),
          ),
          dayOfTimetable(top, left, right, styleModel),
          contentOfTimetable(
              bottom,
              left,
              firstHour,
              lastHour,
              right,
              timetableData.getTimetableData()[2].selected,
              styleModel,
              themeData,
              timetableData.getTimetableData()[1],
              size)
        ],
      );
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Text replaceSemester(String value, StyleModel styleModel) {
    String year = value.substring(2, 4);
    String semester = value[4];
    return Text(
      '$year-$semester',
      style: styleModel.getTextStyle()['bodyTitleTextStyle'],
    );
  }

  Container selectSemester(StyleModel styleModel, List<String> selectable,
      TimetableProvider timetableData) {
    String year = timetableData.getTimetableData()[2].selected.substring(2, 4);
    String semester = timetableData.getTimetableData()[2].selected[4];
    return Container(
      child: Theme(
        data: Theme.of(context).copyWith(
            canvasColor:
                styleModel.getBackgroundColor()['backgroundColorLevel1']),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            elevation: 1,
            items: selectable
                .map((value) => DropdownMenuItem(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            replaceSemester(value, styleModel),
                            if (value ==
                                timetableData.getTimetableData()[2].selected)
                              Icon(
                                Icons.check,
                                color: Colors.green[200],
                                size: 20,
                              )
                          ],
                        ),
                      ),
                      value: value,
                    ))
                .toList(),
            onChanged: (String value) {
              choiceAction(value);
            },
            hint: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Text(
                '$year-$semester학기',
                style: styleModel.getTextStyle()['bodyTitleTextStyle'],
              ),
            ),
            icon: Icon(Icons.arrow_drop_down_circle),
            iconSize: 20,
            iconEnabledColor: Colors.green[200],
          ),
        ),
      ),
    );
  }

  Expanded contentOfTimetable(
      int bottom,
      int left,
      int firstHour,
      int lastHour,
      int right,
      String selected,
      styleModel,
      themeData,
      Map<String, dynamic> timetable,
      Size size) {
    return Expanded(
      flex: bottom,
      child: Row(
        children: <Widget>[
          Expanded(
              flex: left,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  makeTime(
                      firstHour, lastHour, constraints.maxHeight, styleModel);
                  return Column(children: this.time);
                },
              )),
          Expanded(
            flex: right,
            child: LayoutBuilder(
              builder: (context, constraints) {
                for (int i = 0; i < 5; i++) {
                  makeSchedule(
                      firstHour,
                      lastHour,
                      constraints.maxHeight,
                      constraints.maxWidth,
                      timetable[dayEng[i]],
                      timetable['color'],
                      i,
                      styleModel,
                      selected,
                      themeData);
                }
                makeGrid(
                    constraints.maxHeight, constraints.maxWidth, styleModel);
                return Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        for (int i = 0; i < timeHeight; i++)
                          Row(children: grid),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        for (int i = 0; i < 5; i++)
                          Column(
                            children: widgetList[i],
                          ),
                      ],
                    ),
                    IgnorePointer(
                      child: CustomPaint(
                        size: size,
                        painter: DrawTimeLine(
                            firstHour: firstHour,
                            lastHour: lastHour,
                            theme: theme),
                      ),
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Expanded dayOfTimetable(int top, int left, int right, styleModel) {
    return Expanded(
        flex: top,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: left,
              child: Container(
                decoration: BoxDecoration(
                    color: styleModel
                        .getBackgroundColor()['backgroundColorLevel4'],
                    border: Border(
                        top: BorderSide(
                            color: styleModel
                                .getDivisionLineStyle()['divisionLineColor']),
                        right: BorderSide(
                            color: styleModel
                                .getDivisionLineStyle()['divisionLineColor']))),
              ),
            ),
            Expanded(
                flex: right,
                child: LayoutBuilder(builder: (context, constraints) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      for (String day in dayKor)
                        Container(
                          alignment: Alignment.center,
                          width: constraints.maxWidth / 5,
                          child: Text(
                            day,
                            style:
                                styleModel.getTextStyle()['smallBodyTextStyle'],
                          ),
                          decoration: BoxDecoration(
                              color: styleModel.getBackgroundColor()[
                                  'backgroundColorLevel4'],
                              border: Border(
                                  top: BorderSide(
                                      color: styleModel.getDivisionLineStyle()[
                                          'divisionLineColor']),
                                  right: BorderSide(
                                      color: styleModel.getDivisionLineStyle()[
                                          'divisionLineColor']))),
                        ),
                    ],
                  );
                }))
          ],
        ));
  }

  makeSchedule(firstHour, lastHour, maxHeight, maxWidth, data, classColor, day,
      styleModel, selected, themeData) {
    List<Widget> schedule = new List<Widget>();
    timeHeight = lastHour - firstHour + 1;
    double unitTime = maxHeight / timeHeight / 12;
    if (data.length != 0) {
      if (!utilTime.compareTime(firstHour, data[0][2])) {
        //공백추가
        schedule.add(Container(
          height: unitTime * utilTime.subTime(firstHour, data[0][2]) / 5,
          width: maxWidth / 5,
        ));
      }
      for (int i = 0; i < data.length; i++) {
        schedule.add(timeTableCell(unitTime, data, i, maxWidth, classColor,
            styleModel, selected, themeData));
        schedule.add(Container(
          //공백추가
          height: unitTime * (data[i][5] / 5),
          width: maxWidth / 5,
        ));
      }
    } else {
      schedule.add(Container(
        width: maxWidth / 5,
      ));
    }
    widgetList[day] = schedule;
  }

  // 시간표 셀
  InkWell timeTableCell(double unitTime, data, int i, maxWidth, classColor,
      StyleModel styleModel, selected, themeData) {
    return InkWell(
      child: Container(
          height: unitTime * (data[i][4] / 5),
          width: maxWidth / 5,
          decoration: BoxDecoration(
              color: Color(int.parse(classColor[data[i][0]])),
              border: Border(
                  top: BorderSide(
                      color: styleModel
                          .getDivisionLineStyle()['divisionLineColor']),
                  right: BorderSide(
                      color: styleModel
                          .getDivisionLineStyle()['divisionLineColor']))),
          child: Padding(
            padding: EdgeInsets.only(
                left: paddingSize, top: paddingSize, right: paddingSize),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data[i][0],
                    style: styleModel.getTextStyle(
                        color: Colors.white)['bodyTextStyle'],
                    textScaleFactor: 1.0,
                  ),
                  SizedBox(height: 3),
                  Text(
                    '${data[i][2]}~${data[i][3]}',
                    textScaleFactor: 1.0,
                    style: styleModel.getTextStyle(
                        color: Colors.white)['smallBodyTextStyle'],
                  ),
                ],
              ),
            ),
          )),
      onTap: () {
        showAttendance(
            context, themeData, data[i], classColor[data[i][0]], selected);
      },
    );
  }

  void showAttendance(context, themeData, lectureData, color, selected) {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return MultiProvider(providers: [
                Provider<String>.value(value: themeData),
                Provider<StyleModel>.value(
                  value: StyleModel(context, currentTheme: themeData),
                ),
                Provider<AttendanceProvider>.value(
                    value: AttendanceProvider(
                  context,
                  AttendanceModel.process(
                      lectureInfo[lectureData[0]], lectureData[1]),
                  color,
                  selected,
                ))
              ], child: AttendanceScreen(className: lectureData[0]));
            },
            fullscreenDialog: true));
  }

  makeGrid(maxHeight, maxWidth, styleModel) {
    grid.clear();
    for (int i = 0; i < 5; i++) {
      grid.add(Container(
        alignment: Alignment.topRight,
        decoration: BoxDecoration(
            color: styleModel.getBackgroundColor()['backgroundColorLevel4'],
            border: Border(
                top: BorderSide(
                    color:
                        styleModel.getDivisionLineStyle()['divisionLineColor']),
                right: BorderSide(
                    color: styleModel
                        .getDivisionLineStyle()['divisionLineColor']))),
        width: maxWidth / 5,
        height: maxHeight / timeHeight,
      ));
    }
  }

// 선 그리기 새로고침 해주는 함수
  void updateDrawLine() {
    if (DateTime.now().weekday == DateTime.sunday ||
        DateTime.now().weekday == DateTime.saturday) _timer.cancel();

    setState(() {});
  }
}

class AttendanceScreen extends StatefulWidget {
  final String className;
  AttendanceScreen({this.className});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 5, vsync: this);
  }

  Future getDetailTimetable(String className, String semester) async {
    List<dynamic> data = List<dynamic>();
    String courseCode = await Storage.getCourseCode(semester);

    if (courseCode == null) {
      data.add('yet');
    } else {
      String lmsCode =
          json.decode(courseCode)['courses'][className]; // 선택된 강좌에 과목코드 가져오기
      var attendanceData =
          await Api().getAttendance(lmsCode); // 과목코드로 그 과목 출석 불러오기

      data.add(attendanceData['result']);
      if (attendanceData['result']) {
        Attendance attendance =
            Attendance.fromJson(json.decode(attendanceData['data'])['data']);
        data.add(attendance);
      } else {
        data.add(attendanceData['err']);
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final String theme = Provider.of<String>(context);
    final styleModel = Provider.of<StyleModel>(context);
    final attendanceInfo = Provider.of<AttendanceProvider>(context);

    return Scaffold(
      backgroundColor: styleModel.getBackgroundColor()['backgroundColorLevel1'],
      appBar: AppBar(
        brightness: styleModel.getBrightness()['appBarBrightness'],
        // 추가해줘야 statusBar 정상표시
        backgroundColor: Color(int.parse(attendanceInfo.color)),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.className),
      ),
      body: Column(
        children: <Widget>[
          buildLectureInfo(attendanceInfo, styleModel),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: FutureBuilder(
              future:
                  getDetailTimetable(widget.className, attendanceInfo.selected),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.done) {
                  if (snap.data == null || snap.data[0] == false) {
                    return buildNoAttendance(styleModel);
                  }
                  if (int.parse(attendanceInfo.selected) > 20191) {
                    if (snap.data[0] == 'yet') {
                      return Center(
                        child: IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: () async {
                            getDetailTimetable(
                                widget.className, attendanceInfo.selected);
                          },
                        ),
                      );
                    }
                    if (snap.data[1].tableBody.length > 1) {
                      List<dynamic> attendance = new List<dynamic>();
                      List<dynamic> tardy = new List<dynamic>();
                      List<dynamic> absent = new List<dynamic>();
                      List<dynamic> etc = new List<dynamic>();
                      for (var data in snap.data[1].tableBody) {
                        if (data[2] != '') attendance.add(data);
                        if (data[3] != '') absent.add(data);
                        if (data[4] != '') tardy.add(data);
                        if (data[5] != '') etc.add(data);
                      }
                      return Column(
                        children: <Widget>[
                          buildCardTabBar(styleModel, attendanceInfo),
                          buildAttendanceListView(snap, styleModel, attendance,
                              absent, tardy, etc, theme)
                        ],
                      );
                    }
                    return buildNoAttendance(styleModel);
                  } else {
                    return buildNoAttendance(styleModel);
                  }
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Expanded buildAttendanceListView(AsyncSnapshot snap, StyleModel styleModel,
      List attendance, List absent, List tardy, List etc, String theme) {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: <Widget>[
          detailDataList(snap.data[1].tableBody, styleModel, theme),
          detailDataList(attendance, styleModel, theme),
          detailDataList(absent, styleModel, theme),
          detailDataList(tardy, styleModel, theme),
          detailDataList(etc, styleModel, theme),
        ],
      ),
    );
  }

  Card buildCardTabBar(
      StyleModel styleModel, AttendanceProvider attendanceInfo) {
    return Card(
      color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
      elevation: 5,
      margin: EdgeInsets.all(5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: TabBar(
        unselectedLabelColor:
            styleModel.getBackgroundColor()['reversalColorLevel1'],
        labelColor: Color(int.parse(attendanceInfo.color)),
        indicatorColor: Color(int.parse(attendanceInfo.color)),
        controller: _tabController,
        tabs: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('전체'),
          ),
          Text('출석'),
          Text('결석'),
          Text('지각'),
          Text('기타')
        ],
      ),
    );
  }

  // 출석 정보 없을 때
  Center buildNoAttendance(StyleModel styleModel) {
    return Center(
      child: Text('등록된 주차가 없습니다.',
          style: styleModel.getTextStyle()['subtitleTextStyle']),
    );
  }

  // 강좌정보 위젯
  Container buildLectureInfo(
      AttendanceProvider attendanceInfo, StyleModel styleModel) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.calendar_today,
                    color:
                        styleModel.getBackgroundColor()['reversalColorLevel1'],
                  ),
                  Expanded(
                    child: Text(
                      '  ' +
                          AttendanceInfoPrettify()
                              .prettify(attendanceInfo.attendanceModel.date),
                      style: styleModel.getTextStyle(
                          fontSize: 0.016)['bodyTextStyle'],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Summary keyword',
                style:
                    styleModel.getTextStyle(fontSize: 0.019)['bodyTextStyle'],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        buildSummaryKeyword(
                            styleModel,
                            '강좌코드',
                            attendanceInfo.attendanceModel.code,
                            attendanceInfo.color),
                        SizedBox(
                          width: 10.0,
                        ),
                        buildSummaryKeyword(
                            styleModel,
                            '과목명',
                            attendanceInfo.attendanceModel.lectureName,
                            attendanceInfo.color),
                        SizedBox(
                          width: 10.0,
                        ),
                        buildSummaryKeyword(
                            styleModel,
                            '강의실',
                            attendanceInfo.attendanceModel.place,
                            attendanceInfo.color)
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: <Widget>[
                        buildSummaryKeyword(
                            styleModel,
                            '이수구분',
                            attendanceInfo.attendanceModel.kind,
                            attendanceInfo.color),
                        SizedBox(
                          width: 10.0,
                        ),
                        buildSummaryKeyword(
                            styleModel,
                            '학점',
                            attendanceInfo.attendanceModel.gpa,
                            attendanceInfo.color),
                        SizedBox(
                          width: 10.0,
                        ),
                        buildSummaryKeyword(
                            styleModel,
                            '교수명',
                            attendanceInfo.attendanceModel.professorName,
                            attendanceInfo.color),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Row buildSummaryKeyword(
      StyleModel styleModel, String kind, String content, String color) {
    return Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Color(0xff34495e),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  bottomLeft: Radius.circular(4.0))),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 2.0, bottom: 2.0, left: 5.0, right: 2.0),
            child: Center(
              child: SelectableText(
                kind,
                style: styleModel.getTextStyle(
                    color: Colors.white)['bodyTextStyle'],
                strutStyle: StrutStyle(height: 1.3),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Color(int.parse(color)),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4.0),
                  bottomRight: Radius.circular(4.0))),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 2.0, bottom: 2.0, left: 4.0, right: 3.0),
            child: Center(
              child: SelectableText(
                content,
                style: styleModel.getTextStyle(
                    color: Colors.white)['bodyTextStyle'],
                strutStyle: StrutStyle(height: 1.3),
              ),
            ),
          ),
        )
      ],
    );
  }

  // 출석 상세 정보 보여주는 부분
  Widget detailDataList(
      List<dynamic> detailData, StyleModel styleModel, String theme) {
    detailData = detailData.reversed.toList(); // 출석 날짜 역순으로
    if (detailData.length != 0) {
      return ListView.builder(
        itemCount: detailData.length,
        itemBuilder: (context, index) {
          if (detailData[index].contains('○')) {
            return Card(
              color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
              child: Container(
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: stampColor(detailData[index], theme),
                      ),
                    ),
                    Flexible(
                      flex: 8,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child:
                                  circleToText(detailData[index], styleModel),
                            ),
                            Text(
                                '${detailData[index][0]} (${getDayOfWeek(DateTime.parse(detailData[index][0]).weekday)})',
                                style: styleModel
                                    .getTextStyle()['smallBodyTextStyle']),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      );
    }
    return Container();
  }

  Widget stampColor(List<dynamic> data, String theme) {
    if (data[2] == '○')
      return Transform.rotate(
        angle: -3.14 / 13,
        child: Opacity(
          opacity: 0.5,
          child: Image.asset(
            'images/chapelAttendance.png',
            color: theme == 'black' ? Colors.white : null,
          ),
        ),
      );
    if (data[3] == '○')
      return Transform.rotate(
        angle: -3.14 / 13,
        child: Opacity(
            opacity: 0.5,
            child: Image.asset(
              'images/chapelAbsent.png',
              color: theme == 'black' ? Colors.redAccent : null,
            )),
      );
    if (data[4] == '○')
      return Transform.rotate(
        angle: -3.14 / 13,
        child: Opacity(
          opacity: 0.5,
          child: Image.asset(
            'images/chapelLate.png',
            color: theme == 'black' ? Colors.deepOrangeAccent : null,
          ),
        ),
      );
    return Container();
  }

  Text circleToText(List<dynamic> data, StyleModel styleModel) {
    if (data[2] == '○')
      return Text('출석', style: styleModel.getTextStyle()['subtitleTextStyle']);
    if (data[3] == '○')
      return Text('결석',
          style:
              styleModel.getTextStyle(color: Colors.red)['subtitleTextStyle']);
    if (data[4] == '○')
      return Text('지각',
          style: styleModel.getTextStyle(
              color: Colors.orange)['subtitleTextStyle']);
    return Text('');
  }
}

class DrawTimeLine extends CustomPainter {
  final int firstHour;
  final int lastHour;
  final String theme;
  DateFormat df = DateFormat.Hms();

  DrawTimeLine({this.firstHour, this.lastHour, this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    int sub; // total에서 현재의 시간을 뺀값을 초로 저장
    int total; // 시간표 상의 전체 시간을 초로 나타낸 값 저장
    int day = DateTime.now().weekday;
    double current;

    if (day != DateTime.sunday || day != DateTime.saturday) {
      if (DateTime.now().hour >= firstHour &&
          DateTime.now().hour < lastHour + 1) {
        total = (lastHour + 1 - firstHour) * 3600;
        sub = (((lastHour + 1) * 3600) -
            utilTime.hourToSecond(df.format(DateTime.now())));

        current = (total - sub) / total;

        final p1 = Offset((size.width / 5) * (day - 1), current * size.height);
        final p2 = Offset(size.width / 5 * day, current * size.height);
        final paint = Paint()
          ..color = theme == 'black' ? Colors.white70 : Colors.black12
          ..strokeWidth = 2;
        canvas.drawLine(p1, p2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
