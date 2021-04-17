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

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

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
            child: Text("Register"),
            onPressed: register,
          ),
        ),
        Padding(padding: EdgeInsets.all(4)),
        CupertinoButton(
          child: Text("Already have an account?", style: TextStyle(color: mainColor),),
          onPressed: () {
            router.navigateTo(context, "/auth/login", transition: TransitionType.fadeIn, clearStack: true);
          },
        )
      ],
    );
  }

  Future<void> register() async {
    setState(() {
      _button = Center(
        child: new HeartbeatProgressIndicator(
          child: new Image.asset("images/table-logo.png", height: 50,),
        ),
      );
    });
    try {
      if (currUser.firstName != "" && currUser.lastName != "" && currUser.email != "") {
        await fb.FirebaseAuth.instance.createUserWithEmailAndPassword(email: currUser.email, password: _password).then((value) async {
          currUser.id = fb.FirebaseAuth.instance.currentUser.uid;
          await FirebaseDatabase.instance.reference().child("users").child(currUser.id).set({
            "firstName": currUser.firstName.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
            "lastName": currUser.lastName.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
            "email": currUser.email,
            "phone": currUser.phone,
            "gender": currUser.gender,
            "profilePicture": currUser.profilePicture,
          });
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
                child: Text("Register"),
                onPressed: register,
              ),
            ),
            Padding(padding: EdgeInsets.all(4)),
            CupertinoButton(
              child: Text("Already have an account?", style: TextStyle(color: mainColor),),
              onPressed: () {
                router.navigateTo(context, "/auth/login", transition: TransitionType.fadeIn, clearStack: true);
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
                child: Text("Register"),
                onPressed: register,
              ),
            ),
            Padding(padding: EdgeInsets.all(4)),
            CupertinoButton(
              child: Text("Already have an account?", style: TextStyle(color: mainColor),),
              onPressed: () {
                router.navigateTo(context, "/auth/login", transition: TransitionType.fadeIn, clearStack: true);
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
              Text("Create an account to get started!", style: TextStyle(fontSize: 18, color: currDividerColor),),
              Padding(padding: EdgeInsets.all(32)),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                  labelText: "First Name",
                ),
                onChanged: (input) {
                  currUser.firstName = input;
                },
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name,
              ),
              Padding(padding: EdgeInsets.all(4)),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),
                  labelText: "Last Name",
                ),
                onChanged: (input) {
                  currUser.lastName = input;
                },
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name
              ),
              Padding(padding: EdgeInsets.all(4)),
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
