import 'package:bible_bot/communications/today_cafeteria_menu.dart';
import 'package:bible_bot/models/style_model.dart';
import 'package:bible_bot/screens/basic_screens/notice_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bible_bot/screens/login_screens/login_control.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with LoginControl {
  final _formKey = GlobalKey<FormState>();

  // 텍스트필드 컨트롤러 삭제
  final FocusNode _pwFocus = FocusNode(); // pw 포커스
  Color autoLoginButtonColor = Colors.blueAccent;
  bool autoLogin = true;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final styleModel = Provider.of<StyleModel>(context);
    var themeData = Provider.of<String>(context);
    TodayCafeteriaMenu todayCafeteriaMenu =
        Provider.of<TodayCafeteriaMenu>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false, // 화면 밀림 방지
      body: Builder(builder: (context) {
        return Container(
          height: styleModel.getContextSize()['fullScreenHeight'],
          width: styleModel.getContextSize()['fullScreenWidth'],
          color: themeData == "white"
              ? Colors.white
              : styleModel.getBackgroundColor()['backgroundColorLevel2'],
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 14.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    width: double.infinity,
                    height: double.infinity,
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MultiProvider(providers: [
                                Provider<StyleModel>.value(
                                    value: StyleModel(context,
                                        currentTheme: themeData)),
                                Provider<String>.value(value: themeData),
                                Provider<TodayCafeteriaMenu>(
                                    create: (context) => todayCafeteriaMenu),
                              ], child: NoticeScreen()),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.grey[800],
                        )),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: Image.asset("images/logo.png"),
                ),
              ),
              Flexible(
                flex: 6,
                child: Container(
                  child: Form(
                    key: _formKey,
                    child: Stack(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: styleModel
                                  .getContextSize()['screenWidthLevel3'],
                              height: styleModel
                                  .getContextSize()['screenHeightLevel10'],
                              child: Theme(
                                data: new ThemeData(
                                  hintColor: styleModel.getBackgroundColor()[
                                      'reversalColorLevel1'],
                                ),
                                child: TextFormField(
                                  cursorColor: Colors.blueAccent,
                                  style: TextStyle(
                                    color: styleModel.getBackgroundColor()[
                                        'reversalColorLevel1'],
                                    fontSize: styleModel
                                        .getContextSize()['smallFontSize'],
                                  ),
                                  textInputAction: TextInputAction.next,
                                  decoration: new InputDecoration(
                                    labelStyle: TextStyle(
                                        color: styleModel.getBackgroundColor()[
                                            'reversalColorLevel1']),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.red)),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey[500]),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.blueAccent),
                                    ),
                                    labelText: '아이디 입력',
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.red)),
                                  ),
                                  onSaved: (String value) {
                                    email = value;
                                  },
                                  validator: validateEmail,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context)
                                        .requestFocus(_pwFocus);
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                width: styleModel
                                    .getContextSize()['screenWidthLevel3'],
                                height: styleModel
                                    .getContextSize()['screenHeightLevel10'],
                                child: Theme(
                                  data: new ThemeData(
                                    hintColor: Colors.white,
                                  ),
                                  child: TextFormField(
                                    // 숫자 입력 키보드
                                    cursorColor: Colors.blueAccent,
                                    focusNode: _pwFocus,
                                    // 포커스 생성
                                    style: TextStyle(
                                      color: styleModel.getBackgroundColor()[
                                          'reversalColorLevel1'],
                                      fontSize: styleModel
                                          .getContextSize()['smallFontSize'],
                                    ),
                                    textInputAction: TextInputAction.done,
                                    // 엔터키 텍스트
                                    obscureText: true,
                                    decoration: new InputDecoration(
                                      labelStyle: TextStyle(
                                          color:
                                              styleModel.getBackgroundColor()[
                                                  'reversalColorLevel1']),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.red)),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[500]),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.red)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.blueAccent),
                                      ),
                                      labelText: '비밀번호 입력',
                                    ),

                                    onSaved: (String value) {
                                      password = value;
                                    },
                                    validator: validatePassword,
                                    onFieldSubmitted: (temp) async {},
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: styleModel.getContextSize()[
                                          'screenWidthLevel2'] -
                                      30,
                                  height: styleModel.getContextSize()[
                                          'screenHeightLevel10'] -
                                      10,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 5.0, left: 5.0),
                                    child: GestureDetector(
                                      onDoubleTap: () {},
                                      onTap: () {},
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        color: Colors.blue[300],
                                        onPressed: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            _formKey.currentState.save();
                                            // 키보드 닫기 => 에러 수정해야함 로그인 실패시 예외처리
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());

                                            Future.delayed(
                                                Duration(milliseconds: 500),
                                                () async {
                                              await requestLogin(context,
                                                  themeData, email, password,
                                                  autoLoginPermission:
                                                      autoLogin,
                                                  type: 2);
                                            });
                                          }
                                        },
                                        child: Text("로그인",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  styleModel.getContextSize()[
                                                      'smallFontSize'],
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                  Flexible(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 14.0, left: 8.0),
                                      child: InkWell(
                                        child: Container(
                                            alignment: Alignment.bottomLeft,
                                            child: Row(children: <Widget>[
                                              Icon(
                                                Icons.check_circle_outline,
                                                color: autoLoginButtonColor,
                                                size:
                                                    styleModel.getContextSize()[
                                                        'bigIconSize'],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, bottom: 2.0),
                                                child: Container(
                                                  child: Text("자동 로그인",
                                                      style: TextStyle(
                                                        fontSize: styleModel
                                                                .getContextSize()[
                                                            'smallFontSize'],
                                                        color: styleModel
                                                                .getBackgroundColor()[
                                                            'reversalColorLevel1'],
                                                      )),
                                                ),
                                              )
                                            ])),
                                        onTap: () {
                                          autoLogin == true
                                              ? autoLogin = false
                                              : autoLogin = true;
                                          setState(() {
                                            autoLogin == true
                                                ? autoLoginButtonColor =
                                                    Colors.blue[300]
                                                : autoLoginButtonColor =
                                                    Colors.black;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 5,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Flexible(
                flex: 5,
                child: Container(),
              )
            ],
          ),
        );
      }),
    );
  }
}
