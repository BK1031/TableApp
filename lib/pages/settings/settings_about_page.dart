import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:table/models/user.dart';
import 'package:table/utils/config.dart';
import 'package:table/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsAboutPage extends StatefulWidget {
  @override
  _SettingsAboutPageState createState() => _SettingsAboutPageState();
}

class _SettingsAboutPageState extends State<SettingsAboutPage> {

  String devicePlatform = "";
  String deviceName = "";

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      devicePlatform = "iOS";
    }
    else if (Platform.isAndroid) {
      devicePlatform = "Android";
    }
    deviceName = Platform.localHostname;
  }

  launchContributeUrl() async {
    const url = 'https://github.com/equinox-initiative/myDECA-flutter';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchGuidelinesUrl() async {
    const url = 'https://github.com/equinox-initiative/myDECA-flutter/wiki/contributing';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text("About", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: mainColor),),
          backgroundColor: currBackgroundColor,
          elevation: 0,
        ),
        backgroundColor: currBackgroundColor,
        body: new SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                new Card(
                  color: currCardColor,
                  child: Column(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.only(top: 16.0),
                        child: new Text("device".toUpperCase(), style: TextStyle(color: mainColor, fontSize: 18, fontWeight: FontWeight.bold),),
                      ),
                      new ListTile(
                        title: new Text("App Version", style: TextStyle(color: currTextColor, fontSize: 17.0)),
                        trailing: new Text("$appVersion$appStatus", style: TextStyle(color: currTextColor, fontSize: 17.0)),
                      ),
                      new ListTile(
                        title: new Text("Device Name", style: TextStyle(color: currTextColor, fontSize: 17.0)),
                        trailing: new Text("$deviceName", style: TextStyle(color: currTextColor, fontSize: 17.0)),
                      ),
                      new ListTile(
                        title: new Text("Platform", style: TextStyle(color: currTextColor, fontSize: 17.0)),
                        trailing: new Text("$devicePlatform", style: TextStyle(color: currTextColor, fontSize: 17.0)),
                      ),
                    ],
                  ),
                ),
                new Padding(padding: EdgeInsets.all(4)),
                new Card(
                  color: currCardColor,
                  child: Column(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.only(top: 16.0),
                        child: new Text("credits".toUpperCase(), style: TextStyle(color: mainColor, fontSize: 18, fontFamily: "Montserrat", fontWeight: FontWeight.bold),),
                      ),
                      new ListTile(
                        title: new Text("Bharat Kathi", style: TextStyle(color: currTextColor, fontSize: 17,)),
                        subtitle: new Text("App Development", style: TextStyle(color: Colors.grey)),
                        onTap: () {
                          const url = 'https://www.instagram.com/bk1031_official';
                          launch(url);
                        },
                      ),
                      new ListTile(
                        title: new Text("Thomas Liang", style: TextStyle(color: currTextColor, fontSize: 17,)),
                        subtitle: new Text("App Development", style: TextStyle(color: Colors.grey)),
                        onTap: () {
                          const url = 'https://www.instagram.com/thomas_____liang/';
                          launch(url);
                        },
                      ),
                      new ListTile(
                        title: new Text("Rohan Viswanathan", style: TextStyle(color: currTextColor, fontSize: 17,)),
                        subtitle: new Text("Server Development", style: TextStyle(color: Colors.grey)),
                        onTap: () {
                          const url = 'https://www.instagram.com/rpi2._/';
                          launch(url);
                        },
                      ),
                      new ListTile(
                        title: new Text("Kashyap Chaturvedula", style: TextStyle(color: currTextColor, fontSize: 17)),
                        subtitle: new Text("Database Design", style: TextStyle(color: Colors.grey)),
                        onTap: () {
                          const url = 'https://www.instagram.com/kashyap456/';
                          launch(url);
                        },
                      ),
                    ],
                  ),
                ),
                new Padding(padding: EdgeInsets.all(4)),
                new Card(
                  color: currCardColor,
                  child: Column(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.only(top: 16.0),
                        child: new Text("contributing".toUpperCase(), style: TextStyle(color: mainColor, fontSize: 17,fontWeight: FontWeight.bold),),
                      ),
                      new ListTile(
                        title: new Text("View on GitHub", style: TextStyle(color: currTextColor, fontSize: 17,)),
                        trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                        onTap: () {
                          launchContributeUrl();
                        },
                      ),
                      new ListTile(
                        title: new Text("Contributing Guidelines", style: TextStyle(color: currTextColor, fontSize: 17,)),
                        trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                        onTap: () {
                          launchGuidelinesUrl();
                        },
                      ),
                    ],
                  ),
                ),
                new Padding(padding: EdgeInsets.all(16.0)),
                new InkWell(
                  child: new Text("© Bharat Kathi 2021", style: TextStyle(color: currDividerColor),),
                  splashColor: currBackgroundColor,
                  highlightColor: currCardColor,
                  onTap: () {
                    launch("https://github.com/equinox-initiative/myDECA-flutter");
                  },
                ),
              ],
            ),
          ),
        )
    );
  }
}