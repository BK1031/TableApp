import 'package:firebase_database/firebase_database.dart';
import 'package:table/models/user.dart';

class Message {
    String id = "";
    User author = new User();
    String timestamp = "";
    String text = "";

    Message();

    Message.fromSnapshot(DataSnapshot snapshot) {
        id = snapshot.key;
        author.id = snapshot.value["user"];
        text = snapshot.value["text"];
    }
}