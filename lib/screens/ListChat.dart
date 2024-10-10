import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutterclient/ServerChat.dart';
import 'package:flutterclient/main.dart';

class ListChat extends StatefulWidget {
  @override
  _ListChat createState() => _ListChat();
}

class _ListChat extends State<ListChat> {
  final ServerChat serverChat = ServerChat();
  late ReceivePort receivePort = ReceivePort();
  int count_client = receivePort.sendPort()

  @override
  void initState() {
    super.initState();
    _connectToServer();

    Isolate.spawn(serverChat.listenForServerMsg, receivePort.sendPort);

  }

  Future<void> _connectToServer() async {
    await serverChat.connectToServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        
        title: Text('Lista Chat'),
      ),
      

      body: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    messages[index],
                    style: TextStyle(color: Colors.white),
                  ),
                  tileColor: Colors.grey,
                );
              },
            ),
      ),
    );
  }
}
