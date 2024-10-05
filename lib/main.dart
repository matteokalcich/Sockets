import 'dart:io';
import 'dart:isolate';

Socket? socket;

Future<void> connectToServer() async {
  // Stabilisce la connessione al server
  socket = await Socket.connect('192.168.36.27', 3333); // Usa l'IP corretto
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

void main() async {
  // Connessione al server
  await connectToServer();

  // Crea un ReceivePort per ricevere messaggi dall'inputListener
  final receivePort = ReceivePort();
  Isolate.spawn(inputListener, receivePort.sendPort);

  await for (var message in receivePort) {
    if (message == 'exit') {
      closeConnection();
      break; // Esci dal ciclo principale
    } else {
      await sendMessage(message); // Invia il messaggio al server
    }
  }
}
