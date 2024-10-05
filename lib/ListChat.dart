import 'package:flutter/material.dart';

class ListChat extends StatefulWidget {
  const ListChat({super.key});

  @override
  _ListChatState createState() => _ListChatState();
}

class _ListChatState extends State<ListChat> {
  TextEditingController nomeClient = TextEditingController();
  List<String> clients = [];

  void _addClient() {
    if (nomeClient.text.isNotEmpty) {
      setState(() {
        clients.add(nomeClient.text);
        nomeClient.clear();
      });
      Navigator.of(context)
          .pop(); // Chiude il dialogo dopo aver aggiunto il cliente
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nome client'),
          content: TextField(
            controller: nomeClient,
            decoration:
                const InputDecoration(hintText: 'Inserisci nome cliente'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
                Navigator.of(context).pop(); // Chiude il dialogo
              },
            ),
            TextButton(
              
              onPressed: _addClient, // Aggiunge il cliente

              child: const Text('Aggiungi'),
              
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: clients.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(clients[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        clients.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showMyDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
