import 'package:bible_bot/models/style_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class EmptyStatesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final styleModel = Provider.of<StyleModel>(context);
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Icon(
                    Icons.error,
                    color:
                        styleModel.getBackgroundColor()['reversalColorLevel1'],
                    size: styleModel.getContextSize()['bigestIconSize'],
                  ),
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
                  "조회할 내역이 없습니다.",
                  style: styleModel.getTextStyle()['subtitleTextStyle'],
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ));
  }
}
