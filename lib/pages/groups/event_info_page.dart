
import 'package:firebase_core/firebase_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table/utils/theme.dart';
import 'package:firebase_database/firebase_database.dart';

class EventInfoPage extends StatefulWidget {
  String eventid;
  String groupid;
  String userid;
  EventInfoPage(this.eventid, this.groupid, this.userid);
  @override
  _EventInfoPageState createState() => _EventInfoPageState(eventid, groupid, userid);
}

class _EventInfoPageState extends State<EventInfoPage> {
  String eventid;
  String groupid;
  String userid;

  Map<String, dynamic> sections = {};

  List<Map<String, dynamic>> suggestionCards = [];
  /*
  text
  -1 votes
  0 votes
  1 votes
  total votes
   */

  List<Widget> sectionWidgets = [];


  Card makeSuggestionCard (String sectionName, String suggestionName, DataSnapshot snapshot) {
    var suggestionText = suggestionName;
    if (sectionName == "0time") {
      suggestionText = suggestionText.replaceAll(";", ":");
      suggestionText = suggestionText.replaceAll(",", ".");
      var date = DateTime.parse(suggestionText);
      suggestionText = date.month.toString() + "/" + date.day.toString() + " " + date.hour.toString() + ":" + date.minute.toString();
    }

    int didVote = -2;
    int voteNoCount = 0;
    int voteMidCount = 0;
    int voteYesCount = 0;

    int totalScore = 0;

    var value = snapshot.value["sections"][sectionName][suggestionName];

    //clear other votes
    List<String> votesNoList = [];
    List<String> votesMidList = [];
    List<String> votesYesList = [];

    if (value.containsKey("votes-1")) {
      votesNoList = value["votes-1"].split(",");
    }
    if (value.containsKey("votes0")) {
      votesMidList = value["votes0"].split(",");
    }
    if (value.containsKey("votes1")) {
      votesYesList = value["votes1"].split(",");
    }

    setState(() {
      if (votesNoList.contains(userid)) {
        didVote = -1;
      }
      if (votesMidList.contains(userid)) {
        didVote = 0;
      }
      if (votesYesList.contains(userid)) {
        didVote = 1;
      }
      voteNoCount = votesNoList.length;
      voteMidCount = votesMidList.length;
      voteYesCount = votesYesList.length;

      totalScore = voteYesCount-voteNoCount;
    });

    return new Card(
      color: currCardColor,
      child: Container(
        width: 200,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                suggestionText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20
                ),
              )
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "vote",
                      style: TextStyle(
                          fontSize: 10
                      ),
                    ),
                  )
                ),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(right: 30),
                        child: Text(
                          "total",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 10
                          ),
                        )
                    )
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 5, left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      width: 30,
                      height: 30,
                      child: CupertinoButton(
                        child: Container(
                            width: 30,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                  width: 1,
                                  color: didVote != -1 ? Colors.grey : Colors.blue
                              ),
                            ),
                            child: Icon(
                                CupertinoIcons.xmark,
                                color: didVote != -1 ? Colors.grey : Colors.blue,
                                size: 13
                            )
                        ),
                        padding: EdgeInsets.zero,
                        borderRadius: BorderRadius.circular(15.0),
                        onPressed: (){
                          FirebaseDatabase.instance.reference().child("groups").child(groupid).child("events").child(eventid).child("sections").child(sectionName).child(suggestionName).once().then((value) {
                            //clear other votes
                            List<String> votesNoList = [];
                            List<String> votesMidList = [];
                            List<String> votesYesList = [];

                            if (value.value.containsKey("votes-1")) {
                              votesNoList = value.value["votes-1"].split(",");
                            }
                            if (value.value.containsKey("votes0")) {
                              votesMidList = value.value["votes0"].split(",");
                            }
                            if (value.value.containsKey("votes1")) {
                              votesYesList = value.value["votes1"].split(",");
                            }

                            if (votesNoList.contains(userid)) {
                              votesNoList.remove(userid);
                            }
                            if (votesMidList.contains(userid)) {
                              votesMidList.remove(userid);
                            }
                            if (votesYesList.contains(userid)) {
                              votesYesList.remove(userid);
                            }

                            votesNoList.add(userid);
                            String votesNo = votesNoList.toString().replaceAll("[", "");
                            votesNo = votesNo.replaceAll("]", "");
                            votesNo = votesNo.replaceAll(" ", "");
                            String votesMid = votesMidList.toString().replaceAll("[", "");
                            votesMid = votesMid.replaceAll("]", "");
                            votesMid = votesMid.replaceAll(" ", "");
                            String votesYes = votesYesList.toString().replaceAll("[", "");
                            votesYes = votesYes.replaceAll("]", "");
                            votesYes = votesYes.replaceAll(" ", "");
                            FirebaseDatabase.instance.reference().child("groups").child(groupid).child("events").child(eventid).child("sections").child(sectionName).child(suggestionName).update({"votes-1": votesNo});
                            FirebaseDatabase.instance.reference().child("groups").child(groupid).child("events").child(eventid).child("sections").child(sectionName).child(suggestionName).update({"votes0": votesMid});
                            FirebaseDatabase.instance.reference().child("groups").child(groupid).child("events").child(eventid).child("sections").child(sectionName).child(suggestionName).update({"votes1": votesYes});

                            setState(() {

                            });
                          });
                        }
                      )
                  ),
                  Container(
                      width: 30,
                      height: 30,
                      child: CupertinoButton(
                          child: Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(
                                    width: 1,
                                    color: didVote != 0 ? Colors.grey : Colors.blue
                                ),
                              ),
                              child: Icon(
                                  CupertinoIcons.minus,
                                  color: didVote != 0 ? Colors.grey : Colors.blue,
                                  size: 13
                              )
                          ),
                          padding: EdgeInsets.zero,
                          borderRadius: BorderRadius.circular(15.0),
                          onPressed: (){
                            FirebaseDatabase.instance.reference().child("groups").child(groupid).child("events").child(eventid).child("sections").child(sectionName).child(suggestionName).once().then((value) {
                              //clear other votes
                              List<String> votesNoList = [];
                              List<String> votesMidList = [];
                              List<String> votesYesList = [];

                              if (value.value.containsKey("votes-1")) {
                                votesNoList = value.value["votes-1"].split(",");
                              }
                              if (value.value.containsKey("votes0")) {
                                votesMidList = value.value["votes0"].split(",");
                              }
                              if (value.value.containsKey("votes1")) {
                                votesYesList = value.value["votes1"].split(",");
                              }

                              if (votesNoList.contains(userid)) {
                                votesNoList.remove(userid);
                              }
                              if (votesMidList.contains(userid)) {
                                votesMidList.remove(userid);
                              }
                              if (votesYesList.contains(userid)) {
                                votesYesList.remove(userid);
                              }

                              votesMidList.add(userid);
                              String votesNo = votesNoList.toString().replaceAll("[", "");
                              votesNo = votesNo.replaceAll("]", "");
                              votesNo = votesNo.replaceAll(" ", "");
                              String votesMid = votesMidList.toString().replaceAll("[", "");
                              votesMid = votesMid.replaceAll("]", "");
                              votesMid = votesMid.replaceAll(" ", "");
                              String votesYes = votesYesList.toString().replaceAll("[", "");
                              votesYes = votesYes.replaceAll("]", "");
                              votesYes = votesYes.replaceAll(" ", "");
                              FirebaseDatabase.instance.reference().child("groups").child(groupid).child("events").child(eventid).child("sections").child(sectionName).child(suggestionName).update({"votes-1": votesNo});
                              FirebaseDatabase.instance.reference().child("groups").child(groupid).child("events").child(eventid).child("sections").child(sectionName).child(suggestionName).update({"votes0": votesMid});
                              FirebaseDatabase.instance.reference().child("groups").child(groupid).child("events").child(eventid).child("sections").child(sectionName).child(suggestionName).update({"votes1": votesYes});

                              setState(() {

                              });
                            });
                          }
                      )
                  ),
                  Container(
                      width: 30,
                      height: 30,
                      child: CupertinoButton(
                        child: Container(
                            width: 30,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                  width: 1,
                                  color: didVote != 1 ? Colors.grey : Colors.blue
                              ),
                            ),
                            child: Icon(
                                CupertinoIcons.checkmark,
                                color: didVote != 1 ? Colors.grey : Colors.blue,
                                size: 13
                            )
                        ),
                        padding: EdgeInsets.zero,

                        //color: Colors.lightGreen,
                        borderRadius: BorderRadius.circular(15.0),
                        alignment: Alignment.center,
                        onPressed: (){
                          FirebaseDatabase.instance.reference().child("groups").child(groupid).child("events").child(eventid).child("sections").child(sectionName).child(suggestionName).once().then((value) {
                            //clear other votes
                            List<String> votesNoList = [];
                            List<String> votesMidList = [];
                            List<String> votesYesList = [];

                            if (value.value.containsKey("votes-1")) {
                              votesNoList = value.value["votes-1"].split(",");
                            }
                            if (value.value.containsKey("votes0")) {
                              votesMidList = value.value["votes0"].split(",");
                            }
                            if (value.value.containsKey("votes1")) {
                              votesYesList = value.value["votes1"].split(",");
                            }

                            if (votesNoList.contains(userid)) {
                              votesNoList.remove(userid);
                            }
                            if (votesMidList.contains(userid)) {
                              votesMidList.remove(userid);
                            }
                            if (votesYesList.contains(userid)) {
                              votesYesList.remove(userid);
                            }

                            votesYesList.add(userid);
                            String votesNo = votesNoList.toString().replaceAll("[", "");
                            votesNo = votesNo.replaceAll("]", "");
                            votesNo = votesNo.replaceAll(" ", "");
                            String votesMid = votesMidList.toString().replaceAll("[", "");
                            votesMid = votesMid.replaceAll("]", "");
                            votesMid = votesMid.replaceAll(" ", "");
                            String votesYes = votesYesList.toString().replaceAll("[", "");
                            votesYes = votesYes.replaceAll("]", "");
                            votesYes = votesYes.replaceAll(" ", "");
                            FirebaseDatabase.instance.reference().child("groups").child(groupid).child("events").child(eventid).child("sections").child(sectionName).child(suggestionName).update({"votes-1": votesNo});
                            FirebaseDatabase.instance.reference().child("groups").child(groupid).child("events").child(eventid).child("sections").child(sectionName).child(suggestionName).update({"votes0": votesMid});
                            FirebaseDatabase.instance.reference().child("groups").child(groupid).child("events").child(eventid).child("sections").child(sectionName).child(suggestionName).update({"votes1": votesYes});

                            setState(() {

                            });
                          });
                        }
                      )
                  ),

                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        width: 40,
                        height: 30,
                        color: Colors.grey,
                        alignment: Alignment.center,
                        child: Text(
                          totalScore.toString(),
                        ),
                      )
                    )
                  )
                ],
              )
            ),

            Container(
                padding: EdgeInsets.only(top: 5, left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          width: 30,
                          height: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Container (
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                    voteNoCount.toString()
                                )
                              ),
                              Container(
                                //child: votersNo
                              )
                            ],
                          )
                        )
                      )
                    ),
                    Container(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Container(
                                width: 30,
                                height: 70,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.grey
                                  ),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Container (
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text(
                                            voteMidCount.toString()
                                        )
                                    ),
                                  ],
                                )
                            )
                        )
                    ),
                    Container(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Container(
                                width: 30,
                                height: 70,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.grey
                                  ),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Container (
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text(
                                            voteYesCount.toString()
                                        )
                                    ),
                                  ],
                                )
                            )
                        )
                    ),
                    SizedBox(
                      width: 40,
                      height: 30,
                    )
                  ],
                )
            )
          ],
        ),
      )
    );
  }

  _EventInfoPageState(String gid, String eid, String uid) {
    eventid = eid;
    groupid = gid;
    userid = uid;

    FirebaseDatabase.instance.reference().child("groups").child(groupid).child("events").child(eventid).once().then((value) {
      //t(value.value);
      var eventInfo = Map<String, dynamic>.from(value.value);
      setState(() {
        sections = Map<String, dynamic>.from(eventInfo["sections"]);

        //print(sections);
        if (sections.isNotEmpty) {
          sections.keys.forEach((sectionName) {
            sectionWidgets.add(Container(
              padding: EdgeInsets.only(top:10),
              child: Text(
                sectionName.substring(1) + ":",
                style: TextStyle(
                    fontSize: 30
                ),
                textAlign: TextAlign.left,
              ),
            ));

            List<Widget> suggestionCards = [];

            var suggestions = sections[sectionName];
            suggestions.keys.forEach((suggestionName) {
              suggestionCards.add(makeSuggestionCard(sectionName, suggestionName, value));
            });

            sectionWidgets.add(Container(
                height: 200,
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: suggestionCards
                )
            ));
          });
      };
    });
    });

    FirebaseDatabase.instance.reference().child("groups").child(groupid).child("events").child(eventid).onValue.listen((event) {
      var value = event.snapshot;
      var eventInfo = Map<String, dynamic>.from(value.value);
      setState(() {
        sections = Map<String, dynamic>.from(eventInfo["sections"]);
        sectionWidgets = [];

        //print(sections);
        if (sections.isNotEmpty) {
          sections.keys.forEach((sectionName) {
            sectionWidgets.add(Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                sectionName.substring(1) + ":",
                style: TextStyle(
                    fontSize: 30
                ),
                textAlign: TextAlign.left,
              ),
            ));

            List<Widget> suggestionCards = [];

            var suggestions = sections[sectionName];
            suggestions.keys.forEach((suggestionName) {
              suggestionCards.add(
                  makeSuggestionCard(sectionName, suggestionName, value));
            });

            sectionWidgets.add(Container(
                height: 200,
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: suggestionCards
                )
            ));
          });
        };
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    suggestionCards = [{"text":"suggestion", "-1 votes":1}];

    Widget sectionsWidget = Container();

    if (sectionWidgets.length < 5) {
      sectionsWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sectionWidgets,
      );
    } else {
      sectionsWidget = ListView(
        children: sectionWidgets,
      );
    }
    
    return Container(
      padding: EdgeInsets.fromLTRB(30, 60, 30, 0),
      child: sectionsWidget
    );
  }
}