
import 'package:firebase_core/firebase_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table/pages/groups/event_add_suggestion.dart';
import 'package:table/utils/config.dart';
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
      voteNoCount = votesNoList.length-1;
      voteMidCount = votesMidList.length-1;
      voteYesCount = votesYesList.length-1;

      totalScore = voteYesCount-voteNoCount;

      FirebaseDatabase.instance.reference().child("groups").child(groupid).child("events").child(eventid).child("sections").child(sectionName).child(suggestionName).update({"score": totalScore});
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
                                  color: didVote != -1 ? Colors.grey : mainColor
                              ),
                            ),
                            child: Icon(
                                CupertinoIcons.xmark,
                                color: didVote != -1 ? Colors.grey : mainColor,
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
                                    color: didVote != 0 ? Colors.grey : mainColor
                                ),
                              ),
                              child: Icon(
                                  CupertinoIcons.minus,
                                  color: didVote != 0 ? Colors.grey : mainColor,
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
                                  color: didVote != 1 ? Colors.grey : mainColor
                              ),
                            ),
                            child: Icon(
                                CupertinoIcons.checkmark,
                                color: didVote != 1 ? Colors.grey : mainColor,
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
                            color: currCardColor,
                          ),
                          child: Column(
                            children: [
                              Container (
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                    voteNoCount.toString(),
                                  style: TextStyle(
                                      color: currTextColor
                                  ),
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
                                  color: currCardColor,
                                ),
                                child: Column(
                                  children: [
                                    Container (
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text(
                                            voteMidCount.toString(),
                                          style: TextStyle(
                                              color: currTextColor
                                          ),
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
                                  color: currCardColor,
                                ),
                                child: Column(
                                  children: [
                                    Container (
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text(
                                            voteYesCount.toString(),
                                          style: TextStyle(
                                            color: currTextColor
                                          ),
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
                    fontSize: 30,
                  color: currTextColor
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

            Card newSuggestionButton = new Card(
              color: currCardColor,
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: mainColor,
                    width: 2
                  ),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: CupertinoButton(
                  child: Icon(
                    CupertinoIcons.plus,
                    size: 50,
                    color: mainColor,
                  ),
                  onPressed: () {
                    showDialog(context: context, builder: (context) => AlertDialog(
                      backgroundColor: currCardColor,
                      content: EventAddSuggestion(groupid, eventid, sectionName, userid),
                    ));
                  },
                )
              )
            );

            suggestionCards.add(newSuggestionButton);

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
      padding: EdgeInsets.fromLTRB(30, 60, 30, 20),
      child: Column(
        children: [
          sectionsWidget,
          Expanded(child: Container()),
          Container(
            height: 50,
            child: CupertinoButton(
              color: mainColor,
              child: Text(
                "I'm going!"
              ),
              onPressed: (){ showDialog(context: context, builder: (context) => AlertDialog(
                backgroundColor: currCardColor,
                content: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  height: 200,
                  width: 1000,
                  child: Column(
                    children: [
                      Text(
                        "Are you sure?",
                        style: TextStyle(
                          fontSize: 30
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
                      Text(
                        "If you click \"confirm\", this event will be finalized. Otherwise, just click out.",
                        style: TextStyle(
                            fontSize: 15
                        ),
                      ),

                      Expanded(child: Container()),

                      CupertinoButton(
                        padding: EdgeInsets.only(left: 32, right: 32),
                        color: mainColor,
                        child: Text("Create"),
                        onPressed: () async {
                          FirebaseDatabase.instance.reference().child("groups").child(groupid).child("events").child(eventid).child("sections").once().then((value) {
                            Map<String, dynamic> sections = Map<String, dynamic>.from(value.value);
                            List<String> sectionNames = List<String>.from(value.value.keys);
                            var setTime = "";
                            var setTimeVotes = 0;
                            List<String> times = List<String>.from(sections[sectionNames[0]].keys);
                            times.forEach((element) {
                              if (sections[sectionNames[0]][element]["score"] > setTimeVotes) {
                                setTime = sectionNames[0].substring(1);
                              }
                            });

                            var setPlace = "";
                            var setPlaceVotes = 0;
                            List<String> places = List<String>.from(sections[sectionNames[1]].keys);
                            places.forEach((element) {
                              if (sections[sectionNames[1]][element]["score"] > setPlaceVotes) {
                                setPlace = sectionNames[1].substring(1);
                              }
                            });

                            FirebaseDatabase.instance.reference().child("groups").child(groupid).child("events").child(eventid).child("final").set({
                              "time": setTime,
                              "place": setPlace
                            });
                          });
                          router.navigateTo(context, "/");
                        },
                      )
                    ]
                  )
                )
              ));},
            )
          )
        ]
      )
    );
  }
}