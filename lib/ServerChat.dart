import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

class ServerChat{

  Socket? socket;

  Future<void> connectToServer() async {
    // Stabilisce la connessione al server
    socket = await Socket.connect('192.168.1.3', 3333); // Usa l'IP corretto
    print('Connesso al server');

    
  }

  Future<void> serverListen() async{

    return await compute(_listenForServerMsg);
  }

  void _listenForServerMsg() async{

    // Ascolta i dati provenienti dal server
    socket!.listen((data) {
      if ('Chiuso'.compareTo(String.fromCharCodes(data).trim()) == 0) {
        print('Server chiuso');
        closeConnection();
      } else{

        print('Risposta Server: ${String.fromCharCodes(data).trim()}');
      }
      
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

  void inputListener(String tmp) async{
    // Funzione per leggere l'input in un Isolate separato
    while (true) {
      String? input = "ciao"; // Legge l'input dall'utente
      if (input == null || input.trim().toLowerCase() == 'exit') {
        
        break; // Esci dal ciclo
      }
      //sendPort.send(input.trim()); // Invia l'input al main
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
}