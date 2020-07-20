import 'package:bible_bot/models/style_model.dart';
import 'package:bible_bot/screens/body_screens/home_screens/special_thanks_to.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeveloperScreen extends StatefulWidget {
  @override
  _DeveloperScreenState createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends State<DeveloperScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _glowAnimation;

  Map<String, dynamic> kyungminLee = {
    'id': "컴소15",
    'koreanName': "이경민",
    'englishName': "Kyungmin Lee",
    'nickname': "완벽을 추구하는 깐깐징어",
    'email': "rekyungmin@gmail.com",
    'role': "벡엔드 개발"
  };
  Map<String, dynamic> dongkyuShin = {
    "id": "컴소13",
    'koreanName': "신동규",
    'englishName': "Dongkyu Shin",
    'nickname': "잠수 전문(010-9041-1019)",
    'email': "dongkyu9410@gmail.com",
    'role': "웹 / 학식"
  };
  Map<String, dynamic> mincheolShin = {
    "id": "컴소15",
    'koreanName': "신민철",
    'englishName': "Mincheol Shin",
    'nickname': "성실한 부하직원",
    'email': "mc.shin@protonmail.com",
    'role': "모바일 앱 개발"
  };
  Map<String, dynamic> yonghoKim = {
    "id": "컴소17",
    'koreanName': "김용호",
    'englishName': "Yongho Kim",
    'nickname': "모쏠 ~ing",
    'email': "kyh980909@gmail.com",
    'role': "모바일 앱 개발"
  };
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    _glowAnimation = Tween(begin: 2.0, end: 15.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StyleModel styleModel = Provider.of<StyleModel>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, build) {
        return MediaQuery(
          child: DefaultTabController(
            length: 2,
            child: new Scaffold(
              body: new NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    new SliverAppBar(
                      automaticallyImplyLeading: true,
                      backgroundColor: styleModel
                          .getBackgroundColor()['backgroundColorLevel1'],
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: styleModel
                                .getBackgroundColor()['reversalColorLevel1']),
                        onPressed: () => Navigator.pop(context),
                      ),
                      brightness:
                          styleModel.getBrightness()['appBarBrightness'],
                      title: Text(
                        "만든이들",
                        style: styleModel.getTextStyle()['appBarTextStyle'],
                      ),
                      floating: true,
                      pinned: true,
                      snap: true,
                      bottom: new TabBar(
                        tabs: [
                          new Tab(text: "개발자들"),
                          new Tab(text: "도움 주신 분들"),
                        ],
                        labelStyle:
                            styleModel.getTextStyle()['bodyTitleTextStyle'],
                        unselectedLabelStyle:
                            styleModel.getTextStyle()['bodyTextStyle'],
                        indicatorColor:
                            styleModel.getBackgroundColor()['greenLevel1'],
                        indicatorWeight: 3.0,
                        labelColor: styleModel
                            .getBackgroundColor()['reversalColorLevel1'],
                        unselectedLabelColor:
                            styleModel.getBackgroundColor()['greyLevel2'],
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  children: <Widget>[
                    // 개발자
                    Container(
                        color: styleModel
                            .getBackgroundColor()['backgroundColorLevel2'],
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: developerLayout(context, kyungminLee),
                            ),
                            Flexible(
                              flex: 1,
                              child: developerLayout(context, dongkyuShin),
                            ),
                            Flexible(
                              flex: 1,
                              child: developerLayout(context, mincheolShin),
                            ),
                            Flexible(
                              flex: 1,
                              child: developerLayout(context, yonghoKim),
                            ),
                          ],
                        )),
                    Container(
                        color: styleModel
                            .getBackgroundColor()['backgroundColorLevel2'],
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Container(
                                          height: double.infinity,
                                          width: 2.0,
                                          color:
                                          styleModel.getBackgroundColor()[
                                          'greyLevel3'],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 4.0,
                                      width: 6,
                                      decoration: BoxDecoration(
                                          color:
                                          styleModel.getBackgroundColor()[
                                          'greyLevel1'],
                                          borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(5.0),
                                            topRight:
                                            const Radius.circular(5.0),
                                          )),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 13.0,
                                      width: 15.0,
                                      decoration: BoxDecoration(
                                          color:
                                          styleModel.getBackgroundColor()[
                                          'greyLevel3'],
                                          borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(5.0),
                                            topRight:
                                            const Radius.circular(5.0),
                                          )),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 3.0,
                                      width: 20.0,
                                      decoration: BoxDecoration(
                                          color:
                                          styleModel.getBackgroundColor()[
                                          'greyLevel3'],
                                          borderRadius: BorderRadius.only(
                                            topLeft:
                                            const Radius.circular(10.0),
                                            topRight:
                                            const Radius.circular(10.0),
                                          )),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(bottom: 8.0),
                                        child: Container(
                                          width: 25.0,
                                          decoration: new BoxDecoration(
                                              color: Colors.yellow
                                                  .withOpacity(0.4),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.yellow[500],
                                                  blurRadius:
                                                  _glowAnimation.value +
                                                      200,
                                                  spreadRadius:
                                                  _glowAnimation.value + 25,
                                                  offset: Offset(
                                                    0,
                                                    30,
                                                  ),
                                                )
                                              ],
                                              borderRadius: BorderRadius.only(
                                                topLeft:
                                                const Radius.circular(40.0),
                                                topRight:
                                                const Radius.circular(40.0),
                                                bottomLeft:
                                                const Radius.circular(50.0),
                                                bottomRight:
                                                const Radius.circular(50.0),
                                              )),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 8,
                              child: SpecialThanksTo(),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
          data: MediaQuery.of(context).copyWith(textScaleFactor: 0.9),
        );
      },
    );
  }

  Widget developerLayout(
      BuildContext context, Map<String, dynamic> developerInfo) {
    StyleModel styleModel = Provider.of<StyleModel>(context);
    return Card(
      elevation: 2,
      color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
              width: 2.0, color: styleModel.getBackgroundColor()['greyLevel5']),
        ),
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${developerInfo['koreanName']}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                        color: styleModel.getBackgroundColor()[
                                            'reversalColorLevel1']),
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
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      "${developerInfo['englishName']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 14.0),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: Colors.green[200],
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text("${developerInfo['role']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 1.0,
              width: styleModel.getContextSize()['screenWidthLevel1'],
              color: styleModel.getBackgroundColor()['greyLevel4'],
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
                        child: Row(
                          children: <Widget>[
                            Flexible(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.bottomRight,
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Icon(
                                    Icons.perm_identity,
                                    color: styleModel.getBackgroundColor()[
                                        'reversalColorLevel1'],
                                    size: styleModel
                                        .getContextSize()['middleIconSize'],
                                  ),
                                )),
                            Flexible(
                                flex: 6,
                                child: Container(
                                  alignment: Alignment.bottomLeft,
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text("${developerInfo['id']}",
                                        style: styleModel
                                            .getTextStyle()['bodyTextStyle'],
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Flexible(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Icon(
                                    Icons.email,
                                    color: Colors.blue[400],
                                    size: styleModel
                                        .getContextSize()['middleIconSize'],
                                  ),
                                )),
                            Flexible(
                                flex: 6,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: SelectableText(
                                      "${developerInfo['email']}",
                                      style: styleModel
                                          .getTextStyle()['bodyTextStyle'],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Flexible(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.topRight,
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Icon(
                                    Icons.lightbulb_outline,
                                    color: Colors.orangeAccent[100],
                                    size: styleModel
                                        .getContextSize()['middleIconSize'],
                                  ),
                                )),
                            Flexible(
                                flex: 6,
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text("${developerInfo['nickname']}",
                                        style: styleModel
                                            .getTextStyle()['bodyTextStyle'],
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                )),
                          ],
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
    );
  }
}
