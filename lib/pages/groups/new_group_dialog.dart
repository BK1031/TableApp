import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table/models/group.dart';
import 'package:table/utils/config.dart';
import 'package:table/utils/theme.dart';

class NewGroupDialog extends StatefulWidget {
  @override
  _NewGroupDialogState createState() => _NewGroupDialogState();
}

class _NewGroupDialogState extends State<NewGroupDialog> {

  int page = 0;
  PageController pageController = new PageController();

  Group group = new Group();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      height: page == 0 ? 200 : 375,
      width: 1000,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CupertinoButton(
                  color: page == 0 ? mainColor : currCardColor,
                  padding: EdgeInsets.all(0),
                  child: Text("Join", style: TextStyle(color: page == 0 ? Colors.white : currTextColor),),
                  onPressed: () {
                    setState(() {
                      page = 0;
                    });
                    pageController.animateToPage(0, duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
                  },
                ),
              ),
              Expanded(
                child: CupertinoButton(
                  color: page == 1 ? mainColor : currCardColor,
                  padding: EdgeInsets.all(0),
                  child: Text("Create", style: TextStyle(color: page == 1 ? Colors.white : currTextColor),),
                  onPressed: () {
                    setState(() {
                      page = 1;
                      var rnd = new Random();
                      var next = rnd.nextDouble() * 1000000;
                      while (next < 100000) {
                        next *= 10;
                      }
                      group.id = next.toInt().toString();
                    });
                    pageController.animateToPage(1, duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
                  },
                ),
              )
            ],
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  page = index;
                  if (page == 1) {
                    page = 1;
                    var rnd = new Random();
                    var next = rnd.nextDouble() * 1000000;
                    while (next < 100000) {
                      next *= 10;
                    }
                    group.id = next.toInt().toString();
                  }
                });
              },
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 32, bottom: 16),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          labelText: "Join Code",
                          hintText: "######"
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.join,
                        onChanged: (input) {
                          group.id = input;
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.only(left: 32, right: 32),
                          child: Text("Cancel", style: TextStyle(color: mainColor),),
                          onPressed: () {
                            router.pop(context);
                          },
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.only(left: 32, right: 32),
                          color: mainColor,
                          child: Text("Join"),
                          onPressed: () async {
                            if (group.id != "") {
                              await FirebaseDatabase.instance.reference().child("groups").child(group.id).once().then((value) {
                                if (value.value != null) {
                                  FirebaseDatabase.instance.reference().child(
                                      "groups").child(group.id)
                                      .child("users")
                                      .child(currUser.id)
                                      .update({
                                    "id": currUser.id
                                  });
                                  router.pop(context);
                                }
                              });
                            }
                          },
                        )
                      ],
                    )
                  ],
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 32, bottom: 16),
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              labelText: "Join Code",
                              hintText: "######"
                          ),
                          keyboardType: TextInputType.number,
                          enabled: false,
                          textInputAction: TextInputAction.join,
                          controller: TextEditingController()..text = group.id,
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          labelText: "Name",
                        ),
                        onChanged: (input) {
                          group.name = input;
                        },
                        keyboardType: TextInputType.name,
                      ),
                      Padding(padding: EdgeInsets.all(4)),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          labelText: "Description",
                        ),
                        maxLines: null,
                        onChanged: (input) {
                          group.desc = input;
                        },
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                      ),
                      Padding(padding: EdgeInsets.all(16),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CupertinoButton(
                            padding: EdgeInsets.only(left: 32, right: 32),
                            child: Text("Cancel", style: TextStyle(color: mainColor),),
                            onPressed: () {
                              router.pop(context);
                            },
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.only(left: 32, right: 32),
                            color: mainColor,
                            child: Text("Create"),
                            onPressed: () async {
                              if (group.id != "" && group.name != "" && group.desc != "") {
                                FirebaseDatabase.instance.reference().child("groups").child(group.id).set({
                                  "name": group.name,
                                  "desc": group.desc,
                                  "users": {
                                    "${currUser.id}": {"id": currUser.id}
                                  }
                                });
                                router.pop(context);
                              }
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
