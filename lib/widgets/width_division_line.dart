import 'package:bible_bot/models/style_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WidthDivisionLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final styleModel = Provider.of<StyleModel>(context);

    return Container(
      width: styleModel.getDivisionLineStyle()['longDivisionLineWidth'],
      height: 1,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: styleModel.getDivisionLineStyle()['divisionLineColor'], width: 2.0),
        ),
      ),
    );
  }
}
