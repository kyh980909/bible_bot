import 'dart:convert';
import 'package:bible_bot/screens/part_of_screens/qr_code_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../../communications/request.dart';
import '../../../models/style_model.dart';
import '../../error_screens/empty_state.dart';

class MobileCardSlidingUpPanel extends StatefulWidget {
  var pc;

  MobileCardSlidingUpPanel({Key key, @required this.pc}) : super(key: key);

  @override
  _MobileCardSlidingUpPanelState createState() =>
      _MobileCardSlidingUpPanelState();
}

class _MobileCardSlidingUpPanelState extends State<MobileCardSlidingUpPanel> {
  var statusCheck = false;
  var _pc;
  var touchCount = 0;
  var loadingCheck = false;
  var loadingCount = 0;

  @override
  void initState() {
    _pc = widget.pc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final styleModel = Provider.of<StyleModel>(context);
    return SlidingUpPanel(
      controller: _pc,
      collapsed: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            color: styleModel.getBackgroundColor()['backgroundColorLevel3']),
      ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24.0),
        topRight: Radius.circular(24.0),
      ),
      margin: const EdgeInsets.fromLTRB(60.0, 60.0, 60.0, 0.0),
      backdropTapClosesPanel: true,
      minHeight: 20.0,
      backdropEnabled: true,
      maxHeight: styleModel.getContextSize()['screenHeightLevel5'],
      panel: statusCheck == true
          ? Container(
              child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 14.0),
                    child: QrCodeGenerator(
                      timerTime: 19,
                      pc: _pc,
                    ),
                  ),
                ),
                FutureBuilder(
                  future: Request().getMscInfo(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      default:
                        if (snapshot.connectionState == ConnectionState.done) {
                          print(snapshot.data);
                        if (snapshot.data['status']) {
                          return Container(
                            width: double.infinity,
                            height: styleModel
                                    .getContextSize()['screenHeightLevel6'] - 30,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 30.0,
                                  width: double.infinity,
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Icon(
                                      Icons.maximize,
                                      color: styleModel
                                          .getBackgroundColor()['greyLevel2'],
                                      size: styleModel.getContextSize()[
                                          'screenHeightLevel11'],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "모바일 출입증",
                                      style: styleModel.getTextStyle(
                                          color:
                                              Colors.black)['titleTextStyle'],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 4,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Image.memory(
                                      base64Decode(snapshot.data['img']),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }}
                        else {
                          return EmptyStatesScreen();
                        }
                        return EmptyStatesScreen();
                    }
                  },
                ),
              ],
            ))
          : Container(),
      onPanelOpened: () {
        touchCount == 0 ? touchCount += 1 : touchCount = 2;
        if (touchCount == 1) {
          setState(() {
            statusCheck = true;
          });
        }
      },
      onPanelClosed: () {
        setState(() {
          touchCount = 0;
          statusCheck = false;
          loadingCount = 0;
          loadingCheck = false;
        });
      },
    );
  }
}
