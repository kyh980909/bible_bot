import 'package:bible_bot/models/chapel.dart';

class HomeScreenInfomation{

  Chapel chapelInfo;
  String balance;

  HomeScreenInfomation({this.chapelInfo, this.balance});

  factory HomeScreenInfomation.fromJson(Map<String, dynamic> json) {
    return new HomeScreenInfomation(
        chapelInfo: json['chapel'], balance: json['money']);
  }

}