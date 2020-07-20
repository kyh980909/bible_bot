// import 'package:bible_bot/models/style_model.dart';
// import 'package:bible_bot/screens/popup_menu/setting_list/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class Setting extends StatefulWidget {
//   @override
//   _SettingState createState() => _SettingState();
// }

// class _SettingState extends State<Setting> {
//   String themeData;

//   @override
//   Widget build(BuildContext context) {
//     final styleModel = Provider.of<StyleModel>(context);
//     themeData = Provider.of<String>(context);
//     return Scaffold(
//       appBar: AppBar(
//           automaticallyImplyLeading: true,
//           title: Text('설정',
//               style: styleModel.getTextStyle()['appBarTextStyle'],
//               overflow: TextOverflow.ellipsis),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back,
//                 color: styleModel.getIconColor()['themeIconColor']),
//             onPressed: () => Navigator.pop(context, false),
//           ),
//           elevation: 0,
//           brightness: styleModel.getBrightness()['appBarBrightness'],
//           backgroundColor:
//               styleModel.getBackgroundColor()['backgroundColorLevel1']),
//       body: Container(
//           height: double.infinity,
//           width: double.infinity,
//           color: styleModel.getBackgroundColor()['backgroundColorLevel1'],
//           child: Column(
//             children: <Widget>[
//               Flexible(
//                 flex: 1,
//                 child: Container(
//                   child: Column(
//                     children: <Widget>[
//                       Flexible(
//                         flex: 1,
//                         child: RaisedButton(
//                           highlightElevation: 0,
//                           focusElevation: 0,
//                           elevation: 0,
//                           color: Colors.transparent,
//                           splashColor:
//                               styleModel.getBackgroundColor()['splashColor'],
//                           onPressed: () {
//                             Navigator.push(context, MaterialPageRoute<void>(
//                                 builder: (BuildContext context) {
//                               return MultiProvider(providers: [
//                                 Provider<String>.value(value: themeData),
//                                 Provider<StyleModel>.value(
//                                     value: StyleModel(context,
//                                         currentTheme: themeData))
//                               ], child: ThemeScreen());
//                             }));
//                           },
//                           child: Container(
//                             width: double.infinity,
//                             height: double.infinity,
//                             child: Row(
//                               children: <Widget>[
//                                 Flexible(
//                                   flex: 1,
//                                   child: Container(
//                                     width: double.infinity,
//                                     height: double.infinity,
//                                     child: Icon(
//                                       Icons.color_lens,
//                                       color: styleModel
//                                           .getIconColor()['themeIconColor'],
//                                       size: styleModel
//                                           .getContextSize()['bigIconSize'],
//                                     ),
//                                   ),
//                                 ),
//                                 Flexible(
//                                   flex: 7,
//                                   child: Container(
//                                     width: double.infinity,
//                                     height: double.infinity,
//                                     alignment: Alignment.centerLeft,
//                                     child: Padding(
//                                       padding:
//                                           const EdgeInsets.only(left: 14.0),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           Flexible(
//                                             flex: 1,
//                                             child: Container(
//                                               alignment: Alignment.bottomLeft,
//                                               width: double.infinity,
//                                               height: double.infinity,
//                                               child: Text(
//                                                 "테마",
//                                                 style:
//                                                     styleModel.getTextStyle()[
//                                                         'bodyTextStyle'],
//                                               ),
//                                             ),
//                                           ),
//                                           Flexible(
//                                             flex: 1,
//                                             child: Container(
//                                               alignment: Alignment.centerLeft,
//                                               width: double.infinity,
//                                               height: double.infinity,
//                                               child: Text(
//                                                 "${themeData == null ? "White" : themeData}",
//                                                 style:
//                                                     styleModel.getTextStyle()[
//                                                         'smallBodyTextStyle'],
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Flexible(
//                 flex: 1,
//                 child: Container(),
//               ),
//               Flexible(
//                 flex: 1,
//                 child: Container(),
//               ),
//               Flexible(
//                 flex: 1,
//                 child: Container(),
//               ),
//               Flexible(
//                 flex: 1,
//                 child: Container(),
//               ),
//               Flexible(
//                 flex: 1,
//                 child: Container(),
//               ),
//               Flexible(
//                 flex: 1,
//                 child: Container(),
//               ),
//               Flexible(
//                 flex: 1,
//                 child: Container(),
//               ),
//               Flexible(
//                 flex: 1,
//                 child: Container(),
//               ),
//               Flexible(
//                 flex: 1,
//                 child: Container(),
//               ),
//             ],
//           )),
//     );
//   }
// }
