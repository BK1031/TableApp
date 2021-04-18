import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:table/models/user.dart';
import 'package:table/utils/config.dart';
import 'package:table/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class FriendsPage extends StatefulWidget {
  String id;
  FriendsPage(this.id);
  @override
  _FriendsPageState createState() => _FriendsPageState(this.id);
}

class _FriendsPageState extends State<FriendsPage> {

  User profileUser = new User();
  PageController pageController = new PageController();
  int page = 0;

  List<User> friends = [];
  List<User> incomingRequests = [];
  List<User> outgoingRequests = [];

  _FriendsPageState(String id) {
    profileUser.id = id;
    FirebaseDatabase.instance.reference().child("users").child(profileUser.id).once().then((value) {
      setState(() {
        profileUser = new User.fromSnapshot(value);
      });
      getFriends();
      getRequests();
    });
  }

  void getFriends() {
    FirebaseDatabase.instance.reference().child("users").child(profileUser.id).child("friends").onChildAdded.listen((event) {
      FirebaseDatabase.instance.reference().child("users").child(event.snapshot.value).once().then((value) {
        setState(() {
          friends.add(new User.fromSnapshot(value));
        });
      });
    });
  }

  void getRequests() {
    FirebaseDatabase.instance.reference().child("friend-requests").onChildAdded.listen((event) {
      if (event.snapshot.key.split("–")[0] == currUser.id) {
        FirebaseDatabase.instance.reference().child("users").child(event.snapshot.key.split("–")[1]).once().then((value) {
          setState(() {
            outgoingRequests.add(new User.fromSnapshot(value));
          });
        });
      }
      else if (event.snapshot.key.split("–")[1] == currUser.id) {
        FirebaseDatabase.instance.reference().child("users").child(event.snapshot.key.split("–")[0]).once().then((value) {
          setState(() {
            incomingRequests.add(new User.fromSnapshot(value));
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
        title: Text("${profileUser.firstName}'s Friends", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: mainColor),),
        backgroundColor: currBackgroundColor,
        elevation: 0,
      ),
      backgroundColor: currBackgroundColor,
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Visibility(
              visible: currUser.id == profileUser.id,
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoButton(
                      color: page == 0 ? mainColor : currBackgroundColor,
                      padding: EdgeInsets.all(0),
                      child: Text("Friends", style: TextStyle(color: page == 0 ? Colors.white : currTextColor),),
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
                      child: Text("Requests", style: TextStyle(color: page == 1 ? Colors.white : currTextColor),),
                      onPressed: () {
                        setState(() {
                          page = 1;
                        });
                        pageController.animateToPage(1, duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(8)),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    page = index;
                  });
                },
                children: [
                  ListView.builder(
                    itemCount: friends.length,
                    itemBuilder: (context, index) => Container(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Card(
                        color: currCardColor,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            if (friends[index].id != currUser.id) {
                              router.navigateTo(context, "/profile/${friends[index].id}", transition: TransitionType.nativeModal);
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
                                      child: CachedNetworkImage(imageUrl: friends[index].profilePicture, height: 65, width: 65),
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
                                          Text("${friends[index].firstName} ${friends[index].lastName}", style: TextStyle(fontSize: 18, color: currTextColor),),
                                          Text("${friends[index].email}", style: TextStyle(fontSize: 15, color: currDividerColor),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: currUser.id == profileUser.id,
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Center(
                                      child: IconButton(
                                        icon: Icon(Icons.clear, color: currDividerColor,),
                                        onPressed: () {
                                          CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.confirm,
                                            borderRadius: 8,
                                            confirmBtnColor: mainColor,
                                            text: "Are you sure you want to remove this friend?",
                                            onConfirmBtnTap: () {
                                              FirebaseDatabase.instance.reference().child("users").child(profileUser.id).child("friends").child(friends[index].id).remove();
                                              FirebaseDatabase.instance.reference().child("users").child(friends[index].id).child("friends").child(profileUser.id).remove();
                                              setState(() {
                                                friends.removeAt(index);
                                              });
                                              router.pop(context);
                                            }
                                          );
                                        },
                                      )
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
                  Visibility(
                    visible: currUser.id == profileUser.id,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Incoming Requests", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: currTextColor)),
                        Padding(padding: EdgeInsets.all(4)),
                        Expanded(
                          child: Container(
                            child: ListView.builder(
                              itemCount: incomingRequests.length,
                              itemBuilder: (context, index) => Container(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Card(
                                    color: currCardColor,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: () {
                                        router.navigateTo(context, "/profile/${incomingRequests[index].id}", transition: TransitionType.nativeModal);
                                      },
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              child: Center(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(1000),
                                                  child: CachedNetworkImage(imageUrl: incomingRequests[index].profilePicture, height: 65, width: 65),
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
                                                      Text("${incomingRequests[index].firstName} ${incomingRequests[index].lastName}", style: TextStyle(fontSize: 18, color: currTextColor),),
                                                      Text("${incomingRequests[index].email}", style: TextStyle(fontSize: 15, color: currDividerColor),),
                                                      Padding(
                                                        padding: EdgeInsets.all(4),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: CupertinoButton(
                                                              padding: EdgeInsets.zero,
                                                              color: mainColor,
                                                              child: Text("Accept"),
                                                              onPressed: () {
                                                                FirebaseDatabase.instance.reference().child("users").child(profileUser.id).child("friends").child(incomingRequests[index].id).set(incomingRequests[index].id);
                                                                FirebaseDatabase.instance.reference().child("users").child(incomingRequests[index].id).child("friends").child(profileUser.id).set(profileUser.id);
                                                                FirebaseDatabase.instance.reference().child("friend-requests").child("${incomingRequests[index].id}–${profileUser.id}").remove();
                                                                FirebaseDatabase.instance.reference().child("notifications").push().set({
                                                                  "title": "New Friend!",
                                                                  "desc": "${currUser.firstName} ${currUser.lastName} is now your friend. Click to view their profile.",
                                                                  "link": "/profile/${currUser.id}",
                                                                  "user": incomingRequests[index].id,
                                                                  "timestamp": DateTime.now().toString(),
                                                                  "read": false
                                                                });
                                                                setState(() {
                                                                  incomingRequests.removeAt(index);
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: CupertinoButton(
                                                              padding: EdgeInsets.zero,
                                                              child: Text("Ignore", style: TextStyle(color: mainColor),),
                                                              onPressed: () {
                                                                FirebaseDatabase.instance.reference().child("friend-requests").child("${incomingRequests[index].id}–${profileUser.id}").remove();
                                                                setState(() {
                                                                  incomingRequests.removeAt(index);
                                                                });
                                                              },
                                                            ),
                                                          )
                                                        ],
                                                      )
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
                          ),
                        ),
                        Text("Outgoing Requests", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: currTextColor)),
                        Padding(padding: EdgeInsets.all(4)),
                        Expanded(
                          child: Container(
                            child: ListView.builder(
                              itemCount: outgoingRequests.length,
                              itemBuilder: (context, index) => Container(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Card(
                                    color: currCardColor,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: () {
                                        router.navigateTo(context, "/profile/${outgoingRequests[index].id}", transition: TransitionType.nativeModal);
                                      },
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              child: Center(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(1000),
                                                  child: CachedNetworkImage(imageUrl: outgoingRequests[index].profilePicture, height: 65, width: 65),
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
                                                      Text("${outgoingRequests[index].firstName} ${outgoingRequests[index].lastName}", style: TextStyle(fontSize: 18, color: currTextColor),),
                                                      Text("${outgoingRequests[index].email}", style: TextStyle(fontSize: 15, color: currDividerColor),)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              child: Center(
                                                  child: IconButton(
                                                    icon: Icon(Icons.clear, color: currDividerColor,),
                                                    onPressed: () {
                                                      CoolAlert.show(
                                                          context: context,
                                                          type: CoolAlertType.confirm,
                                                          borderRadius: 8,
                                                          confirmBtnColor: mainColor,
                                                          text: "Are you sure you want to remove this request?",
                                                          onConfirmBtnTap: () {
                                                            FirebaseDatabase.instance.reference().child("friend-requests").child("${profileUser.id}–${outgoingRequests[index].id}").remove();
                                                            setState(() {
                                                              outgoingRequests.removeAt(index);
                                                            });
                                                            router.pop(context);
                                                          }
                                                      );
                                                    },
                                                  )
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}
