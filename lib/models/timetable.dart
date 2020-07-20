class Timetable {
  final List tableHead;
  final List tableBody;

  Timetable({this.tableHead, this.tableBody});
  // json 직렬화 -> 데이터로 변경
  factory Timetable.fromJson(Map<String, dynamic> json) {
    return new Timetable(tableHead: json['head'], tableBody: json['body']);
  }
}
