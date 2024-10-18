import 'package:flutter/material.dart';
import 'package:flutterclient/screens/ChosenChat.dart';
import '../backend/ServerChat.dart';
import '../backend/MessageReceiver.dart';

class ListChat extends StatefulWidget {
  @override
  _ListChat createState() => _ListChat();
}

class _ListChat extends State<ListChat> {
  late ServerChat serverChat; // Istanza del server chat
  final List<String> messages = []; // Lista dei messaggi

  late List<String> clients = [];
  List item = [];

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
    print('Connessione riuscita!');
    // Avvio l'Isolate per l'ascolto
    await MessageReceiver.instance.startListening();
    // Ascolto i messaggi ricevuti dall'Isolate
    MessageReceiver.instance.broadcastStream.listen((message) {
      setState(() {
        if (message.toString().contains("List")) {
          if (item.length > message.toString().split(",").length) {
            //ciclo per aggiornare la lista se è stato eliminato qualcosa
          }

          clients = List.empty(growable: true);

          item = message.toString().split(",");

          for (int i = 1; i < item.length - 1; i++) {
            clients.add(item[i]);
          }
        }
      });
      print("Messaggio ricevuto dall'Isolate: $message");
    });
    // Quando sei pronto per iniziare a ricevere messaggi dal server
    serverChat.startReceivingMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista Chat'),
      ),
      backgroundColor: Color.fromARGB(255, 189, 195, 199),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: clients.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 189, 195, 199),
                      border: Border.symmetric(
                          horizontal: BorderSide(
                        color: Colors.white,
                      )),
                    ),
                    child: IntrinsicWidth(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Image.network(
                              'https://static-00.iconduck.com/assets.00/avatar-icon-512x512-gu21ei4u.png'),
                        ),
                        title: Text(
                          clients[index],
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                        trailing: Text("ultima chat"), //clients[index].getUltimoMsg
                      ),
                    ),
                  ),
                  onTap: () {
                    print('Hai cliccato ${clients[index]}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChosenChat(
                          name_client: clients[index],
                          serverChat: serverChat,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
