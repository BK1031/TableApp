import 'package:firebase_database/firebase_database.dart';

class User {
  String id = "";
  String firstName = "";
  String lastName = "";
  String email = "";
  String phone = "";
  String gender = "";
  String bio = "";
  String profilePicture = "https://firebasestorage.googleapis.com/v0/b/table-app-calhacks.appspot.com/o/default-profile.jpeg?alt=media&token=1034f54c-f985-45a5-af92-6ad66c31c067";

  User();

  User.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    firstName = snapshot.value["firstName"];
    lastName = snapshot.value["lastName"];
    email = snapshot.value["email"];
    phone = snapshot.value["phone"];
    gender = snapshot.value["gender"];
    bio = snapshot.value["bio"];
    profilePicture = snapshot.value["profilePicture"];
  }

}