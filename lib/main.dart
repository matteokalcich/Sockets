import 'dart:io';

Socket? socket;

Future connectToServer() async {
  // Stabilisce la connessione al server
  socket = await Socket.connect('192.168.1.2', 3333); // Usa l'IP corretto

  print('Connesso al server');

  // Ascolta i dati provenienti dal server
  socket!.listen((data) {
    if ('Chiuso'.compareTo(String.fromCharCodes(data).trim()) == 0) {
      print('Server chiuso');
      closeConnection();
    }
    print('Server: ${String.fromCharCodes(data).trim()}');
  });

  return 0;
}

Future sendMessage(String message) async {
  if (socket != null) {
    // Invia un messaggio al server
    socket!.writeln(
        message); // Usa writeln per inviare una stringa seguita da una nuova riga
    await socket!.flush(); // Assicura che i dati vengano inviati
  } else {
    print("Socket non connesso");
  }

  return 0;
}

void closeConnection() {
  // Chiude la connessione con il server
  if (socket != null) {
    socket!.writeln('exit'); // Invia 'exit' per terminare la connessione
    socket!.destroy();
    print('Connessione chiusa');
  }
}

void main() async {
  // Connessione al server
  await connectToServer();

  // Invia messaggi al server senza chiudere la connessione
  await sendMessage('Ciao dal client Flutter!');
  await sendMessage('Un altro messaggio');

  // Chiudi la connessione quando necessario
  await Future.delayed(
      Duration(seconds: 5)); // Attendere prima di chiudere la connessione
  closeConnection();
}
