import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:table/models/group.dart';
import 'package:table/models/user.dart';
import 'package:table/utils/config.dart';
import 'package:table/utils/theme.dart';
import 'hero_dialog_route.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {

  List<Group> groups = [];


  @override
  void initState() {
    super.initState();
    getGroups();
  }

  getGroups() {
    FirebaseDatabase.instance.reference().child("groups").onChildAdded.listen((event) {
      if (event.snapshot.value["users"][currUser.id] != null) {
        Group group = new Group.fromSnapshot(event.snapshot);
        event.snapshot.value["users"].keys.forEach((id) async {
          await FirebaseDatabase.instance.reference().child("users").child(id).once().then((value) {
              User user = new User.fromSnapshot(value);
              group.users.add(user);
          });
        });
        setState(() {
          groups.add(group);
        });
      }
    });
  }

  String getNamesPreview(List<User> users) {
    String returnString = "";
    for (int i = 0; i < users.length; i++) {
      returnString += users[i].firstName;

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Groups", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: mainColor),),
        backgroundColor: currBackgroundColor,
        elevation: 0,
        centerTitle: false
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: groups.length,
        itemBuilder: (context, index) => Container(
          child: Card(
            color: currCardColor,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {

                    },
                    child: Container(
                      height: 80,
                      width: 400,
                      child: ListTile(
                        leading: Icon(Icons.people, color: currDividerColor,),
                        title: Text(groups[index].name, style: TextStyle(color: currTextColor, fontSize: 20),),
                        subtitle: Text("", style: TextStyle(color: currTextColor, fontSize: 20),),
                      ),
                    ),
                  )
                ]
            ),
          ),
        ),
      ),
    );
  }
}