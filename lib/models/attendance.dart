class Attendance {
  final summary;
  final List tableHead;
  final List tableBody;
  final extra;

  Attendance({this.summary, this.tableHead, this.tableBody, this.extra});

  // json 직렬화 -> 데이터로 변경
  factory Attendance.fromJson(Map<String, dynamic> json) {
    return new Attendance(
        summary: json['summary'],
        tableHead: json['head'],
        tableBody: json['body'],
        extra: json['extra']);
  }
}
