import 'package:flutter/material.dart';
import 'package:table/pages/groups/groups_page.dart';
import 'package:table/pages/profile/profile_page.dart';
import 'package:table/utils/theme.dart';

import 'home/home_page.dart';

class TabBarController extends StatefulWidget {
  @override
  _TabBarControllerState createState() => _TabBarControllerState();
}

class _TabBarControllerState extends State<TabBarController> {
  int currTab = 0;
  Widget _homeBody = new HomePage();
  Widget _groupPage = new GroupsPage();
  Widget _profilePage = new ProfilePage();
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
    onTabTapped(0);
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
        unselectedItemColor: darkMode ? Colors.grey : Colors.black54,
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
