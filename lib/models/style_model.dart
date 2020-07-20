import 'package:bible_bot/widgets/hex_to_color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StyleModel {
  StyleModel(this.context, {this.currentTheme});

  BuildContext context;
  Size size;
  Map<String, dynamic> contextSize;
  Map<String, TextStyle> textStyle;
  Map<String, Color> backgroundColor;
  Map<String, dynamic> theme;
  Map<String, dynamic> alertDialogOption;
  Map<String, dynamic> homeScreenOption;
  Map<String, dynamic> iconColor;
  Map<String, dynamic> brightness;
  Map<String, dynamic> divisionLine;
  Color signatureColor = Colors.green[200];
  Color whiteColor = Colors.white;
  Color blackColor = hexToColor("#121212");
  Color greyColor = Colors.grey;
  String settingMode;
  String currentTheme;

  Future<String> getSettingMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    settingMode = prefs.getString("theme");

    return settingMode;
  }

  void setWhiteTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', null);
    prefs.setString('theme', 'white');
  }

  void setBlackTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', null);
    prefs.setString('theme', 'black');
  }

  // 화면 사이즈 지정
  Map<String, dynamic> getContextSize() {
    size = MediaQuery.of(context).size;

    contextSize = {
      'fullScreenHeight': size.height * 1,
      'screenHeightLevel1': size.height * 0.9,
      'screenHeightLevel2': size.height * 0.8,
      'screenHeightLevel3': size.height * 0.7,
      'screenHeightLevel4': size.height * 0.6,
      'screenHeightLevel5': size.height * 0.5,
      'screenHeightLevel6': size.height * 0.4,
      'screenHeightLevel7': size.height * 0.3,
      'screenHeightLevel8': size.height * 0.2,
      'screenHeightLevel8.5': size.height * 0.15,
      'screenHeightLevel9': size.height * 0.1,
      'screenHeightLevel10': size.height * 0.07,
      'screenHeightLevel11': size.height * 0.05,
      'screenHeightLevel12': size.height * 0.04,
      'screenHeightLevel13': size.height * 0.03,
      'screenHeightLevel14': size.height * 0.02,
      'screenHeightLevel15': size.height * 0.015,
      'fullScreenWidth': size.width * 1,
      'screenWidthLevel1': size.width * 0.9,
      'screenWidthLevel2': size.width * 0.8,
      'screenWidthLevel3': size.width * 0.7,
      'screenWidthLevel4': size.width * 0.6,
      'screenWidthLevel5': size.width * 0.5,
      'screenWidthLevel6': size.width * 0.4,
      'screenWidthLevel7': size.width * 0.3,
      'screenWidthLevel8': size.width * 0.2,
      'screenWidthLevel9': size.width * 0.1,
      'bigestIconSize': size.height * 0.05,
      'bigIconSize': size.height * 0.03,
      'middleIconSize': size.height * 0.02,
      'smallIconSize': size.height * 0.015,
      'smallFontSize': size.height * 0.015,
    };

    return contextSize;
  }

  Map<String, dynamic> getBackgroundColor() {
    if (currentTheme == "black") {
      backgroundColor = {
        'backgroundColorLevel1': blackColor,
        'backgroundColorLevel2': blackColor.withOpacity(0.97),
        'backgroundColorLevel3': blackColor.withOpacity(0.85),
        'backgroundColorLevel4': blackColor.withOpacity(0.81),
        'backgroundColorLevel5': blackColor.withOpacity(0.61),
        'reversalColorLevel1': whiteColor.withOpacity(0.9),
        'reversalColorLevel2': whiteColor.withOpacity(0.85),
        'greyLevel1': greyColor.withOpacity(0.9),
        'greyLevel2': greyColor.withOpacity(0.85),
        'greyLevel3': greyColor.withOpacity(0.7),
        'greyLevel4': greyColor.withOpacity(0.25),
        'greyLevel5': greyColor.withOpacity(0.1),
        'greyLevel6': greyColor.withOpacity(0.05),
        'greyLevel7': greyColor.withOpacity(0.03),
        'greyLevel8': greyColor.withOpacity(0.01),
        'greyLevel9': blackColor.withOpacity(0.9),
        'highLightColor': blackColor.withOpacity(0.7),
        'splashColor': greyColor.withOpacity(0.95),
        'whiteLevel1': whiteColor.withOpacity(0.9),
        'greenLevel1': Colors.indigo[200],
      };
    } else {
      backgroundColor = {
        'backgroundColorLevel1': whiteColor,
        'backgroundColorLevel2': whiteColor.withOpacity(0.9),
        'backgroundColorLevel3': whiteColor.withOpacity(0.90),
        'backgroundColorLevel4': whiteColor.withOpacity(0.87),
        'backgroundColorLevel5': whiteColor.withOpacity(0.61),
        'reversalColorLevel1': blackColor.withOpacity(0.98),
        'reversalColorLevel2': blackColor.withOpacity(0.48),
        'greyLevel1': greyColor.withOpacity(0.8),
        'greyLevel2': greyColor.withOpacity(0.6),
        'greyLevel3': greyColor.withOpacity(0.4),
        'greyLevel4': greyColor.withOpacity(0.1),
        'greyLevel5': greyColor.withOpacity(0.08),
        'greyLevel6': greyColor.withOpacity(0.06),
        'greyLevel7': greyColor.withOpacity(0.04),
        'greyLevel8': greyColor.withOpacity(0.02),
        'greyLevel9': greyColor.withOpacity(0.01),
        'highLightColor': whiteColor.withOpacity(0.7),
        'splashColor': greyColor.withOpacity(0.2),
        'whiteLevel1': whiteColor.withOpacity(0.9),
        'greenLevel1': Colors.green[200]
      };
    }
    return backgroundColor;
  }

  // 기본 텍스트 스타일
  Map<String, TextStyle> getTextStyle(
      {Color color, double fontSize, FontWeight fontWeight}) {
    size = MediaQuery.of(context).size;

    if (currentTheme == "black") {
      textStyle = {
        'headerTextStyle': TextStyle(
          fontSize: size.height * 0.050,
          color: color == null ? Colors.white : color,
          fontWeight: FontWeight.w300,
        ),
        'titleTextStyle': TextStyle(
          fontSize: size.height * 0.029,
          color: color == null ? Colors.white : color,
          fontWeight: FontWeight.w600,
        ),
        'subtitleTextStyle': TextStyle(
          fontSize: size.height * 0.020,
          color: color == null ? Colors.grey[200] : color,
          fontWeight: FontWeight.w600,
        ),
        'bodyTitleTextStyle': TextStyle(
          fontSize: size.height * 0.018,
          color: Colors.grey[300],
          fontWeight: FontWeight.w600,
        ),
        'bodyTextStyle': TextStyle(
          fontSize:
              fontSize == null ? size.height * 0.015 : size.height * fontSize,
          color: color == null ? Colors.white : color,
          fontWeight: fontWeight == null ? FontWeight.w600 : fontWeight,
        ),
        'smallBodyTextStyle': TextStyle(
          color: color == null ? Colors.grey[200] : color,
          fontSize: size.height * 0.013,
        ),
        'appBarTextStyle': TextStyle(
          color: Colors.white,
          fontSize: size.height * 0.02,
          fontWeight: FontWeight.w600,
        ),
        'footnoteTextStyle': TextStyle(
          color: color == null ? Colors.grey[200] : color,
          fontSize: size.height * 0.012,
        ),
      };
    } else {
      textStyle = {
        'headerTextStyle': TextStyle(
          fontSize: size.height * 0.05,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        'titleTextStyle': TextStyle(
            color: color == null ? blackColor.withOpacity(0.7) : color,
            fontSize: size.height * 0.029,
            fontWeight: FontWeight.w600),
        'subtitleTextStyle': TextStyle(
          fontSize: size.height * 0.02,
          color: color == null ? blackColor.withOpacity(0.6) : color,
          fontWeight: FontWeight.w600,
        ),
        'bodyTitleTextStyle': TextStyle(
            fontSize: size.height * 0.018,
            color: blackColor.withOpacity(0.6),
            fontWeight: FontWeight.w600),
        'bodyTextStyle': TextStyle(
          fontSize:
              fontSize == null ? size.height * 0.015 : size.height * fontSize,
          color: color == null ? blackColor.withOpacity(0.8) : color,
          fontWeight: fontWeight == null ? FontWeight.w600 : fontWeight,
        ),
        'smallBodyTextStyle': TextStyle(
          color: color == null ? blackColor.withOpacity(0.6) : color,
          fontSize: size.height * 0.013,
        ),
        'appBarTextStyle': TextStyle(
          color: blackColor.withOpacity(0.7),
          fontSize: size.height * 0.02,
          fontWeight: FontWeight.w600,
        ),
        'footnoteTextStyle': TextStyle(
          color: color == null ? blackColor : color,
          fontSize: size.height * 0.012,
        ),
      };
    }
    return textStyle;
  }

  Map<String, dynamic> getBrightness() {
    if (currentTheme == 'black') {
      brightness = {
        'statusIconBrightness': Brightness.light,
        'appBarBrightness': Brightness.dark,
      };
    } else {
      brightness = {
        'statusIconBrightness': Brightness.dark,
        'appBarBrightness': Brightness.light,
      };
    }

    return brightness;
  }

  Map<String, dynamic> getIconColor() {
    if (currentTheme == "black") {
      iconColor = {
        'themeIconColor': whiteColor,
        'noticeBlackThemeIcon': Padding(
          padding: const EdgeInsets.only(right: 14.0),
          child: Icon(
            Icons.check,
            color: Colors.green[200],
            size: size.height * 0.035,
          ),
        ),
        'noticeWhiteThemeIcon': null,
      };
    } else {
      iconColor = {
        'themeIconColor': blackColor.withOpacity(0.4),
        'noticeBlackThemeIcon': null,
        'noticeWhiteThemeIcon': Padding(
          padding: const EdgeInsets.only(right: 14.0),
          child: Icon(
            Icons.check,
            color: Colors.green[200],
            size: size.height * 0.035,
          ),
        ),
      };
    }
    return iconColor;
  }

  // 일반 테마
  Map<String, dynamic> getDivisionLineStyle() {
    size = MediaQuery.of(context).size;

    divisionLine = {
      'longDivisionLineHeight': size.height * 0.05,
      'longDivisionLineWidth': size.width * 0.93,
      'divisionLineColor': greyColor.withOpacity(0.1),
    };
    return divisionLine;
  }
}
