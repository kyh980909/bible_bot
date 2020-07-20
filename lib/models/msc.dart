class Msc {
  final String img;
  final String width;
  final String height;

  Msc({this.img, this.width, this.height});

  factory Msc.fromJson(Map<String, dynamic> json) {
    return new Msc(
        img: json['img'], width: json['width'], height: json['height']);
  }
}
