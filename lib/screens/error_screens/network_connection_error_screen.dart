

import 'package:flutter/material.dart';

class NetworkConnectionErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Text("현재 홈페이지 접속이 원활하지 않습니다."),
      )

    );
  }
}
