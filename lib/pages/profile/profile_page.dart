import 'package:cached_network_image/cached_network_image.dart';
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

class ProfilePage extends StatefulWidget {
  String id;
  ProfilePage(this.id);
  @override
  _ProfilePageState createState() => _ProfilePageState(this.id);
}

class _ProfilePageState extends State<ProfilePage> with RouteAware {

  User profileUser = User();

  int events = 0;
  int friends = 0;
  int groups = 0;

  String friendStatus = "NOT_FRIEND";

  _ProfilePageState(String id) {
    profileUser.id = id;
    FirebaseDatabase.instance.reference().child("users").child(profileUser.id).once().then((value) {
      setState(() {
        profileUser = new User.fromSnapshot(value);
      });
      getFriends();
      if (profileUser.id != currUser.id) {
        checkFriendStatus();
      }
    });
  }

  void getFriends() {
    FirebaseDatabase.instance.reference().child("users").child(profileUser.id).child("friends").once().then((value) {
      print(value.value.keys.length.toString() + "friend detected");
      setState(() {
        friends = value.value.keys.length;
      });
    });
  }

  Future<void> checkFriendStatus() async {
    await FirebaseDatabase.instance.reference().child("users").child(profileUser.id).child("friends").child(currUser.id).once().then((value) async {
      if (value.value != null) {
        setState(() {
          friendStatus = "FRIEND";
        });
      }
      else {
        await FirebaseDatabase.instance.reference().child("friend-requests").child("${currUser.id}–${profileUser.id}").once().then((value) async {
          if (value.value != null) {
            setState(() {
              friendStatus = "REQUESTED";
            });
          }
          else {
            await FirebaseDatabase.instance.reference().child("friend-requests").child("${profileUser.id}–${currUser.id}").once().then((value) {
              if (value.value != null) {
                setState(() {
                  friendStatus = "REQUESTED";
                });
              }
              else {
                setState(() {
                  friendStatus = "NOT_FRIENDS";
                });
              }
            });
          }
        });
      }
    });
    print(friendStatus);
  }

  void showSettingsMenu() {
    showBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(8),
        child: Card(
          color: currCardColor,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(child: Divider(thickness: 4, color: currDividerColor,), width: 75,),
                ListTile(
                  leading: Icon(Icons.edit, color: currDividerColor,),
                  title: Text("Edit Profile", style: TextStyle(color: currTextColor),),
                  onTap: () {
                    router.pop(context);
                    router.navigateTo(context, "/profile/${currUser.id}/edit", transition: TransitionType.nativeModal);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings, color: currDividerColor,),
                  title: Text("Settings", style: TextStyle(color: currTextColor),),
                  onTap: () {
                    router.pop(context);
                    router.navigateTo(context, "/settings", transition: TransitionType.nativeModal);
                  },
                ),
                Container(
                  width: double.infinity,
                  child: CupertinoButton(
                    color: errorColor,
                    child: Text("Sign Out"),
                    onPressed: () async {
                      currUser = new User();
                      fb.FirebaseAuth.instance.signOut();
                      router.navigateTo(context, "/auth", transition: TransitionType.fadeIn, replace: true);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
    ));
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
    print("refrshing profile pge");
    FirebaseDatabase.instance.reference().child("users").child(profileUser.id).once().then((value) {
      setState(() {
        profileUser = new User.fromSnapshot(value);
      });
      getFriends();
      if (profileUser.id != currUser.id) {
        checkFriendStatus();
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
        automaticallyImplyLeading: currUser.id != profileUser.id,
        title: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: mainColor),),
        backgroundColor: currBackgroundColor,
        elevation: 0,
        centerTitle: false,
        actions: [
          Visibility(
            visible: currUser.id == profileUser.id,
            child: IconButton(
              icon: Icon(Icons.menu, color: currDividerColor,),
              onPressed: () {
                showSettingsMenu();
              },
            ),
          )
        ],
      ),
      backgroundColor: currBackgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: CachedNetworkImage(imageUrl: profileUser.profilePicture, height: 125, width: 125),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text("${profileUser.firstName} ${profileUser.lastName}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: currTextColor),)
                  ),
                  Container(
                      child: Center(
                        child: Linkify(
                          onOpen: (link) => launch(link.url),
                          text: profileUser.bio, style: TextStyle(fontSize: 18, color: currDividerColor,),
                          textAlign: TextAlign.center,
                          linkStyle: TextStyle(color: mainColor),
                        ),
                      )
                  ),
                  Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text("Events", style: TextStyle(color: currDividerColor, fontSize: 18),),
                                Padding(padding: EdgeInsets.all(4),),
                                Text("$events", style: TextStyle(color: mainColor, fontSize: 25, fontWeight: FontWeight.bold),)
                              ],
                            )
                          ),
                          Expanded(
                              child: Column(
                                children: [
                                  Text("Groups", style: TextStyle(color: currDividerColor, fontSize: 18),),
                                  Padding(padding: EdgeInsets.all(4),),
                                  Text("$groups", style: TextStyle(color: mainColor, fontSize: 25, fontWeight: FontWeight.bold),)
                                ],
                              )
                          ),
                          Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  router.navigateTo(context, "/profile/${profileUser.id}/friends", transition: TransitionType.nativeModal);
                                },
                                child: Column(
                                  children: [
                                    Text("Friends", style: TextStyle(color: currDividerColor, fontSize: 18),),
                                    Padding(padding: EdgeInsets.all(4),),
                                    Text("$friends", style: TextStyle(color: mainColor, fontSize: 25, fontWeight: FontWeight.bold),)
                                  ],
                                ),
                              )
                          )
                        ],
                      )
                  ),
                ],
              ),
            ),
            Visibility(
              visible: profileUser.id != currUser.id,
              child: Container(
                width: double.infinity,
                child: CupertinoButton(
                  child: Text(
                    friendStatus == "NOT_FRIEND" ? "Add Friend" : friendStatus == "REQUESTED" ? "Requested" : "Friends",
                    style: TextStyle(color: friendStatus == "NOT_FRIEND" ? Colors.white : mainColor),
                  ),
                  color: friendStatus == "NOT_FRIEND" ? mainColor : Colors.transparent,
                  onPressed: () {
                    if (friendStatus == "NOT_FRIEND") {
                      FirebaseDatabase.instance.reference().child("friend-requests").child("${currUser.id}–${profileUser.id}").set("${currUser.id}–${profileUser.id}");
                      checkFriendStatus();
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
