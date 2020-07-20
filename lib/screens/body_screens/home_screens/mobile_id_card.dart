import 'dart:convert';
import 'package:bible_bot/communications/user_information.dart';
import 'package:bible_bot/models/style_model.dart';
import 'package:bible_bot/screens/body_screens/home_screens/sliding_up_panel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MobileIdCard extends StatefulWidget {
  @override
  _MobileIdCardState createState() => _MobileIdCardState();
}

class _MobileIdCardState extends State<MobileIdCard>
    with SingleTickerProviderStateMixin {
  AnimationController _animation;
  PanelController _pc = new PanelController();
  var statusCheck = false;

  @override
  void initState() {
    _animation =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final styleModel = Provider.of<StyleModel>(context);
    UserInformation studentInfo = Provider.of<UserInformation>(context);
    return Container(
      color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              width: styleModel.getContextSize()['screenWidthLevel4'],
              child: Image.asset(
                'images/bottomLogo.png',
                colorBlendMode: BlendMode.modulate,
              ),
            ),
          ),
          Center(
            child: Container(
              height: styleModel.getContextSize()['screenHeightLevel4'],
              width: styleModel.getContextSize()['screenWidthLevel3'],
              child: Image.asset(
                'images/BackgroundLogo.png',
                color: Color.fromRGBO(255, 255, 255, 0.1),
                colorBlendMode: BlendMode.modulate,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Flexible(
                flex: 4,
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Image.memory(
                            base64Decode(studentInfo.studentImage.img),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: Column(
                            children: <Widget>[
                              Flexible(
                                flex: 3,
                                child: Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "${studentInfo.profile.name}",
                                    style: styleModel
                                        .getTextStyle()['titleTextStyle'],
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "${studentInfo.profile.sid}",
                                    style: styleModel
                                        .getTextStyle()['subtitleTextStyle'],
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${studentInfo.profile.major}",
                                    style: styleModel
                                        .getTextStyle()['bodyTitleTextStyle'],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: FadeTransition(
                            opacity: _animation,
                            child: Container(
                              child: GestureDetector(
                                  onTap: () {
                                    _pc.open();
                                  },
                                  child: Image.asset(
                                    "images/qr_code.png",
                                    height: styleModel.getContextSize()[
                                        'screenHeightLevel10'],
                                  )),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 14.0),
                            child: Container(
                              child: Text(
                                "QR코드를 생성하려면 아이콘을 누르세요. ",
                                style: styleModel
                                    .getTextStyle()['bodyTitleTextStyle'],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              )
            ],
          ),
          MobileCardSlidingUpPanel(
            pc: _pc,
          ),
        ],
      ),
    );
  }
}
