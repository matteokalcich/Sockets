import 'dart:io';

import 'MessageReceiver.dart';

class ServerChat {
  Socket? socket;

  // Metodo per connettersi al server
  Future<void> connectToServer() async {
    try {
      socket = await Socket.connect('192.168.193.27', 3333);
      print(
          'Connesso al server con l\'IP: ${socket!.remoteAddress.address} e porta: ${socket!.remotePort}');
    } catch (e) {
      print('Errore di connessione: $e');
      socket = null; // Impostiamo su null per evitare problemi successivi
    }
  }

  // Metodo per chiudere la connessione
  void closeConnection() {
    socket?.write('exit');
    socket?.close();
    print('Connessione chiusa');
  }

  // Metodo per inviare un messaggio
  Future<void> sendMessage(String message) async {
    if (socket != null) {
      socket!.writeln(message);
      await socket!.flush();
    } else {
      print("Errore: socket non connesso");
    }
  }

  // Metodo per iniziare a ricevere messaggi dal server
  void startReceivingMessages() {
    if (socket != null) {
      print('Avviando ascolto dei messaggi dal server...');
      socket!.listen((data) {
        String message = String.fromCharCodes(data).trim();
        MessageReceiver.instance.sendPort
            .send(message); // Invia il messaggio all'Isolate
        print("Messaggio ricevuto dal server: $message");
      }, onDone: () {
        print('Socket chiuso dal server');
      }, onError: (error) {
        print('Errore nel socket: $error');
      });
    } else {
      print(
          'Errore: socket non connesso, impossibile iniziare a ricevere messaggi');
    }
  }
}
