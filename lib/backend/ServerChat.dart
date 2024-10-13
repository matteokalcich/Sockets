import 'dart:io';

import 'MessageReceiver.dart';



class ServerChat {
  late Socket socket;

  // Metodo per connettersi al server
  Future<void> connectToServer() async {
    try {
      socket = await Socket.connect('192.168.36.27', 3333);
      print(
          'Connesso al server con l\'IP: ${socket.remoteAddress.address} e porta: ${socket.remotePort}');
    } catch (e) {
      print('Errore di connessione: $e');

    }
  }

  // Metodo per chiudere la connessione
  void closeConnection() {
    socket.write('exit');
    socket.close();
    print('Connessione chiusa');
  }

  // Metodo per inviare un messaggio
  Future<void> sendMessage(String message) async {
    
    socket.writeln(message);
    await socket.flush();
    
  }

  // Metodo per iniziare a ricevere messaggi dal server
  void startReceivingMessages() {
    
    print('Avviando ascolto dei messaggi dal server...');
    socket.listen((data) {

      String message = String.fromCharCodes(data).trim();
      MessageReceiver.instance.sendPort
        .send(message); // Invia il messaggio all'Isolate
      print("Messaggio ricevuto dal server: $message");
    }, onDone: () {
      print('Socket chiuso dal server');
    }, onError: (error) {
      print('Errore nel socket: $error');
    });
    
  }
}
