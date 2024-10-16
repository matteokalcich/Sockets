import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterclient/screens/ListChat.dart';
import '../backend/MessageReceiver.dart';
import '../backend/ServerChat.dart';

class ChosenChat extends StatefulWidget {
  final String name_client; // Aggiungi il parametro a ChosenChat
  final ServerChat? serverChat;

  ChosenChat({required this.name_client, required this.serverChat, Key? key})
      : super(key: key);

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

  @override
  void initState() {
    super.initState();
    creaListener();
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
        duration: Duration(seconds: 1),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessageToWhichClient(String client) async {
    String tmp = "$client\n/exit";
    await widget.serverChat?.sendMessage(tmp); // Invia il messaggio
    //await widget.serverChat?.sendMessage("/exit");
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        sentMessages.add(text); // Aggiungi il messaggio inviato alla lista
      });
      widget.serverChat?.sendMessage(text); // Invia il messaggio
      _controller.clear(); // Pulisci il TextField
      _scrollController1.animateTo(
        _scrollController1.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.easeOut,
      );
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
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text('Messaggi ricevuti'),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
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
                                  title: Text(
                                    receivedMessages[index],
                                    style: const TextStyle(color: Colors.white),
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
                                  title: Text(
                                    sentMessages[index],
                                    style: const TextStyle(color: Colors.white),
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
            padding: const EdgeInsets.all(8.0),
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
