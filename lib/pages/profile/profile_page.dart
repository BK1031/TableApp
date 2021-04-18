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

class _ProfilePageState extends State<ProfilePage> {

  User profileUser = User();

  int events = 0;
  int friends = 0;
  int groups = 0;

  _ProfilePageState(String id) {
    profileUser.id = id;
    FirebaseDatabase.instance.reference().child("users").child(profileUser.id).once().then((value) {
      setState(() {
        profileUser = new User.fromSnapshot(value);
      });
    });
  }

  void showSettingsMenu() {
    showBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(8),
        child: Card(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(child: Divider(thickness: 4, color: currDividerColor,), width: 75,),
                ListTile(
                  leading: Icon(Icons.settings, color: currDividerColor,),
                  title: Text("Edit Profile", style: TextStyle(color: currTextColor),),
                  onTap: () {
                    router.pop(context);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      body: SafeArea(
        child: SingleChildScrollView(
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
                          child: Image.network(profileUser.profilePicture, height: 125, width: 125,),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Text("${profileUser.firstName} ${profileUser.lastName}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: currTextColor),)
                    ),
                    Container(
                        child: Linkify(
                          onOpen: (link) => launch(link.url),
                          text: profileUser.bio, style: TextStyle(fontSize: 18, color: currDividerColor),
                          linkStyle: TextStyle(color: mainColor),
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
                                child: Column(
                                  children: [
                                    Text("Friends", style: TextStyle(color: currDividerColor, fontSize: 18),),
                                    Padding(padding: EdgeInsets.all(4),),
                                    Text("$friends", style: TextStyle(color: mainColor, fontSize: 25, fontWeight: FontWeight.bold),)
                                  ],
                                )
                            )
                          ],
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
