class Chapel {
  final Summary summary; // 채플요약
  final List tableHead;
  final List tableBody;

  Chapel({this.summary, this.tableHead, this.tableBody});
  // json 직렬화 -> 데이터로 변경
  factory Chapel.fromJson(Map<String, dynamic> json) {
    return new Chapel(
        summary: Summary.fromJson(json['summary']),
        tableHead: json['head'],
        tableBody: json['body']);
  }
}

class Summary {
  final String classOfWeek; // 주중수업일수
  final String dayOfRule; // 규정일수
  final String attendance; // 출석
  final String tardy; // 지각
  final String confirm; // 확정

  Summary(
      {this.classOfWeek,
      this.dayOfRule,
      this.attendance,
      this.tardy,
      this.confirm});

  factory Summary.fromJson(Map<String, dynamic> json) {
    return new Summary(
        classOfWeek: json['주중수업일수'] == '' || json['주중수업일수'] == null
            ? '1'
            : json['주중수업일수'],
        dayOfRule:
            json['규정일수'] == '' || json['규정일수'] == null ? '1' : json['규정일수'],
        attendance: json['출석'],
        tardy: json['지각'],
        confirm: json['확정']);
  }
}
