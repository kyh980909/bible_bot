class Time {
  // 시:분을 분으로
  int hourToMinute(hour) {
    int hh = int.parse(hour.split(':')[0]); // 시간
    int mm = int.parse(hour.split(':')[1]); // 분

    int minute = (hh * 60) + mm; //시:분을 분으로 변경

    return minute;
  }

  // 시:분:초를 초로
  int hourToSecond(hour) {
    int hh = int.parse(hour.split(':')[0]); // 시간
    int mm = int.parse(hour.split(':')[1]); // 분
    int ss = 0;

    if (hour.split(':').length == 3) ss = int.parse(hour.split(':')[2]); // 초

    int second = (hh * 60 * 60) + (mm * 60) + ss; //시:분을 분으로 변경

    return second;
  }

  String secondToHour(int second) {
    double leftTime = second.toDouble();
    String hh = '';
    String mm = '';
    String ss = '';

    if (second % 3600 == 0) {
      hh = (second ~/ 3600).toString().padLeft(2, '0');
      return '$hh:00:00';
    }
    hh = (second ~/ 3600).toString().padLeft(2, '0');
    leftTime = leftTime % 3600;
    mm = (leftTime ~/ 60).toString().padLeft(2, '0');
    leftTime = leftTime % 60;
    ss = leftTime.toInt().toString().padLeft(2, '0');

    return '$hh:$mm:$ss';
  }

  int minuteToSecond(int minute) => minute * 60;

  // 시간 차이 계산
  int classTime(start, end) {
    int startMinute = hourToMinute(start);
    int endMinute = hourToMinute(end);

    return endMinute - startMinute;
  }

  // 쉬는시간 계산
  int restTime(front, back) {
    //앞 수업 끝나는 시간과 뒷 수업 시작하는 시간의 차이로 쉬는시간 계산
    int endMinute = hourToMinute(front); // 앞 수업 끝나는 시간
    int startMinute = hourToMinute(back); // 뒷 수업 시작하는 시간

    return startMinute - endMinute;
  }

  bool compareTime(comp1, comp2) {
    // 시간 비교 메서드
    return comp1 == hourToMinute(comp2) / 60 ? true : false;
  }

  int subTime(firstHour, firstClass) {
    return hourToMinute(firstClass) - firstHour * 60;
  }
}
