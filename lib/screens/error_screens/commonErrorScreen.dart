import 'package:bible_bot/models/style_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommonErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final styleModel = Provider.of<StyleModel>(context);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
        child: Text(
          "서버에 문제가 발생했습니다. 잠시후에 다시 이용해주세요!",
          style: styleModel.getTextStyle()['bodyTextStyle'],
        ),
      ),
    );
  }
}
