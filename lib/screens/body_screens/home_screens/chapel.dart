import 'package:bible_bot/models/style_model.dart';
import 'package:bible_bot/provider/chapel.dart';
import 'package:bible_bot/screens/error_screens/empty_state.dart';
import 'package:bible_bot/util/storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChapelScreen extends StatefulWidget {
  @override
  _ChapelScreenState createState() => _ChapelScreenState();
}

class _ChapelScreenState extends State<ChapelScreen> {
  ChapelProvider _chapelProvider;
  String semester;

  void choiceAction(String selected) async {
    semester = await Storage.getChapelSelected();
    // 현재 선택된 학기를 선택 하지 않을경우에만 리빌드
    if (semester != selected) {
      Storage.setChapelSelected(selected);
      _chapelProvider.setSemester(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final StyleModel styleModel = Provider.of<StyleModel>(context);
    final String theme = Provider.of<String>(context);
    final ChapelProvider chapel = Provider.of<ChapelProvider>(context);
    final ThemeData expansionTileTheme = Theme.of(context).copyWith(
        unselectedWidgetColor:
            styleModel.getBackgroundColor()['reversalColorLevel1'],
        accentColor: styleModel.getBackgroundColor()['reversalColorLevel1'],
        dividerColor: styleModel.getBackgroundColor()['backgroundColorLevel1']);

    _chapelProvider = chapel;
    return Scaffold(
      backgroundColor: styleModel.getBackgroundColor()['backgroundColorLevel1'],
      appBar: AppBar(
        brightness: styleModel.getBrightness()['appBarBrightness'],
        // 추가해줘야 statusBar 정상표시
        backgroundColor:
            styleModel.getBackgroundColor()['backgroundColorLevel1'],
        title: new Text(
          '채플',
          style: styleModel.getTextStyle()['appBarTextStyle'],
        ),
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: styleModel.getBackgroundColor()['reversalColorLevel1']),
            onPressed: () => Navigator.pop(context)),
      ),
      body: buildFutureBuilder(
          _chapelProvider, styleModel, expansionTileTheme, theme),
    );
  }

