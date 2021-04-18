import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table/models/group.dart';
import 'package:table/utils/config.dart';
import 'package:table/utils/theme.dart';

class EventAddSuggestion extends StatefulWidget {
  String groupid;
  String eventid;
  String section;
  String userid;
  
  EventAddSuggestion(this.groupid, this.eventid, this.section, this.userid);
  
  @override
  _EventAddSuggestionState createState() => _EventAddSuggestionState(groupid, eventid, section, userid);
}

class _EventAddSuggestionState extends State<EventAddSuggestion> {
  String groupid;
  String eventid;
  String section;
  String userid;
  
  int page = 0;
  PageController pageController = new PageController();

  String suggestName = "";
  String suggestLocation = "";
  
  _EventAddSuggestionState(this.groupid, this.eventid, this.section, this.userid);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      height: page == 0 ? 300 : 475,
      width: 1000,
      child: Column(
        children: [
          Container(
            child: Text(
              "New Suggestion"
            ),
          ),
          Padding(padding: EdgeInsets.all(15)),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)
              ),
              labelText: "Name",
            ),
            maxLines: null,
            onChanged: (input) {
              suggestName = input;
            },
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
          ),
          Padding(padding: EdgeInsets.all(15)),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)
              ),
              labelText: "Location",
            ),
            maxLines: null,
            onChanged: (input) {
              suggestLocation = input;
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
                  if (suggestName != "" && suggestLocation != "") {
                    FirebaseDatabase.instance.reference().child("groups").child(groupid).child("events").child(eventid).child("sections").child(section).child(suggestName).set({
                      "location": suggestLocation,
                      "votes1": userid
                    });
                    router.pop(context);
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }
}