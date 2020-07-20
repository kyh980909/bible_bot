import 'package:bible_bot/models/timetable.dart';
import 'package:bible_bot/util/time.dart';

class ClassProcess {
  String theme;
  Timetable timetable;
  ClassProcess(this.theme, this.timetable);

  Map<String, dynamic> getTimetable() {
    // int number = 3;
    int maxColumn = 0;
    int firstHour = 9;
    int firstMinute = 0;
    int lastHour = 0;
    int lastMinute = 0;

    Map<String, dynamic> className = new Map();
    // 0부터 시작해서 월화수목금 => 다음 인덱스는 각각 수업 => 다음 인덱스는 요소 접근

    Time time = new Time();
    List<String> colors = theme == 'black'
        ? [
            '0xffcb9495',
            '0xff9aab59',
            '0xff4e85bf',
            '0xffa895b6',
            '0xffca7e7f',
            '0xffbcab00',
            '0xff368894',
            '0xff68a151',
            '0xffc18526',
            '0xffcaa265',
            '0xffc84460',
            '0xff9469ac',
            '0xff00599e',
            '0xff96836b',
            '0xff004068'
          ]
        : [
            '0xffFFC5C5',
            '0xffCCDD87',
            '0xff82B4F2',
            '0xffDAC6E8',
            '0xffFFAEAE',
            '0xffF2DC34',
            '0xff6AB8C4',
            '0xff98D37F',
            '0xffF7B556',
            '0xffFFD394',
            '0xffFF768D',
            '0xffC598DE',
            '0xff4885D0',
            '0xffC7B299',
            '0xff1D6A96'
          ];

    List<String> colorCopy = []..addAll(colors);

    for (int i = 0; i < 5; i++) {
      if (timetable.tableBody[i].length > maxColumn) {
        maxColumn = timetable.tableBody[i].length;
      }
      for (int j = 0; j < timetable.tableBody[i].length; j++) {
        var firstTemp = timetable.tableBody[i][j][2].split(":");
        var lastTemp = timetable.tableBody[i][j][3].split(":");
        var tempHour = int.parse(firstTemp[0]);
        var tempMinute = int.parse(firstTemp[1]);
        var tempLastHour = int.parse(lastTemp[0]);
        var tempLastMinute = int.parse(lastTemp[1]);
        if (timetable.tableBody[i][j].length == 5) {
          timetable.tableBody[i][j].removeAt(4);
        }

        if (!className.containsKey(timetable.tableBody[i][j][0])) {
          if (colorCopy.length == 0) colorCopy = []..addAll(colors);
          className[timetable.tableBody[i][j][0]] = colorCopy[0];
          colorCopy.removeAt(0);
        }

        timetable.tableBody[i][j].add(time.classTime(
            // 수업시간 추가
            timetable.tableBody[i][j][2],
            timetable.tableBody[i][j][3]));
        if (timetable.tableBody[i].length != j + 1) {
          // 인덱스 레인지 아웃 예외 처리
          timetable.tableBody[i][j].add(time.restTime(
              // 수업시간 추가
              timetable.tableBody[i][j][3],
              timetable.tableBody[i][j + 1][2]));
        } else
          timetable.tableBody[i][j].add(0);

        if (firstHour >= tempHour) {
          firstHour = tempHour;
          if (firstMinute > tempMinute) {
            firstMinute = tempMinute;
          }
        }
        // 시간은 똑같은데 분이 더 높을 경우의 예외처리는 없음. => 수정필요
        if (tempLastHour >= lastHour) {
          lastHour = tempLastHour;
          lastMinute = tempLastMinute;
        }
      }
    }

    Map<String, dynamic> classInfo = {
      "monday": timetable.tableBody[0],
      "tuesday": timetable.tableBody[1],
      "wednesday": timetable.tableBody[2],
      "thursday": timetable.tableBody[3],
      "friday": timetable.tableBody[4],
      "maxColumn": maxColumn,
      "firstHour": firstHour,
      "lastHour": lastHour,
      "color": className
    };

    return classInfo;
  }
}