  Widget buildFutureBuilder(ChapelProvider chapelData, StyleModel styleModel,
      ThemeData expansionTileTheme, String theme) {
    Map<String, dynamic> data = chapelData.getChapelData();

    if (!chapelData.isFetching) {
      if (data == null) return EmptyStatesScreen();
      if (!data['result']) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  data['err'],
                  style: styleModel.getTextStyle()['titleTextStyle'],
                ),
                SizedBox(height: 4.0),
                Text(data['err_msg'],
                    style: styleModel.getTextStyle()['bodyTextStyle'])
              ],
            ),
          ),
        );
      } else {
        List<String> selectable =
            _chapelProvider.getChapelData()['select'].selectable;
        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 250.0,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: selectSemester(styleModel, selectable, data)),
                    Expanded(flex: 7, child: chapelSummary(data, styleModel)),
                  ],
                ),
              ),
              brightness: styleModel.getBrightness()['appBarBrightness'],
              // 추가해줘야 statusBar 정상표시
              backgroundColor:
                  styleModel.getBackgroundColor()['backgroundColorLevel1'],
              elevation: 0,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => chapelCard(
                    styleModel, expansionTileTheme, data, index, theme),
                childCount: data['table_body'].length,
              ),
            )
          ],
        );
      }
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Text replaceSemester(String value, StyleModel styleModel) {
    String year = value.substring(2, 4);
    String semester = value[4];
    return Text(
      '$year-$semester',
      style: styleModel.getTextStyle()['bodyTitleTextStyle'],
    );
  }

  Container selectSemester(StyleModel styleModel, List<String> selectable,
      Map<String, dynamic> data) {
    String year = data['select'].selected.substring(2, 4);
    String semester = data['select'].selected[4];

    return Container(
      child: Theme(
        data: Theme.of(context).copyWith(
            canvasColor:
                styleModel.getBackgroundColor()['backgroundColorLevel1']),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            elevation: 1,
            items: selectable
                .map((value) => DropdownMenuItem(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            replaceSemester(value, styleModel),
                            if (value == data['select'].selected)
                              Icon(
                                Icons.check,
                                color: Colors.green[200],
                                size: 20,
                              )
                          ],
                        ),
                      ),
                      value: value,
                    ))
                .toList(),
            onChanged: (String value) {
              choiceAction(value);
            },
            hint: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                '$year-$semester학기',
                style: styleModel.getTextStyle()['bodyTitleTextStyle'],
              ),
            ),
            icon: Icon(Icons.arrow_drop_down_circle),
            iconSize: 20,
            iconEnabledColor: Colors.green[200],
          ),
        ),
      ),
    );
  }

  Card chapelSummary(Map<String, dynamic> snap, StyleModel styleModel) {
    return Card(
      color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
      elevation: 2,
      margin: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: summaryContainer(
                      snap['summary'].attendance, '출석', styleModel),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                color: styleModel.getDivisionLineStyle()[
                                    'divisionLineColor']))),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child:
                      summaryContainer(snap['summary'].tardy, '지각', styleModel),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: styleModel
                            .getDivisionLineStyle()['divisionLineColor']))),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: summaryContainer(
                      snap['summary'].confirm, '확정', styleModel),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                color: styleModel.getDivisionLineStyle()[
                                    'divisionLineColor']))),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: summaryContainer(
                      (int.parse(snap['summary'].dayOfRule) -
                                      int.parse(snap['summary'].confirm) <
                                  0
                              ? 0
                              : int.parse(snap['summary'].dayOfRule) -
                                  int.parse(snap['summary'].confirm))
                          .toString(),
                      '남은 일수',
                      styleModel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container summaryContainer(
      String title, String subtitle, StyleModel styleModel) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: subtitle == '지각'
                    ? styleModel.getTextStyle(
                        color: Colors.orange[300])['titleTextStyle']
                    : styleModel.getTextStyle(
                        color: Colors.indigo[300])['titleTextStyle'],
              ),
            ),
            Text(
              subtitle,
              style: styleModel.getTextStyle()['bodyTextStyle'],
            )
          ],
        ),
      ),
    );
  }

  Card chapelCard(StyleModel styleModel, ThemeData expansionTileTheme,
      Map<String, dynamic> snap, int index, String theme) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
      child: Theme(
        data: expansionTileTheme,
        child: ExpansionTile(
          title: Container(
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: snap['table_body'][index][7] == '출석'
                      ? Transform.rotate(
                          angle: -3.14 / 13,
                          child: Opacity(
                            opacity: 0.5,
                            child: Image.asset(
                              'images/chapelAttendance.png',
                              color: theme == 'black' ? Colors.white : null,
                            ),
                          ),
                        )
                      : snap['table_body'][index][7] == '지각'
                          ? Transform.rotate(
                              angle: -3.14 / 13,
                              child: Opacity(
                                opacity: 0.5,
                                child: Image.asset(
                                  'images/chapelLate.png',
                                  color: theme == 'black'
                                      ? Colors.deepOrangeAccent
                                      : null,
                                ),
                              ),
                            )
                          : Transform.rotate(
                              angle: -3.14 / 13,
                              child: Opacity(
                                  opacity: 0.5,
                                  child: Image.asset(
                                    'images/chapelAbsent.png',
                                    color: theme == 'black'
                                        ? Colors.redAccent
                                        : null,
                                  )),
                            ),
                ),
                Flexible(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text('${snap['table_body'][index][7]}',
                              style: styleModel.getTextStyle(
                                  color: snap['table_body'][index][7] == '출석'
                                      ? null
                                      : snap['table_body'][index][7] == '결석'
                                          ? Colors.red
                                          : Colors.orange)['bodyTextStyle']),
                        ),
                        Text(
                            '${snap['table_body'][index][0]}.${snap['table_body'][index][1]}.${snap['table_body'][index][2]} (${snap['table_body'][index][4]})',
                            style: styleModel
                                .getTextStyle()['smallBodyTextStyle']),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    '시각',
                                    style: styleModel
                                        .getTextStyle()['smallBodyTextStyle'],
                                  )),
                            ),
                            Flexible(
                              flex: 3,
                              child: Container(
                                  width: double.infinity,
                                  child: Text('${snap['table_body'][index][3]}',
                                      style: styleModel.getTextStyle()[
                                          'smallBodyTextStyle'])),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: Container(
                                  width: double.infinity,
                                  child: Text('출석',
                                      style: styleModel.getTextStyle()[
                                          'smallBodyTextStyle'])),
                            ),
                            Flexible(
                              flex: 3,
                              child: Container(
                                  width: double.infinity,
                                  child: Text('${snap['table_body'][index][6]}',
                                      style: styleModel.getTextStyle(
                                              color: snap['table_body'][index]
                                                          [7] ==
                                                      '출석'
                                                  ? null
                                                  : snap['table_body'][index]
                                                              [7] ==
                                                          '결석'
                                                      ? Colors.red
                                                      : Colors.orange)[
                                          'smallBodyTextStyle'])),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: Container(
                                  width: double.infinity,
                                  child: Text('확정',
                                      style: styleModel.getTextStyle()[
                                          'smallBodyTextStyle'])),
                            ),
                            Flexible(
                              flex: 3,
                              child: Container(
                                  width: double.infinity,
                                  child: Text('${snap['table_body'][index][7]}',
                                      style: styleModel.getTextStyle(
                                              color: snap['table_body'][index]
                                                          [7] ==
                                                      '출석'
                                                  ? null
                                                  : snap['table_body'][index]
                                                              [7] ==
                                                          '결석'
                                                      ? Colors.red
                                                      : Colors.orange)[
                                          'smallBodyTextStyle'])),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: Container(
                                width: double.infinity,
                                child: Text('비고',
                                    style: styleModel
                                        .getTextStyle()['smallBodyTextStyle'])),
                          ),
                          Flexible(
                            flex: 3,
                            child: Container(
                                width: double.infinity,
                                child: Text('${snap['table_body'][index][8]}',
                                    style: styleModel
                                        .getTextStyle()['smallBodyTextStyle'])),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
