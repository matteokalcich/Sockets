import 'package:flutter/material.dart';

import 'package:flutterclient/screens/ChosenChat.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Server Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChosenChat(),
    );
  }
}




