import 'dart:isolate';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterclient/ListChat.dart';
import 'package:flutterclient/ServerChat.dart';

void main() async {
  final ServerChat server = new ServerChat();

  await server.connectToServer();

  //creo il "thread"


  await server.serverListen();

  //Run normale dell'app
  runApp(const MyApp());
}

// Il widget principale dell'app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        //'/': (context) => const Home(),
        '/listchat': (context) => const ListChat(),
      },
      home: const ListChat(),
    );
  }
}
