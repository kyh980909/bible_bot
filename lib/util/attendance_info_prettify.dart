class AttendanceInfoPrettify {
  var pattern = RegExp(r'\(([가-힣])\)([^(]+)?');

  String prettify(String text) {
    Map<String, List> cd = classify(text);
    text = toText(cd);
    return text;
  }

  Map<String, List> classify(String text) {
    Map<String, List> result = Map<String, List>();
    for (var p in pattern.allMatches(text)) {
      if (result.containsKey(p.group(2)))
        result[p.group(2)].add(p.group(1));
      else
        result[p.group(2)] = [p.group(1)];
    }
    return result;
  }

  String toText(Map<String, List> classifiedData) {
    List result = [];
    for (MapEntry<String, List> item in classifiedData.entries) {
      result.add('(${item.value.join(', ')}) ${item.key}');
    }
    return result.join(', ');
  }
}
