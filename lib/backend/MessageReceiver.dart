import 'dart:isolate';

class MessageReceiver {
  late ReceivePort receivePort;
  late Isolate _isolate;
  static final MessageReceiver _instance = MessageReceiver._internal();

  MessageReceiver._internal() {
    receivePort = ReceivePort();
  }

  static MessageReceiver get instance => _instance;

  // Getter per il SendPort
  SendPort get sendPort => receivePort.sendPort;

  // Metodo per avviare l'Isolate
  Future<void> startListening() async {
    _isolate = await Isolate.spawn(_listenMessages, receivePort.sendPort);
  }

  // Metodo che sarà eseguito dall'Isolate
  static void _listenMessages(SendPort sendPort) {
    ReceivePort isolateReceivePort = ReceivePort();
    sendPort
        .send(isolateReceivePort.sendPort); // Invio il SendPort dell'Isolate

    isolateReceivePort.listen((message) {
      print("Isolate ha ricevuto: $message");
    });
  }

  void stopListening() {
    _isolate.kill(priority: Isolate.immediate);
    print("Isolate fermato");
  }
}
