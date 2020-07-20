import 'dart:async';

import 'package:bible_bot/models/style_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QrCodeGenerator extends StatefulWidget {
  var timerTime;
  var pc;
  QrCodeGenerator({Key key, @required this.timerTime, this.pc})
      : super(key: key);

  @override
  _QrCodeGeneratorState createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {
  Timer timer;
  int effectiveTime;
  var qrCode;

  @override
  void initState() {
    super.initState();
    effectiveTime = widget.timerTime;
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        effectiveTime -= 1;
      });

      if (effectiveTime == 0) {
        widget.pc.close();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final styleModel = Provider.of<StyleModel>(context);
    return Container(
      height: styleModel.getContextSize()['screenHeightLevel10'],
      alignment: Alignment.center,
      color: Colors.transparent,
      child: Text(
        "QR코드 유효시간 : $effectiveTime 초",
        style:
            styleModel.getTextStyle(color: Colors.black)['subtitleTextStyle'],
      ),
    );
  }
}
