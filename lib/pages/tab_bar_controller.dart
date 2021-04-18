import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:table/pages/groups/groups_page.dart';
import 'package:table/pages/profile/profile_page.dart';
import 'package:table/utils/config.dart';
import 'package:table/utils/theme.dart';

import 'home/home_page.dart';

class TabBarController extends StatefulWidget {
  @override
  _TabBarControllerState createState() => _TabBarControllerState();
}

class _TabBarControllerState extends State<TabBarController> with WidgetsBindingObserver{

  int currTab = 0;
  Widget _homeBody = new HomePage();
  Widget _groupPage = new GroupsPage();
  Widget _profilePage = new ProfilePage(currUser.id);
  Widget body;

  void onTabTapped(int index) {
    setState(() {
      currTab = index;
      if (currTab == 0) {
        body = _homeBody;
      }
      else if (currTab == 1) {
        body = _groupPage;
      }
      else if (currTab == 2) {
        body = _profilePage;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    onTabTapped(0);
    initializeCloudMessaging();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FirebaseDatabase.instance.reference().child("status").child(currUser.id).update({
        "status": "ONLINE",
        "timestamp": DateTime.now().toUtc().toString()
      });
    }
    else {
      FirebaseDatabase.instance.reference().child("status").child(currUser.id).update({
        "status": "OFFLINE",
        "timestamp": DateTime.now().toUtc().toString()
      });
    }
  }

  Future<void> initializeCloudMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      String token = await FirebaseMessaging.instance.getAPNSToken();
      FirebaseDatabase.instance.reference().child("users").child(currUser.id).child("fcmToken").set(token);
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: currBackgroundColor,
      body: body,
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: currTab,
        backgroundColor: currCardColor,
        fixedColor: mainColor,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        unselectedItemColor: currDividerColor,
        onTap: onTabTapped,
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              label: "Home"
          ),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.group),
              label: "Groups"
          ),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.person),
              label: "Profile"
          ),
        ],
      ),
    );
  }
}
