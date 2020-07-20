import 'package:bible_bot/api/api.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:jiffy/jiffy.dart';

class GoogleCalendar {
  Future<Map<DateTime, List>> getHoliday() async {
    Map<String, dynamic> data = await Api().getCalendar(kind: 'holiday');
    if (data['result']) {
      List<dynamic> items = json.decode(data['data'])['data']['data'];

      return event('H', dataSort(items));
    } else {
      return null;
    }
  }

  Future<Map<DateTime, List>> getSchoolEvenet() async {
    Map<String, dynamic> data = await Api().getCalendar(kind: 'kbu');
    if (data['result']) {
      List<dynamic> items =
          json.decode(data['data'])['data']['data']; //body['items'];
      return event('S', dataSort(items));
    } else {
      return null;
    }
  }

  // 데이터 전처리 메서드
  Map<DateTime, List> event(String type, List<String> items) {
    Map<DateTime, List> event = {};
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    int eventRange;

    for (int i = 0; i < items.length; i++) {
      // 0:start, 1:end, 2:summary
      List<String> data = items[i].split(',');
      DateTime start = dateFormat.parse(data[0]);
      DateTime end = dateFormat.parse(data[1]).subtract(Duration(days: 1));
      String summary = data[2];

      eventRange = end.difference(start).inHours;

      // 일정이 2일 이상일 때
      if (eventRange != 24 && eventRange != 0) {
        List<DateTime> dateRange = List<DateTime>();
        for (int range = 0; range < eventRange / 24; range++) {
          dateRange.add(start.add(Duration(days: range)));
        }

        if (event[start] != null) {
          event[start].add('$type:$summary 시작');
        } else {
          // 일정이 비었을 때
          event[start] = ['$type:$summary 시작'];
        }

        if (event[end] != null) {
          event[end].add('$type:$summary 끝');
        } else {
          // 일정이 비었을 때
          event[end] = ['$type:$summary 끝'];
        }
      } else {
        if (event[start] != null) {
          event[start].add('$type:$summary');
        } else {
          event[start] = ['$type:$summary'];
        }
      }
    }
    return event;
  }

  // 일정을 날짜 순으로 재정렬 하는 메서드
  List<String> dataSort(items) {
    List<String> sortData = List<String>(); // 일정 순서로 정렬한 데이터를 저장할 리스트
    for (var item in items) {
      if (item['rrule']['freq'] == 'YEARLY') {
        int year =
            int.parse(DateTime.parse(item['start']).toString().substring(0, 4));
        int leapYearCnt = 0; // 윤년 카운트
        int commonYearCnt = 0;

        if (DateTime.parse(item['start']).month < 3) {
          for (int i = 1; i < item['rrule']['count']; i++) {
            if (year % 4 == 0) {
              leapYearCnt++;
            } else {
              commonYearCnt++;
            }
            sortData.add(DateTime.parse(item['start'])
                    .add(Duration(
                        days: (366 * leapYearCnt) + (365 * commonYearCnt)))
                    .toString() +
                ',' +
                DateTime.parse(item['end'])
                    .add(Duration(
                        days: (366 * leapYearCnt) + (365 * commonYearCnt)))
                    .toString() +
                ',' +
                item['name']);

            year++;
          }
        } else {
          for (int i = 1; i <= item['rrule']['count']; i++) {
            if (year % 4 == 0) {
              leapYearCnt++;
            } else {
              commonYearCnt++;
            }
            sortData.add(DateTime.parse(item['start'])
                    .add(Duration(
                        days:
                            (366 * (leapYearCnt - 1)) + (365 * commonYearCnt)))
                    .toString() +
                ',' +
                DateTime.parse(item['end'])
                    .add(Duration(
                        days:
                            (366 * (leapYearCnt - 1)) + (365 * commonYearCnt)))
                    .toString() +
                ',' +
                item['name']);
            year++;
          }
        }
      } else {
        sortData.add(item['start'] + ',' + item['end'] + ',' + item['name']);
      }
    }
    sortData.sort((a, b) => a.substring(0, 10).compareTo(b.substring(0, 10)));
    return sortData;
  }
}
