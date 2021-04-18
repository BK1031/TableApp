import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table/models/group.dart';
import 'package:table/models/user.dart';
import 'package:intl/intl.dart';
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

  List<String> events = [];

  int page = 0;
  PageController pageController = new PageController();

  _GroupDetailsPageState(String id) {
    group.id = id;
    getGroupDetails();
    getEvents();
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

  void getEvents() {
    FirebaseDatabase.instance.reference().child("groups").child(group.id).child("events").onChildAdded.listen((event) {
      setState(() {
        events.add("${event.snapshot.value["time"]}–${event.snapshot.value["status"]}");
      });
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
            Padding(padding: EdgeInsets.all(8),),
            Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    color: page == 0 ? mainColor : currBackgroundColor,
                    padding: EdgeInsets.all(0),
                    child: Text("Details", style: TextStyle(color: page == 0 ? Colors.white : currTextColor),),
                    onPressed: () {
                      setState(() {
                        page = 0;
                      });
                      pageController.animateToPage(0, duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
                    },
                  ),
                ),
                Expanded(
                  child: CupertinoButton(
                    color: page == 1 ? mainColor : currBackgroundColor,
                    padding: EdgeInsets.all(0),
                    child: Text("Chat", style: TextStyle(color: page == 1 ? Colors.white : currTextColor),),
                    onPressed: () {
                      setState(() {
                        page = 1;
                      });
                      pageController.animateToPage(1, duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
                    },
                  ),
                ),
                Expanded(
                  child: CupertinoButton(
                    color: page == 2 ? mainColor : currBackgroundColor,
                    padding: EdgeInsets.all(0),
                    child: Text("Members", style: TextStyle(color: page == 2 ? Colors.white : currTextColor),),
                    onPressed: () {
                      setState(() {
                        page = 2;
                      });
                      pageController.animateToPage(2, duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
                    },
                  ),
                )
              ],
            ),
            Padding(padding: EdgeInsets.all(8),),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (int) {
                  setState(() {
                    page = int;
                  });
                },
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Events",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: currTextColor
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(4),),
                        events.isEmpty ? Center(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: Text("Nothing new to see here!", style: TextStyle(color: currDividerColor),),
                          ),
                        ) : Expanded(
                          child: ListView.builder(
                            itemCount: events.length,
                            itemBuilder: (context, index) => Container(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Card(
                                color: currCardColor,
                                child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () {
                                      router.navigateTo(context, "/groups/${currUser.id}/group1/events/event1", transition: TransitionType.native);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Container(padding: EdgeInsets.all(16), child: Icon(Icons.event, color: currDividerColor)),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(DateFormat.MEd().format(DateTime.parse(events[index].split("–")[0])), style: TextStyle(color: currTextColor, fontSize: 20)),
                                                Padding(padding: EdgeInsets.all(2),),
                                                Text(events[index].split("–")[1], style: TextStyle(color: currDividerColor, fontSize: 16),),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: CupertinoButton(
                            child: Text("Add Event"),
                            color: mainColor,
                            onPressed: () {},
                          ),
                        )
                      ],
                    ),
                  ),
                  ChatPage(group.id),
                  Container(
                    child: ListView.builder(
                      itemCount: group.users.length,
                      itemBuilder: (context, index) => Container(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Card(
                            color: currCardColor,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                if (group.users[index].id != currUser.id) {
                                  router.navigateTo(context, "/profile/${group.users[index].id}", transition: TransitionType.nativeModal);
                                }
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(1000),
                                          child: CachedNetworkImage(imageUrl: group.users[index].profilePicture, height: 65, width: 65),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("${group.users[index].firstName} ${group.users[index].lastName}", style: TextStyle(fontSize: 18, color: currTextColor),),
                                              Text("${group.users[index].email}", style: TextStyle(fontSize: 15, color: currDividerColor),)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
