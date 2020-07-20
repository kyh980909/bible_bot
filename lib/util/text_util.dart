double textDynamicSize(String text, double deviceHeight) {
  RegExp kor = RegExp(r'[가-힣+]');
  RegExp etc = RegExp(r'[^가-힣+]');

  if (deviceHeight > 1200)
    return (kor.allMatches(text).length * 22.0) +
        (etc.allMatches(text).length * 14.5);
  else if (deviceHeight > 1000)
    return (kor.allMatches(text).length * 19.0) +
        (etc.allMatches(text).length * 13.0);
  else
    return (kor.allMatches(text).length * 15.5) +
        (etc.allMatches(text).length * 11.5);
}
