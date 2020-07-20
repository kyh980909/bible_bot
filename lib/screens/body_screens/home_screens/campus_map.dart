import 'package:bible_bot/models/style_model.dart';
import 'package:bible_bot/widgets/width_division_line.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class CampusMapScreen extends StatefulWidget {
  @override
  _CampusMapScreenState createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  @override
  Widget build(BuildContext context) {
    StyleModel styleModel = Provider.of<StyleModel>(context);
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('캠퍼스맵',
              style: styleModel.getTextStyle()['appBarTextStyle'],
              overflow: TextOverflow.ellipsis),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: styleModel.getBackgroundColor()['reversalColorLevel1']),
            onPressed: () => Navigator.pop(context, false),
          ),
          elevation: 0,
          brightness: styleModel.getBrightness()['appBarBrightness'],
          backgroundColor:
              styleModel.getBackgroundColor()['backgroundColorLevel1']),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "사진을 드래그하여 확대하실 수 있습니다.",
                    style: styleModel.getTextStyle()['bodyTitleTextStyle'],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: Container(
                child: PhotoView(
                  imageProvider: AssetImage('images/map.png'),
                  backgroundDecoration: BoxDecoration(
                    color: styleModel
                        .getBackgroundColor()['backgroundColorLevel1'],
                  ),
                  minScale: PhotoViewComputedScale.contained * 0.6,
                  maxScale: PhotoViewComputedScale.covered * 1,
                  initialScale: PhotoViewComputedScale.contained * 0.7,
                ),
              ),
            ),
            WidthDivisionLine(),
            Flexible(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      width: double.infinity,
                                      child: Icon(Icons.location_on,
                                          color: Colors.greenAccent),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        width: double.infinity,
                                        child: Text(
                                          "주소",
                                          style: styleModel.getTextStyle()[
                                              'subtitleTextStyle'],
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Flexible(
                                    flex: 1,
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            width: double.infinity,
                                            child: Text(
                                              "139-791",
                                              style: styleModel.getTextStyle()[
                                                  'bodyTextStyle'],
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: Container(
                                            width: double.infinity,
                                            child: SelectableText(
                                              "서울시 노원구 동일로 214길 32",
                                              style: styleModel.getTextStyle()[
                                                  'bodyTextStyle'],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              width: double.infinity,
                                              child: Text(
                                                "전화번호",
                                                style:
                                                    styleModel.getTextStyle()[
                                                        'bodyTextStyle'],
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Container(
                                              width: double.infinity,
                                              child: Text(
                                                "02-950-5401",
                                                style:
                                                    styleModel.getTextStyle()[
                                                        'bodyTextStyle'],
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
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
                    WidthDivisionLine(),
                    Flexible(
                      flex: 1,
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      width: double.infinity,
                                      child: Icon(Icons.directions_bus,
                                          color: Colors.blueAccent),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        width: double.infinity,
                                        child: Text(
                                          "지하철",
                                          style: styleModel.getTextStyle()[
                                              'subtitleTextStyle'],
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 14.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                      flex: 1,
                                      child: Row(
                                        children: <Widget>[
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              width: double.infinity,
                                              child: Text(
                                                "지하철 7호선",
                                                style:
                                                    styleModel.getTextStyle()[
                                                        'bodyTextStyle'],
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Container(
                                              width: double.infinity,
                                              child: Text(
                                                " 중계역 1번출구에서 1분거리",
                                                style:
                                                    styleModel.getTextStyle()[
                                                        'bodyTextStyle'],
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              flex: 1,
                                              child: Container(
                                                width: double.infinity,
                                                child: Text(
                                                  "지하철 4호선",
                                                  style:
                                                      styleModel.getTextStyle()[
                                                          'bodyTextStyle'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 2,
                                              child: Container(
                                                width: double.infinity,
                                                child: Text(
                                                  " 노원역 2번출구에서 5분거리",
                                                  style:
                                                      styleModel.getTextStyle()[
                                                          'bodyTextStyle'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
