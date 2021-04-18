import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table/utils/theme.dart';
import 'package:firebase_database/firebase_database.dart';

class EventInfoPage extends StatefulWidget {
  String eventid;
  String groupid;
  EventInfoPage(this.eventid, this.groupid);
  @override
  _EventInfoPageState createState() => _EventInfoPageState(eventid, groupid);
}

class _EventInfoPageState extends State<EventInfoPage> {
  String eventid;
  String groupid;
  List<Map<String, dynamic>> suggestionCards = [];
  /*
  text
  -1 votes
  0 votes
  1 votes
  total votes
   */

  Card makeSuggestionCard (int index) {
    return Card(
      child: Column(
        children: [
          Text(
            suggestionCards[index]["text"]
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Vote"
                )
              ),
              Expanded(
                child: Text(
                  "Vote",
                  textAlign: TextAlign.right,
                )
              )
            ],
          ),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                child: CupertinoButton(
                  child: Text(
                    "-1"
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                  alignment: Alignment.center,
                  onPressed: (){
  
                  }
                )
              )
            ],
          )
        ],
      ),
    );
  }

  _EventInfoPageState(String eid, String gid) {
    eventid = eid;
    groupid = gid;
  }

  @override
  Widget build(BuildContext context) {
    suggestionCards = [{"text":"suggestion", "-1 votes":1}];
    
    return Container(
      child: makeSuggestionCard(0)
    );
  }
}