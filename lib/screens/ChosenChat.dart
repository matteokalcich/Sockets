import 'package:flutter/material.dart';

import '../backend/MessageReceiver.dart';
import '../backend/ServerChat.dart';

class ChosenChat extends StatefulWidget {
  @override
  _ChosenChat createState() => _ChosenChat();
}

class _ChosenChat extends State<ChosenChat> {
  late ServerChat serverChat; // Istanza del server chat
  final List<String> messages = []; // Lista dei messaggi
  final TextEditingController _controller =
      TextEditingController(); // Controller per la TextField
  final ScrollController _scrollController =
      ScrollController(); // Controller per il ListView

  @override
  void initState() {
    super.initState();
    serverChat = ServerChat(); // Inizializzo ServerChat
    waitServerConnection(); // Avvio la connessione al server
  }

  Future<void> waitServerConnection() async {
    await initServerConnection();
  }

  // Inizializza la connessione al server e l'ascolto dei messaggi
  Future<void> initServerConnection() async {
    print('Tentativo di connessione al server...');

    // Connettiti al server
    await serverChat.connectToServer();

    // Controlla che la connessione sia stata stabilita prima di avviare l'ascolto
    if (serverChat.socket != null) {
      print('Connessione riuscita!');

      // Avvio l'Isolate per l'ascolto
      await MessageReceiver.instance.startListening();

      // Ascolto i messaggi ricevuti dall'Isolate
      MessageReceiver.instance.receivePort.listen((message) {
        setState(() {
          messages.add(message); // Aggiungi il messaggio alla lista
          _scrollToBottom(); // Scorri automaticamente verso il basso
        });
        print("Messaggio ricevuto dall'Isolate: $message");
      });

      // Quando sei pronto per iniziare a ricevere messaggi dal server
      serverChat.startReceivingMessages();
    } else {
      print('Errore: connessione al server fallita.');
    }
  }

  // Scorri automaticamente verso l'ultimo messaggio
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Invia un messaggio al server
  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      serverChat.sendMessage(text); // Invia il messaggio
      _controller.clear(); // Pulisci il TextField
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
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return Container(
                      
                      color: Colors.black,
                      child: IntrinsicWidth(
                        child: ListTile(
                          title: Text(
                            messages[index],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max, // Imposta la larghezza massima
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
    super.dispose();
  }
}
