import 'package:bible_bot/models/style_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeightDivisionLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final styleModel = Provider.of<StyleModel>(context);

    return Container(
      width: 1,
      height: styleModel.getDivisionLineStyle()['longDivisionLineHeight'],
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
              color: styleModel.getDivisionLineStyle()['divisionLineColor']),
        ),
      ),
    );
  }
}
