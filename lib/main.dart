import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:isolate';

import 'package:flutterclient/ChatScreen.dart';

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
      home: ChosenChatScreen(),
    );
  }
}



class ServerChat {
  Socket? socket;
  late ReceivePort receivePort;

  Future<void> connectToServer() async {
    try {
      socket = await Socket.connect('127.0.0.1', 3333);
      print('Connesso al server');

      // Inizializza il ReceivePort per ricevere messaggi
      receivePort = ReceivePort();

      // Ascolta i messaggi dal server
      socket!.listen((data) {
        String message = String.fromCharCodes(data).trim();
        receivePort.sendPort.send(message);
      }, onDone: () {
        print('Socket chiuso dal server');
      }, onError: (error) {
        print('Errore nel socket: $error');
      });
    } catch (e) {
      print('Errore di connessione: $e');
    }
  }

  void closeConnection() {
    socket?.write('exit');
    socket?.close();
    print('Connessione chiusa');
  }

  Future<void> sendMessage(String message) async {
    if (socket != null) {
      socket!.writeln(message);
      await socket!.flush();
    } else {
      print("Socket non connesso");
    }
  }
}
