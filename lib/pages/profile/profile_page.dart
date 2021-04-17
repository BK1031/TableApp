import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:table/utils/config.dart';
import 'package:table/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: Image.network(currUser.profilePicture, height: 125, width: 125,),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Text("${currUser.firstName} ${currUser.lastName}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),)
                    ),
                    Container(
                        child: Linkify(
                          onOpen: (link) => launch(link.url),
                          text: currUser.bio, style: TextStyle(fontSize: 18),
                          linkStyle: TextStyle(color: mainColor),
                        )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
