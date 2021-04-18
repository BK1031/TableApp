import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:table/models/group.dart';
import 'package:table/models/user.dart';
import 'package:table/pages/groups/new_group_dialog.dart';
import 'package:table/utils/config.dart';
import 'package:table/utils/theme.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> with RouteAware {

  List<Group> groups = [];

  @override
  void initState() {
    super.initState();
    getGroups();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    print("refrshing group pge");
    getGroups();
  }

  getGroups() {
    setState(() {
      groups.clear();
    });
    FirebaseDatabase.instance.reference().child("groups").onChildAdded.listen((event) async {
      if (event.snapshot.value["users"][currUser.id] != null) {
        Group group = new Group.fromSnapshot(event.snapshot);
        for (int i = 0; i < event.snapshot.value["users"].keys.length; i++) {
          await FirebaseDatabase.instance.reference().child("users").child(event.snapshot.value["users"].keys.toList()[i]).once().then((value) {
            User user = new User.fromSnapshot(value);
            group.users.add(user);
          });
        }
        setState(() {
          groups.add(group);
        });
      }
    });
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white,),
        onPressed: () {
          showDialog(context: context, builder: (context) => AlertDialog(
            backgroundColor: currCardColor,
            content: NewGroupDialog(),
          ));
        },
      ),
      backgroundColor: currBackgroundColor,
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: groups.length,
        itemBuilder: (context, index) => Container(
          padding: EdgeInsets.only(bottom: 8),
          child: Card(
            color: currCardColor,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                router.navigateTo(context, "/groups/${groups[index].id}", transition: TransitionType.native);
              },
              child: Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Container(padding: EdgeInsets.all(16), child: Icon(Icons.people, color: currDividerColor,)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(groups[index].name, style: TextStyle(color: currTextColor, fontSize: 20),),
                          Padding(padding: EdgeInsets.all(2),),
                          Text(groups[index].users.map((e) => e.firstName).toList().toString().split("[")[1].split("]")[0], style: TextStyle(color: currDividerColor, fontSize: 16),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}