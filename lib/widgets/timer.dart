import 'dart:async';
import 'package:bible_bot/models/style_model.dart';
import 'package:provider/provider.dart';
import 'package:quiver/async.dart';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> with ChangeNotifier {
  Timer timer;
  var sub;

  int _effectiveTime = 10;
  int _current = 10;

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _effectiveTime),
      new Duration(seconds: 1),
    );

    sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = _effectiveTime - duration.elapsed.inSeconds;
      });
      notifyListeners();
    });

    sub.onDone(() {
      sub.cancel();
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timer == null ? print("빠른 화면 전환 방지") : timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final styleModel = Provider.of<StyleModel>(context);
    return Container(
      alignment: Alignment.center,
      child: Row(children: <Widget>[
        Flexible(
          flex: 1,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: Text(
              "$_current",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              height: double.infinity,
              child: InkWell(
                onTap: () {
                  sub.cancel();
                  startTimer();
                },
                child: Icon(
                  Icons.refresh,
                  color: styleModel.getBackgroundColor()['reversalColorLevel1'],
                  size: styleModel.getContextSize()['bigIconSize'],
                ),
              )),
        )
      ]),
    );
  }
}
