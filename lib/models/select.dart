class Select {
  final String selected;
  final List<String> selectable;

  Select({this.selected, this.selectable});
  // json 직렬화 -> 데이터로 변경
  factory Select.fromJson(Map<String, dynamic> json) {
    return new Select(
      selected: json['selected'],
      selectable: (json['selectable'] as List<dynamic>).cast<String>(),
    );
  }
}
