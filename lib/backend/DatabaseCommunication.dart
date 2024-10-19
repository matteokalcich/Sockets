import 'dart:io';
import 'package:mysql_client/exception.dart';
import 'package:mysql_client/mysql_client.dart';



class DatabaseCommunication {

  late final dbConnection;

  void createConnection() {
    dbConnection = MySQLConnectionPool(
      host: '192.168.193.186',
      port: 3306,
      userName: 'develop',
      password: '1',
      maxConnections: 10000,
      databaseName: 'chat', // optional,
      secure: false,
    );
  }





  void createTable(nomeTabella) async {
    try {
      await dbConnection.execute(
        "CREATE TABLE $nomeTabella (id INT AUTO_INCREMENT, Messaggio VARCHAR(255), Orario TIME, PRIMARY KEY (id));",

      );
    } on MySQLServerException catch (e) {
      print('$e');
    } catch (e) {
      print('errore');
    }
  }





  void insertIntoTable(nomeTabella, sentMsg, orario) async {

    await dbConnection.execute(
        "INSERT INTO $nomeTabella (Messaggio, Orario) VALUES ('$sentMsg', '$orario');");
  }

}
