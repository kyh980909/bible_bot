import 'package:bible_bot/communications/today_cafeteria_menu.dart';
import 'package:bible_bot/models/style_model.dart';
import 'package:bible_bot/screens/body_screens/home_screens/nonmember_screen.dart';
import 'package:bible_bot/screens/login_screens/login_screen.dart';
import 'package:bible_bot/widgets/width_division_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NoticeScreen extends StatefulWidget {
  @override
  _NoticeScreenState createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final styleModel = Provider.of<StyleModel>(context);
    var themeData = Provider.of<String>(context);
    TodayCafeteriaMenu todayCafeteriaMenu =
        Provider.of<TodayCafeteriaMenu>(context);
    if (themeData == "black" || themeData == "white") {
    } else {
      themeData = "white";
    }

    return Scaffold(
      body: Container(
        height: styleModel.getContextSize()['fullScreenHeight'],
        width: styleModel.getContextSize()['fullScreenWidth'],
        child: Container(
          color: themeData == "white" ? Colors.white : Colors.grey[900],
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Flexible(
                  flex: 2,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("images/logo.png"),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "성서봇",
                          style: TextStyle(
                              fontSize: styleModel
                                  .getContextSize()['screenHeightLevel12'],
                              fontWeight: FontWeight.bold,
                              color: Color(0xff5cbbeb)),
                        ),
                      )
                    ],
                  )),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Flexible(
                  flex: 2,
                  child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 15.0, bottom: 10.0),
                            child: Container(
                              height: styleModel
                                  .getContextSize()['screenHeightLevel10'],
                              width: styleModel
                                  .getContextSize()['screenWidthLevel4'],
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () async {
                                  Navigator.of(context).pushReplacement(
                                    new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MultiProvider(providers: [
                                        Provider<StyleModel>.value(
                                            value: StyleModel(context,
                                                currentTheme: themeData)),
                                        Provider<String>.value(
                                            value: themeData),
                                        Provider<TodayCafeteriaMenu>(
                                            create: (context) =>
                                                todayCafeteriaMenu),
                                      ], child: LoginPage()),
                                    ),
                                  );
                                },
                                color: Colors.blue[300],
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        alignment: Alignment.center,
                                        child: Text("인트라넷으로 시작",
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  styleModel.getContextSize()[
                                                      'screenHeightLevel14'],
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.arrow_right,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              height: styleModel
                                  .getContextSize()['screenHeightLevel10'],
                              width: styleModel
                                  .getContextSize()['screenWidthLevel4'],
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () async {
                                  Navigator.of(context).push(
                                    new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MultiProvider(providers: [
                                        Provider<StyleModel>.value(
                                            value: StyleModel(context,
                                                currentTheme: themeData)),
                                        Provider<String>.value(
                                            value: themeData),
                                        Provider<TodayCafeteriaMenu>(
                                            create: (context) =>
                                                todayCafeteriaMenu),
                                      ], child: NonMemberScreen()),
                                    ),
                                  );
                                },
                                color: Colors.grey[700],
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      alignment: Alignment.center,
                                      child: Text("비회원으로 시작",
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                styleModel.getContextSize()[
                                                    'screenHeightLevel14'],
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        Icons.arrow_right,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))),
              Expanded(
                flex: 1,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
