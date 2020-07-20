import 'package:bible_bot/models/style_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class License extends StatefulWidget {
  @override
  _LicenseState createState() => _LicenseState();
}

class _LicenseState extends State<License> {
  Future<String> loadAsset(String filename) async {
    return await rootBundle.loadString('licenses/$filename.txt');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final styleModel = Provider.of<StyleModel>(context);

    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text(
              '오픈소스 라이센스',
              style: styleModel.getTextStyle()['appBarTextStyle'],
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color:
                      styleModel.getBackgroundColor()['reversalColorLevel1']),
              onPressed: () => Navigator.pop(context, false),
            ),
            elevation: 0,
            brightness: styleModel.getBrightness()['appBarBrightness'],
            backgroundColor:
                styleModel.getBackgroundColor()['backgroundColorLevel1']),
        body: Container(
          color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
          child: ListView(
            children: <Widget>[
              buildExpansionTile(
                  'test', 'https://github.com/dart-lang/test', styleModel),
              buildExpansionTile(
                  'http', 'https://pub.dev/packages/http', styleModel),
              buildExpansionTile('shared_preferences',
                  'https://pub.dev/packages/shared_preferences', styleModel),
              buildExpansionTile(
                  'provider', 'https://pub.dev/packages/provider', styleModel),
              buildExpansionTile(
                  'intl', 'https://pub.dev/packages/intl', styleModel),
              buildExpansionTile('table_calendar',
                  'https://pub.dev/packages/table_calendar', styleModel),
              buildExpansionTile('percent_indicator',
                  'https://pub.dev/packages/percent_indicator', styleModel),
              buildExpansionTile(
                  'flutter_webview_plugin',
                  'https://pub.dev/packages/flutter_webview_plugin',
                  styleModel),
              buildExpansionTile('sliding_up_panel',
                  'https://pub.dev/packages/sliding_up_panel', styleModel),
              buildExpansionTile('photo_view',
                  'https://pub.dev/packages/photo_view', styleModel),
              buildExpansionTile('flutter_swiper',
                  'https://pub.dev/packages/flutter_swiper', styleModel),
              buildExpansionTile(
                  'flutter_cupertino_date_picker',
                  'https://pub.dev/packages/flutter_cupertino_date_picker',
                  styleModel),
              buildExpansionTile('cupertino_icons',
                  'https://pub.dev/packages/cupertino_icons', styleModel),
              buildExpansionTile(
                  'flushbar', 'https://pub.dev/packages/flushbar', styleModel),
              buildExpansionTile('url_launcher',
                  'https://pub.dev/packages/url_launcher', styleModel),
              buildExpansionTile('package_info',
                  'https://pub.dev/packages/package_info', styleModel),
              buildExpansionTile(
                  'syncfusion_flutter_calendar',
                  'https://pub.dev/packages/syncfusion_flutter_calendar',
                  styleModel),
              buildExpansionTile(
                  'syncfusion_flutter_core',
                  'https://pub.dev/packages/syncfusion_flutter_core',
                  styleModel),
              buildExpansionTile('date_range_picker',
                  'https://pub.dev/packages/date_range_picker', styleModel)
            ],
          ),
        ));
  }

  FutureBuilder buildExpansionTile(
      String title, String subtitle, StyleModel styleModel) {
    final theme = Theme.of(context).copyWith(
        unselectedWidgetColor:
            styleModel.getBackgroundColor()['reversalColorLevel1'],
        accentColor: styleModel.getBackgroundColor()['reversalColorLevel1']);
    return FutureBuilder(
        future: loadAsset(title),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Theme(
              data: theme,
              child: ExpansionTile(
                title: Text(
                  title,
                  style: styleModel.getTextStyle()['bodyTextStyle'],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.0),
                    child: Text(
                      snapshot.data,
                      style: styleModel.getTextStyle()['smallBodyTextStyle'],
                      textAlign: TextAlign.justify,
                    ),
                  )
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
