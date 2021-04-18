import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:table/models/group.dart';
import 'package:table/models/user.dart';
import 'package:table/pages/groups/chat_page.dart';
import 'package:table/pages/groups/new_group_dialog.dart';
import 'package:table/utils/config.dart';
import 'package:table/utils/theme.dart';

class GroupDetailsPage extends StatefulWidget {
  String id;
  GroupDetailsPage(this.id);
  @override
  _GroupDetailsPageState createState() => _GroupDetailsPageState(this.id);
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {

  Group group = new Group();

  _GroupDetailsPageState(String id) {
    group.id = id;
    getGroupDetails();
  }

  void getGroupDetails() {
    FirebaseDatabase.instance.reference().child("groups").child(group.id).once().then((value) async {
      setState(() {
        group = new Group.fromSnapshot(value);
      });
      print(group.name);
      for (int i = 0; i < value.value["users"].keys.length; i++) {
        await FirebaseDatabase.instance.reference().child("users").child(value.value["users"].keys.toList()[i]).once().then((value) {
          User user = new User.fromSnapshot(value);
          setState(() {
            group.users.add(user);
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: currDividerColor, //change your color here
        ),
        title: Text("${group.name}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: mainColor),),
        backgroundColor: currBackgroundColor,
        elevation: 0,
      ),
      backgroundColor: currBackgroundColor,
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Group ID: ${group.id}", style: TextStyle(color: currTextColor, fontSize: 18),),
            Padding(padding: EdgeInsets.all(4),),
            Text(group.desc, style: TextStyle(color: currDividerColor, fontSize: 18)),
            Padding(padding: EdgeInsets.all(4),),
            Container(height: 200,),
            Text("Chat", style: TextStyle(color: currTextColor, fontSize: 18, fontWeight: FontWeight.bold),),
            Padding(padding: EdgeInsets.all(4),),
            new Expanded(
              child: ChatPage(group.id),
            )
          ],
        ),
      ),
    );
  }
}
