import 'package:firebase_database/firebase_database.dart';

class User {
  String id = "";
  String firstName = "";
  String lastName = "";
  String email = "";
  String phone = "";
  String gender = "";
  String profilePicture = "https://vcrobotics.net/images/WB_App_Icon.png";

  User();

  User.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.value["id"];
    firstName = snapshot.value["firstName"];
    lastName = snapshot.value["lastName"];
    email = snapshot.value["email"];
    phone = snapshot.value["phone"];
    gender = snapshot.value["gender"];
    profilePicture = snapshot.value["profilePicture"];
  }

}