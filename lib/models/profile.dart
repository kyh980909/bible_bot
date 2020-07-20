import 'dart:convert';

class Profile {
  final String sid;
  final String name;
  final String major;

  Profile({this.sid, this.name, this.major});

  factory Profile.fromJson(Map<String, dynamic> json) {
    json = jsonDecode(json['data'])['data'];
    return new Profile(
        sid: json['sid'], name: json['name'], major: json['major']);
  }
}
