import 'package:bible_bot/models/style_model.dart';
import 'package:bible_bot/widgets/width_division_line.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SpecialThanksTo extends StatefulWidget {
  @override
  _SpecialThanksToState createState() => _SpecialThanksToState();
}

class _SpecialThanksToState extends State<SpecialThanksTo>
    with TickerProviderStateMixin {
  AnimationController animation;
  Animation<double> _fadeInFadeOut;



  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 0.5).animate(animation);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
      } else if (status == AnimationStatus.dismissed) {
        animation.forward();
      }
    });
    animation.forward();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StyleModel styleModel = Provider.of<StyleModel>(context);
    return FadeTransition(
      opacity: _fadeInFadeOut,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Column(children: <Widget>[
                  Flexible(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "SPEICAL",
                          style: styleModel.getTextStyle()['headerTextStyle'],
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.topCenter,
                        child: Text(
                          "THANKS",
                          style: styleModel.getTextStyle()['headerTextStyle'],
                        ),
                      )),
                  Flexible(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 3,
                            child: Container(
                                child: Column(
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      width: styleModel.getContextSize()[
                                          'screenWidthLevel9'],
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 2))),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(),
                                )
                              ],
                            )),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                                alignment: Alignment.center,
                                child: Text("TO",
                                    style: styleModel
                                        .getTextStyle()['titleTextStyle'])),
                          ),
                          Flexible(
                            flex: 3,
                            child: Container(
                                child: Column(
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: styleModel.getContextSize()[
                                          'screenWidthLevel9'],
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 2))),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(),
                                )
                              ],
                            )),
                          ),
                        ],
                      ),
                    ),
                  )
                ]),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                "김태희(간호 17)",
                                style: styleModel.getTextStyle(
                                        color: styleModel.getBackgroundColor()[
                                            'reversalColorLevel1'])[
                                    'subtitleTextStyle'],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              alignment: Alignment.topCenter,
                              child: Text(
                                "아이디어 제공, 포토샵 작업",
                                style: styleModel
                                    .getTextStyle()['bodyTitleTextStyle'],
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                    WidthDivisionLine(),
                    Flexible(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              alignment: Alignment.center,
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "김선아(사복 17)",
                                        style: styleModel.getTextStyle(
                                                color: styleModel
                                                        .getBackgroundColor()[
                                                    'reversalColorLevel1'])[
                                            'subtitleTextStyle'],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      alignment: Alignment.centerLeft,
                                      child: RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: " @a._.gzag",
                                            style: styleModel.getTextStyle(
                                                    color: styleModel
                                                            .getBackgroundColor()[
                                                        'reversalColorLevel1'])[
                                                'subtitleTextStyle'],
                                            recognizer: new TapGestureRecognizer()
                                              ..onTap = () { launch('https://instagram.com/a._.gzag?igshid=ea0ml8zoh9y3');
                                              },
                                          )
                                        ]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              alignment: Alignment.topCenter,
                              child: Text(
                                "시간표캐릭터 디자인",
                                style: styleModel
                                    .getTextStyle()['bodyTitleTextStyle'],
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                    WidthDivisionLine(),
                    Flexible(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                "임혜리(컴소 16)",
                                style: styleModel.getTextStyle(
                                        color: styleModel.getBackgroundColor()[
                                            'reversalColorLevel1'])[
                                    'subtitleTextStyle'],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              alignment: Alignment.topCenter,
                              child: Text(
                                "성서봇 로고 디자인",
                                style: styleModel
                                    .getTextStyle()['bodyTitleTextStyle'],
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                    WidthDivisionLine(),
                    Flexible(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                "박현주(컴소 17)",
                                style: styleModel.getTextStyle(
                                        color: styleModel.getBackgroundColor()[
                                            'reversalColorLevel1'])[
                                    'subtitleTextStyle'],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              alignment: Alignment.topCenter,
                              child: Text(
                                "아이디어 제공, 포토샵 작업",
                                style: styleModel
                                    .getTextStyle()['bodyTitleTextStyle'],
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
