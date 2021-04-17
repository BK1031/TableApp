import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:table/main.dart';
import 'package:table/utils/config.dart';
import 'package:table/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Widget _button = Container();
  String _password = "";

  @override
  void initState() {
    super.initState();
    _button = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          child: CupertinoButton(
            color: mainColor,
            child: Text("Login"),
            onPressed: login,
          ),
        ),
        Padding(padding: EdgeInsets.all(4)),
        CupertinoButton(
          child: Text("Don't have an account?", style: TextStyle(color: mainColor),),
          onPressed: () {
            router.navigateTo(context, "/auth/register", transition: TransitionType.fadeIn, clearStack: true);
          },
        )
      ],
    );
  }

  Future<void> login() async {
    setState(() {
      _button = Center(
        child: new HeartbeatProgressIndicator(
          child: new Image.asset("images/table-logo.png", height: 50,),
        ),
      );
    });
    try {
      if (currUser.email != "") {
        await fb.FirebaseAuth.instance.signInWithEmailAndPassword(email: currUser.email, password: _password).then((value) async {
          currUser.id = fb.FirebaseAuth.instance.currentUser.uid;
          router.navigateTo(context, "/auth", transition: TransitionType.fadeIn, clearStack: true);
        });
      }
      setState(() {
        _button = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              child: CupertinoButton(
                color: mainColor,
                child: Text("Login"),
                onPressed: login,
              ),
            ),
            Padding(padding: EdgeInsets.all(4)),
            CupertinoButton(
              child: Text("Don't have an account?", style: TextStyle(color: mainColor),),
              onPressed: () {
                router.navigateTo(context, "/auth/register", transition: TransitionType.fadeIn, clearStack: true);
              },
            )
          ],
        );
      });
    } catch (error) {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: "Error!",
          text: error.toString(),
          borderRadius: 8,
          confirmBtnColor: mainColor
      );
      setState(() {
        _button = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              child: CupertinoButton(
                color: mainColor,
                child: Text("Login"),
                onPressed: login,
              ),
            ),
            Padding(padding: EdgeInsets.all(4)),
            CupertinoButton(
              child: Text("Don't have an account?", style: TextStyle(color: mainColor),),
              onPressed: () {
                router.navigateTo(context, "/auth/register", transition: TransitionType.fadeIn, clearStack: true);
              },
            )
          ],
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.all(32)),
              Text("Welcome,", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: mainColor),),
              Padding(padding: EdgeInsets.all(4)),
              Text("Sign in to continue!", style: TextStyle(fontSize: 18, color: currDividerColor),),
              Padding(padding: EdgeInsets.all(32)),
              TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    labelText: "Email",
                  ),
                  onChanged: (input) {
                    currUser.email = input;
                  },
                  textCapitalization: TextCapitalization.none,
                  keyboardType: TextInputType.emailAddress
              ),
              Padding(padding: EdgeInsets.all(4)),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),
                  labelText: "Password",
                ),
                onChanged: (input) {
                  _password = input;
                },
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
              ),
              Padding(padding: EdgeInsets.all(16)),
              _button,
            ],
          ),
        ),
      ),
    );
  }
}
