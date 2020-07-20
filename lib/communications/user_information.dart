

import 'package:bible_bot/models/img.dart';
import 'package:bible_bot/models/profile.dart';

class UserInformation{

  Profile profile;
  Img studentImage;

  UserInformation({this.profile, this.studentImage});

  factory UserInformation.fromJson(Map<String, dynamic> json) {
    return new UserInformation(
       profile: json['info'], studentImage: json['img']);
  }

}