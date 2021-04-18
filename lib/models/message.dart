import 'package:firebase_database/firebase_database.dart';

class Message {
    String id = "";
    String uid = "";
    String timestamp = "";
    String text = "";

    Message();

    Message.fromSnapshot(DataSnapshot snapshot) {
        id = snapshot.key;
        uid = snapshot.value["user"];
        text = snapshot.value["text"];
    }
}