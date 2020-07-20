import 'dart:convert';
import 'dart:io';
import 'package:bible_bot/api/api.dart';
import 'package:bible_bot/models/event.dart';
import 'package:bible_bot/models/style_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  CalendarController _calendarController;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  double rowHeight;
  double schedulePadding;
  int maxSchedule;
  List<Event> eventList = List<Event>();
  Future event;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _calendarController.selectedDate = DateTime.now();
    event = getEvent();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  getEvent() async {
    var kbu = await Api().getCalendar(kind: 'kbu');
    var holiday = await Api().getCalendar(kind: 'holiday');

    if (kbu['result'] && holiday['result']) {
      List kbuData = json.decode(kbu['data'])['data']['data'];
      List holidayData = json.decode(holiday['data'])['data']['data'];
      for (var item in holidayData) {
        if (item['rrule']['count'] != 0) {
          eventList.add(
            Event(
                name: item['name'],
                from: DateTime.parse(item['start']),
                to: DateTime.parse(item['end'])
                    .subtract(const Duration(seconds: 1)),
                isAllDay: item['all_day'],
                color: Colors.red[400],
                rrule:
                    'FREQ=${item['rrule']['freq']};BYMONTH=${DateTime.parse(item['start']).month};BYMONTHDAY=${DateTime.parse(item['start']).day};COUNT=${item['rrule']['count']}'),
          );
        } else {
          eventList.add(
            Event(
              name: item['name'],
              from: DateTime.parse(item['start']),
              to: DateTime.parse(item['end'])
                  .subtract(const Duration(seconds: 1)),
              isAllDay: item['all_day'],
              color: Colors.red[400],
            ),
          );
        }
      }
      for (var item in kbuData) {
        eventList.add(
          Event(
              name: item['name'],
              from: DateTime.parse(item['start']),
              to: DateTime.parse(item['end'])
                  .subtract(const Duration(seconds: 1)),
              isAllDay: item['all_day'],
              color: Colors.green[300]),
        );
      }
    }
  }

  Future selectDatePicker(BuildContext context, StyleModel styleModel) async {
    final DateTime maxDate = new DateTime(1952, 5, 13);
    final DateTime minDate = new DateTime(9999, 12, 31);
    if (Platform.isAndroid) {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: _calendarController.selectedDate,
          firstDate: maxDate,
          lastDate: minDate,
          builder: (BuildContext context, Widget child) {
            return Theme(
              data: styleModel.currentTheme == 'black'
                  ? ThemeData.dark()
                  : ThemeData.light(),
              child: child,
            );
          });
      if (picked != null)
        setState(() {
          _calendarController.displayDate = picked;
          _calendarController.selectedDate = picked;
        });
    } else {
      DatePicker.showDatePicker(
        context,
        pickerTheme: DateTimePickerTheme(
          backgroundColor:
              styleModel.getBackgroundColor()['backgroundColorLevel1'],
          cancelTextStyle: styleModel.getTextStyle()['bodyTitleTextStyle'],
          itemTextStyle: styleModel.getTextStyle()['bodyTextStyle'],
        ),
        minDateTime: maxDate,
        maxDateTime: minDate,
        initialDateTime: _calendarController.selectedDate,
        locale: DateTimePickerLocale.ko,
        onConfirm: (dateTime, List<int> index) {
          setState(() {
            _calendarController.displayDate = dateTime;
            _calendarController.selectedDate = dateTime;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final styleModel = Provider.of<StyleModel>(context);
    final theme = Provider.of<String>(context);
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('학사일정',
              style: styleModel.getTextStyle()['appBarTextStyle'],
              overflow: TextOverflow.ellipsis),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: styleModel.getBackgroundColor()['reversalColorLevel1'],
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: Container(
                width: 80.0,
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  highlightElevation: 0,
                  highlightColor:
                      styleModel.getBackgroundColor()['highLightColor'],
                  focusElevation: 0,
                  elevation: 0,
                  splashColor: styleModel.getBackgroundColor()['splashColor'],
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0),
                      side: BorderSide(color: Colors.green[200])),
                  onPressed: () {
                    setState(() {
                      _calendarController.displayDate = DateTime.now();
                      _calendarController.selectedDate = DateTime.now();
                    });
                  },
                  child: Text(
                    "TODAY",
                    style: styleModel.getTextStyle()['smallBodyTextStyle'],
                    textScaleFactor: 1.1,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.calendar_today,
                color: styleModel.getIconColor()['themeIconColor'],
              ),
              onPressed: () async => selectDatePicker(context, styleModel),
            )
          ],
          elevation: 0,
          brightness: styleModel.getBrightness()['appBarBrightness'],
          backgroundColor:
              styleModel.getBackgroundColor()['backgroundColorLevel1']),
      backgroundColor: styleModel.getBackgroundColor()['backgroundColorLevel1'],
      body: FutureBuilder(
        future: event,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: <Widget>[
                SfCalendar(
                  controller: _calendarController,
                  headerStyle: CalendarHeaderStyle(
                      textAlign: TextAlign.center,
                      textStyle:
                          styleModel.getTextStyle()['subtitleTextStyle']),
                  viewHeaderStyle: ViewHeaderStyle(
                      backgroundColor:
                          styleModel.getBackgroundColor()['greyLevel5'],
                      dayTextStyle: styleModel.getTextStyle()['bodyTextStyle'],
                      dateTextStyle:
                          styleModel.getTextStyle()['bodyTextStyle']),
                  view: CalendarView.month,
                  todayHighlightColor: Colors.blue[200],
                  dataSource: EventDataSource(eventList),
                  cellBorderColor: theme == 'black'
                      ? styleModel.getBackgroundColor()['backgroundColorLevel1']
                      : Colors.white,
                  selectionDecoration: BoxDecoration(
                      border: Border.all(color: Colors.blue[200])),
                  monthViewSettings: MonthViewSettings(
                      dayFormat: 'EEE',
                      showAgenda: true,
                      monthCellStyle: MonthCellStyle(
                        textStyle: styleModel.getTextStyle()['bodyTextStyle'],
                        todayTextStyle: styleModel.getTextStyle(
                            color: Colors.white)['bodyTextStyle'],
                        leadingDatesTextStyle: styleModel.getTextStyle(
                            color: theme == 'black'
                                ? Colors.grey[800]
                                : Colors.grey)['bodyTextStyle'],
                        trailingDatesTextStyle: styleModel.getTextStyle(
                            color: theme == 'black'
                                ? Colors.grey[800]
                                : Colors.grey)['bodyTextStyle'],
                      ),
                      agendaStyle: AgendaStyle(
                        dayTextStyle:
                            styleModel.getTextStyle()['footnoteTextStyle'],
                        dateTextStyle:
                            styleModel.getTextStyle()['subtitleTextStyle'],
                      ),
                      appointmentDisplayMode:
                          MonthAppointmentDisplayMode.appointment),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        color: styleModel.getIconColor()['themeIconColor'],
                      ),
                      onPressed: () {
                        _calendarController.backward();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.chevron_right,
                        color: styleModel.getIconColor()['themeIconColor'],
                      ),
                      onPressed: () {
                        _calendarController.forward();
                      },
                    )
                  ],
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].name;
  }

  @override
  Color getColor(int index) {
    return appointments[index].color;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }

  @override
  String getRecurrenceRule(int index) {
    return appointments[index].rrule;
  }
}
