import 'dart:convert';

class Img {
  final String img;
  final int width;
  final int height;

  Img({this.img, this.width, this.height});

  factory Img.fromJson(Map<String, dynamic> json) {
    json = jsonDecode(json['data'])['data'];
    return new Img(
        img: json['img'], width: json['width'], height: json['height']);
  }
}
