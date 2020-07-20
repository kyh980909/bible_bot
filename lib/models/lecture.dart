class Lecture {
  final List tableHead;
  final List tableBody;

  Lecture({this.tableHead, this.tableBody});
  // json 직렬화 -> 데이터로 변경
  factory Lecture.fromJson(Map<String, dynamic> json) {
    return new Lecture(
      tableHead: json['head'],
      tableBody: json['body'],
    );
  }
}
