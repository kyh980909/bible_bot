// import 'package:bible_bot/models/style_model.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    // final styleModel = Provider.of<StyleModel>(context);
    return Container(
      decoration: new BoxDecoration(
          border: new Border.all(width: 5, color: Colors.transparent),
          //color is transparent so that it does not blend with the actual color specified
          color: new Color.fromRGBO(
              3, 0, 0, 0.2) // Specifies the background color and the opacity
          ),
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("images/cat.png"),
            Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: Text(
                "Loading...",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
