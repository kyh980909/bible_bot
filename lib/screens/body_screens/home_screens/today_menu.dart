import 'package:bible_bot/communications/today_cafeteria_menu.dart';
import 'package:bible_bot/models/style_model.dart';
import 'package:bible_bot/screens/body_screens/home_screens/renewal_cafeteria_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodayMenu extends StatefulWidget {
  final String title;

  TodayMenu({Key key, @required this.title}) : super(key: key);

  @override
  _TodayMenuState createState() => _TodayMenuState();
}

class _TodayMenuState extends State<TodayMenu> {
  List<dynamic> todayMenu = [''];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final styleModel = Provider.of<StyleModel>(context);
    String themeData = Provider.of<String>(context);
    TodayCafeteriaMenu todayCafeteriaMenu =
        Provider.of<TodayCafeteriaMenu>(context);
    if (todayCafeteriaMenu.status == false) {
      todayMenu[0] = "아직 학식이 등록되지 않았습니다.";
    } else {
      switch (widget.title) {
        case "LUNCH":
          todayMenu = todayCafeteriaMenu.lunch['menus'];
          break;
        case "DINNER":
          todayMenu = todayCafeteriaMenu.dinner['menus'];
          break;
        case "DAILY":
          todayMenu = todayCafeteriaMenu.daily['menus'];
          break;
        case "FIX":
          todayMenu = todayCafeteriaMenu.fix['menus'];
          break;
      }
    }

    return Container(
      color: styleModel.getBackgroundColor()['greyLevel5'],
      child: RaisedButton(
        highlightElevation: 0,
        highlightColor: styleModel.getBackgroundColor()['highLightColor'],
        focusElevation: 0,
        elevation: 0,
        splashColor: styleModel.getBackgroundColor()['splashColor'],
        color: Colors.transparent,
        onPressed: () {
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (BuildContext context) => MultiProvider(providers: [
                Provider<StyleModel>.value(
                    value: StyleModel(context, currentTheme: themeData)),
              ], child: RenewalCafeteria()),
            ),
          );
        },
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.title,
                    style: styleModel.getTextStyle()['subtitleTextStyle'],
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Flexible(
                flex: 4,
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Text(
                            "${todayMenu[index]}",
                            style: styleModel.getTextStyle()['bodyTextStyle'],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 0,
                        indent: 0,
                        endIndent: 0,
                        color: Colors.transparent,
                      );
                    },
                    itemCount: todayMenu.length)),
          ],
        ),
      ),
    );
  }
}
