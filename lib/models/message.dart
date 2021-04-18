import 'package:firebase_database/firebase_database.dart';
import 'package:table/models/user.dart';

class Message {
    String id = "";
    User author = new User();
    DateTime date = new DateTime.now();
    String message = "";

    Message();

    Message.fromSnapshot(DataSnapshot snapshot) {
        id = snapshot.key;
        author.id = snapshot.value["author"];
        message = snapshot.value["message"];
        date = DateTime.parse(snapshot.value["date"]);
    }
}