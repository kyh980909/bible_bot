import 'package:bible_bot/widgets/flutter_restart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/style_model.dart';

class ThemeScreen extends StatefulWidget {
  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  String themeData;

  @override
  Widget build(BuildContext context) {
    final styleModel = Provider.of<StyleModel>(context);
    themeData = Provider.of<String>(context);

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            '테마',
            style: styleModel.getTextStyle()['appBarTextStyle'],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: styleModel.getBackgroundColor()['reversalColorLevel1']),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
          brightness: styleModel.getBrightness()['appBarBrightness'],
          backgroundColor:
              styleModel.getBackgroundColor()['backgroundColorLevel1']),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      // 블랙테마 옵션
                      Flexible(
                        flex: 1,
                        child: RaisedButton(
                          highlightElevation: 0,
                          highlightColor:
                              styleModel.getBackgroundColor()['highLightColor'],
                          focusElevation: 0,
                          elevation: 0,
                          color: Colors.transparent,
                          splashColor:
                              styleModel.getBackgroundColor()['splashColor'],
                          onPressed: () {
                            if (themeData == "black") {
                              Navigator.pop(context);
                            } else {
                              StyleModel(context).setBlackTheme();
                              // 다시시작
                              RestartWidget.of(context).restartApp();

                              // 앱 종료
//                              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Icon(
                                      Icons.wb_incandescent,
                                      color: styleModel
                                          .getIconColor()['themeIconColor'],
                                      size: styleModel
                                          .getContextSize()['middleIconSize'],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 14.0),
                                      child: Text(
                                        "블랙테마",
                                        style: styleModel
                                            .getTextStyle()['bodyTextStyle'],
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: styleModel
                                        .getIconColor()['noticeBlackThemeIcon'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 1.0,
                        width: styleModel.getContextSize()['screenWidthLevel1'],
                        color: styleModel.getBackgroundColor()['greyLevel6'],
                      ),
                      // 화이트 테마 옵션
                      Flexible(
                        flex: 1,
                        child: RaisedButton(
                          highlightElevation: 0,
                          highlightColor:
                              styleModel.getBackgroundColor()['highLightColor'],
                          focusElevation: 0,
                          elevation: 0,
                          splashColor:
                              styleModel.getBackgroundColor()['splashColor'],
                          color: Colors.transparent,
                          onPressed: () {
                            if (themeData == "white") {
                              Navigator.pop(context);
                            } else {
                              StyleModel(context).setWhiteTheme();
                              RestartWidget.of(context).restartApp();
                              // 앱 종료 => 안드로이드만 작동하므로 대책필요
//                              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Icon(
                                      Icons.whatshot,
                                      color: styleModel
                                          .getIconColor()['themeIconColor'],
                                      size: styleModel
                                          .getContextSize()['middleIconSize'],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 14.0),
                                      child: Text(
                                        "화이트테마",
                                        style: styleModel
                                            .getTextStyle()['bodyTextStyle'],
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: styleModel
                                        .getIconColor()['noticeWhiteThemeIcon'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 1.0,
                width: styleModel.getContextSize()['screenWidthLevel1'],
                color: styleModel.getBackgroundColor()['greyLevel6'],
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
            ],
          )),
    );
  }
}
