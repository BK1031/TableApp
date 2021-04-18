import 'package:firebase_database/firebase_database.dart';
import 'package:table/models/message.dart';
import 'package:table/models/user.dart';

class Group {
  String id = "";
  String name = "";
  String desc = "";

  List<User> users = [];
  List<Message> messages = [];

  Group();

  Group.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    name = snapshot.value["name"];
    desc = snapshot.value["desc"];
  }

}