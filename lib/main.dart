import 'dart:isolate';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterclient/ListChat.dart';

Socket? socket;

Future<void> connectToServer() async {
  // Stabilisce la connessione al server
  socket = await Socket.connect('localhost', 3333); // Usa l'IP corretto
  print('Connesso al server');

  // Ascolta i dati provenienti dal server
  socket!.listen((data) {
    if ('Chiuso'.compareTo(String.fromCharCodes(data).trim()) == 0) {
      print('Server chiuso');
      closeConnection();
    }
    print('Server: ${String.fromCharCodes(data).trim()}');
  });
}

void closeConnection() {
  // Chiude la connessione con il server
  if (socket != null) {
    socket!.writeln('exit'); // Invia 'exit' per terminare la connessione
    socket!.destroy();
    print('Connessione chiusa');
  }
}

void inputListener(SendPort sendPort) {
  // Funzione per leggere l'input in un Isolate separato
  while (true) {
    String? input = "ciao"; // Legge l'input dall'utente
    if (input == null || input.trim().toLowerCase() == 'exit') {
      sendPort.send('exit'); // Invia un messaggio al main per chiudere
      break; // Esci dal ciclo
    }
    sendPort.send(input.trim()); // Invia l'input al main
  }
}

Future<void> sendMessage(String message) async {
  if (socket != null) {
    // Invia un messaggio al server
    socket!.writeln(
        message); // Usa writeln per inviare una stringa seguita da una nuova riga
    await socket!.flush(); // Assicura che i dati vengano inviati
  } else {
    print("Socket non connesso");
  }
}

void main() async {


  await connectToServer();


  final receivePort = ReceivePort();

  Isolate.spawn(inputListener, receivePort.sendPort);
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
