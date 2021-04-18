import 'package:firebase_database/firebase_database.dart';
import 'package:table/models/user.dart';

class Notification {
  String id = "";
  User user = new User();
  DateTime timestamp = new DateTime.now();
  String title = "";
  String desc = "";
  String link = "";
  bool read = false;

  Notification();

  Notification.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    user.id = snapshot.value["user"];
    title = snapshot.value["title"];
    desc = snapshot.value["desc"];
    link = snapshot.value["link"];
    read = snapshot.value["read"];
    timestamp = DateTime.parse(snapshot.value["timestamp"]);
  }
}