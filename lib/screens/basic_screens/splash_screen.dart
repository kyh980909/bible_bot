import 'package:bible_bot/models/style_model.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var theme;
  void themeCheck() async {
    String themeData = await StyleModel(context).getSettingMode();
    setState(() {
      theme = themeData;
    });
  }

  @override
  void initState() {
    themeCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      color: theme == "black" ? Colors.grey[900] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset("images/logo.png"),
      ),
    );
  }
}
