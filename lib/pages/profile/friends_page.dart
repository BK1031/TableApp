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

class FriendsPage extends StatefulWidget {
  String id;
  FriendsPage(this.id);
  @override
  _FriendsPageState createState() => _FriendsPageState(this.id);
}

class _FriendsPageState extends State<FriendsPage> {

  User profileUser = new User();

  _FriendsPageState(String id) {
    profileUser.id = id;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
