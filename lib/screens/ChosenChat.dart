import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:mysql_client/exception.dart';
import '../backend/MessageReceiver.dart';
import '../backend/ServerChat.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mysql_client/mysql_client.dart';

class ChosenChat extends StatefulWidget {
  final String name_client; // Aggiungi il parametro a ChosenChat
  final ServerChat? serverChat;

  const ChosenChat(
      {required this.name_client, required this.serverChat, super.key});

  @override
  _ChosenChat createState() => _ChosenChat();
}

class _ChosenChat extends State<ChosenChat> {
  final List<String> receivedMessages = []; // Lista dei messaggi ricevuti
  final List<String> sentMessages = []; // Lista dei messaggi inviati
  final TextEditingController _controller =
      TextEditingController(); // Controller per la TextField
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController1 = ScrollController();
  late DatabaseReference databaseReference;

  late DatabaseReference usersRef;

  late final dbConnection;

  @override
  void initState() {
    super.initState();

    createConnection();
    createTable();
    insertIntoTable();
    updateTable();
    creaListener();
  }

  void updateTable() async {
    try {
      await dbConnection.execute(
          "UPDATE ${widget.name_client} SET Messaggio = 'messaggio inviato' WHERE id = 1;");
    } on MySQLServerException catch (e) {
      print('Errore MySQL: $e');
    } catch (e) {
      print('Errore generico: $e');
    }
  }

  void insertIntoTable() async {
    await dbConnection.execute(
        "INSERT INTO ${widget.name_client} (Messaggio, Orario) VALUES ('messaggio iniziale', '12:00:00');");
  }

  void createTable() async {
    try {
      await dbConnection.execute(
        "CREATE TABLE ${widget.name_client} (id INT AUTO_INCREMENT, Messaggio VARCHAR(255), Orario TIME, PRIMARY KEY (id));",
        //"INSERT INTO prova (cella, nome) VALUES ('test', 'X')",
      );
    } on MySQLServerException catch (e) {
      print('$e');
    } catch (e) {
      print('errore');
    }
  }

  void createConnection() {
    dbConnection = MySQLConnectionPool(
      host: '192.168.193.186',
      port: 3306,
      userName: 'develop',
      password: '1',
      maxConnections: 100,
      databaseName: 'chat', // optional,
      secure: false,
    );
  }

  Future<void> creaListener() async {
    await listener();
  }

  Future<void> listener() async {
    await MessageReceiver.instance.startListening();

    MessageReceiver.instance.broadcastStream.listen((message) {
      if (!message.toString().contains("List,")) {
        if (!message.toString().contains("A chi vuoi inviarlo?")) {
          setState(() {
            receivedMessages
                .add(message); // Aggiungi il messaggio ricevuto alla lista
            _scrollToBottom(); // Scorri automaticamente verso il basso
          });
        } else {
          _sendMessageToWhichClient(widget.name_client);
        }
      }

      if (message.toString().contains("broadcast")) {
        receivedMessages.remove(message);
        _sendMessageToWhichClient(widget.name_client);
      }
    });

    widget.serverChat?.startReceivingMessages();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessageToWhichClient(String client) async {
    String tmp = "$client\n/exit";
    await widget.serverChat?.sendMessage(tmp); // Invia il messaggio
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        sentMessages.add(text); // Aggiungi il messaggio inviato alla lista
      });

      widget.serverChat?.sendMessage(text); // Invia il messaggio al server
      _controller.clear(); // Pulisci il TextField
      _scrollController1.animateTo(
        _scrollController1.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _onOpenLink(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch ${link.url}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Server Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text('Messaggi ricevuti'),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          reverse: true,
                          itemCount: receivedMessages.length,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    50), // Bordo circolare
                                color: Colors.red, // Colore di sfondo rosso
                              ),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10), // Margine tra gli elementi
                              child: IntrinsicWidth(
                                child: ListTile(
                                  title: Linkify(
                                    onOpen: _onOpenLink,
                                    text: receivedMessages[index],
                                    style: const TextStyle(color: Colors.white),
                                    linkStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 176, 220, 255)),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(
                  color: Colors.black,
                  thickness: 3,
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text('Messaggi inviati'),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          reverse: true,
                          itemCount: sentMessages.length,
                          controller: _scrollController1,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    50), // Bordo circolare
                                color: Colors.blueAccent
                                    .withOpacity(0.7), // Colore di sfondo
                              ),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10), // Margine tra gli elementi
                              child: IntrinsicWidth(
                                child: ListTile(
                                  title: Linkify(
                                    onOpen: _onOpenLink,
                                    text: sentMessages[index],
                                    style: const TextStyle(color: Colors.white),
                                    linkStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 160, 200, 232)),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 18.0, left: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Invia un messaggio',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed:
                      _sendMessage, // Chiama la funzione per inviare messaggi
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Dispose del controller quando il widget viene distrutto
    _scrollController.dispose(); // Dispose del controller dello scroll
    _scrollController1.dispose();
    super.dispose();
  }
}
