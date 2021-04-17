import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:table/models/user.dart';
import 'package:table/utils/config.dart';
import 'package:table/utils/theme.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool connected = true;

  final connectionRef = FirebaseDatabase.instance.reference().child(".info/connected");

  Future<void> checkConnection() async {
    connectionRef.onValue.listen((event) {
      if (event.snapshot.value) {
        setState(() {
          connected = true;
        });
        checkAuth();
      }
      else {
        setState(() {
          connected = false;
        });
      }
    });
  }

  Future<void> checkAuth() async {
    if (fb.FirebaseAuth.instance.currentUser != null) {
      try {
        FirebaseDatabase.instance.reference().child("users").child(fb.FirebaseAuth.instance.currentUser.uid).once().then((value) {
          currUser = new User.fromSnapshot(value);
          print("––––––––––––– DEBUG INFO ––––––––––––––––");
          print("NAME: ${currUser.firstName} ${currUser.lastName}");
          print("EMAIL: ${currUser.email}");
          print("–––––––––––––––––––––––––––––––––––––––––");
          if (value.value["darkMode"] != null && value.value["darkMode"]) {
            setState(() {
              darkMode = true;
              currBackgroundColor = darkBackgroundColor;
              currCardColor = darkCardColor;
              currDividerColor = darkDividerColor;
              currTextColor = darkTextColor;
            });
          }
          Future.delayed(const Duration(milliseconds: 800), () {
            router.navigateTo(context, "/", transition: TransitionType.fadeIn, replace: true);
          });
        });
      } catch (error) {
        print("Error occured, signign out");
        fb.FirebaseAuth.instance.signOut();
        router.navigateTo(context, "/auth/register", transition: TransitionType.fadeIn, replace: true);
      }
    }
    else {
      Future.delayed(const Duration(milliseconds: 800), () {
        router.navigateTo(context, "/auth/register", transition: TransitionType.fadeIn, replace: true);
      });
    }

  }

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    if (connected) {
      return Scaffold(
        backgroundColor: currBackgroundColor,
        body: new Container(
          child: Center(
            child: new HeartbeatProgressIndicator(
              child: new Image.asset("images/table-logo.png", height: 50,),
            ),
          ),
        ),
      );
    }
    else {
      return Scaffold(
        backgroundColor: currBackgroundColor,
        body: Container(
          padding: EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0, top: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Container(
                child: Image.asset(
                  'images/table-logo.png',
                  height: 50,
                ),
              ),
              new Column(
                children: [
                  new Text(
                    "Server Connection Error",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.red,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0,
                    ),
                  ),
                  new Padding(padding: EdgeInsets.all(8.0)),
                  new Text(
                    "We encountered a problem when trying to connect you to our servers. This page will automatically disappear if a connection with the server is established.\n\nTroubleshooting Tips:\n- Check your wireless connection\n- Restart the Table app\n- Restart your device",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontSize: 17.0,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
  }
}
