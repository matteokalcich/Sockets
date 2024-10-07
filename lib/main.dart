import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:isolate';

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
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ServerChat serverChat = ServerChat();
  final List<String> messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _connectToServer();
  }

  Future<void> _connectToServer() async {
    await serverChat.connectToServer();

    // Ascolta i messaggi provenienti dall'Isolate
    serverChat.receivePort.listen((message) {
      setState(() {
        messages.add(message);
      });
    });
  }

  @override
  void dispose() {
    serverChat.closeConnection();
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      serverChat.sendMessage(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Server Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Invia un messaggio',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ServerChat {
  Socket? socket;
  late ReceivePort receivePort;

  Future<void> connectToServer() async {
    try {
      socket = await Socket.connect('192.168.1.3', 3333);
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
