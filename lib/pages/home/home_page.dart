import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:table/utils/theme.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  String id;
  HomePage(this.id);
  @override
  _HomePageState createState() => _HomePageState(id);
}

class _HomePageState extends State<HomePage> {
  String userid;

  List<Map<String, String>> upcomingEvents = [];
  List<Map<String, String>> notifications = [];

  List<String> shortcutsList = ["Join a group", "Add a new friend", "Send a message in ", "Suggest an event in "];

  Row makeCurrentEventRow (List<Map<String, String>> upcomingEvents) {
    upcomingEvents.sort((a,b) {
      return a["time"].compareTo(b["time"]);
    });

    Container currentEvent = new Container();
    double currentEventWidth = 0;
    List<Widget> upcomingEventsWidgets = [];
    for (var i = 0; i<upcomingEvents.length; i++) {
      DateTime date = DateTime.parse(upcomingEvents[i]["time"]);
      DateTime now = new DateTime.now();
      bool today = true;
      String time = "";
      bool am = true;

      double widgetSize = 100.0;

      if (date.year == now.year && date.month == now.month && date.day == now.day) {
        if (date.hour <= 12) {
          time = date.hour.toString()+":";
        } else {
          time = (date.hour-12).toString() + ":";
        }

        if (date.minute < 10) {
          time += "0"+date.minute.toString();
        } else {
          time += date.minute.toString();
        }

        if (date.hour < 12) {
          am = true;
        } else {
          am = false;
        }

        if (i == 0 && (date.difference(now).inMinutes <= 60)) {
          widgetSize = 200.0;
          currentEventWidth = 200.0;

          currentEvent = new Container(
              padding: EdgeInsets.only(left: 30),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(widgetSize/2),
                  child: Container(
                      width: widgetSize,
                      height: widgetSize,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(widgetSize/2),
                          border: Border.all(
                              color: Colors.grey,
                              width: 2
                          ),
                        color: currCardColor
                      ),

                      child: Center(
                          child: Container(
                              height: widgetSize/2,
                              child: Column(
                                  children: [
                                    Text(
                                      time,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: widgetSize/4,
                                        fontWeight: FontWeight.bold,
                                        color: currTextColor
                                      ),
                                    ),
                                    !today ? Container() : Text(
                                      am ? "AM" : "PM",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: widgetSize/8,
                                          fontWeight: FontWeight.bold,
                                          color: currTextColor
                                      ),
                                    )
                                  ]
                              )
                          )
                      )
                  )
              )
          );
          continue;
        }
      } else {
        today = false;
        time = date.month.toString() + "/" + date.day.toString();
      }

      upcomingEventsWidgets.add(new Container(
          padding: EdgeInsets.only(left: 30),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(widgetSize/2),
              child: Container(
                  width: widgetSize,
                  height: widgetSize,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widgetSize/2),
                      border: Border.all(
                          color: Colors.grey,
                          width: 2
                      ),
                      color: currCardColor,
                  ),

                  child: Center(
                      child: Container(
                          height: widgetSize/2,
                          child: Column(
                              children: [
                                Text(
                                  time,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: widgetSize/4,
                                      fontWeight: FontWeight.bold,
                                      color: currTextColor
                                  ),
                                ),
                                !today ? Container() : Text(
                                  am ? "AM" : "PM",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: widgetSize/8,
                                      fontWeight: FontWeight.bold,
                                      color: currTextColor
                                  ),
                                )
                              ]
                          )
                      )
                  )
              )
          )
      ));
    }
    
    return Row (
      children: [
        currentEvent,
        Container (
            height: 100,
            width: MediaQuery.of(context).size.width-currentEventWidth-30,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: upcomingEventsWidgets
            )
        )
      ]
    );
  }

  Expanded makeNotificationRow (List<Map<String, String>> notifications) {
    notifications.sort((a,b) {
      return b["time"].compareTo(a["time"]);
    });

    List<Widget> notificationWidgets = [];
    for (var i = 0; i<notifications.length; i++) {
      DateTime date = DateTime.parse(notifications[i]["time"]);
      DateTime now = new DateTime.now();
      bool today = true;
      String time = "";
      bool am = true;

      if (date.year == now.year && date.month == now.month && date.day == now.day) {
        if (date.hour <= 12) {
          time = date.hour.toString()+":";
        } else {
          time = (date.hour-12).toString() + ":";
        }

        if (date.minute < 10) {
          time += "0"+date.minute.toString();
        } else {
          time += date.minute.toString();
        }

        if (date.hour < 12) {
          am = true;
          time += "AM";
        } else {
          am = false;
          time += "PM";
        }
      } else {
        today = false;
        time = date.month.toString() + "/" + date.day.toString();
      }

      notificationWidgets.add(new Card(
          child: Container(
              /*height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.grey,
                      width: 2
                  )
              ),*/
              child: Center(
                  child: Container(
                      height: 100,
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                    notifications[i]["groupname"],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: currTextColor
                                    ),
                                  )
                              ),

                              Expanded(
                                child: Text(
                                  time,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: currTextColor
                                  ),
                                ),
                              )
                            ]
                          ),

                          Text(
                            notifications[i]["text"],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 20,
                              color: currTextColor
                            ),
                          )
                        ]
                      )
                  )
              )
          )
      )
      );
    }

    return Expanded (
        child: ListView(
          scrollDirection: Axis.vertical,
          children: notificationWidgets
        )
    );
  }

  _HomePageState (String id) {
    userid = id;

    FirebaseDatabase.instance.reference().child("groups").once().then((value) {
      var groups = Map<String, dynamic>.from(value.value);
      groups.forEach((key, groupInfo) {
        var users = groupInfo["users"];
        if (users.keys.contains(userid)) {
          if (groupInfo.keys.contains("events")) {
            List<String> eventKeys = List<String>.from(groupInfo["events"].keys);
            eventKeys.forEach((eventKey) {
              Map<String, String> eventInfo = Map<String, String>.from(groupInfo["events"][eventKey]);
              if (eventInfo["status"] != "previous") {
                setState(() {
                  upcomingEvents.add({
                    "id": eventKey,
                    "time": eventInfo["time"]
                  });
                });
              }
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //upcomingEvents = [{"id": "1", "time": "2021-04-17 16:30:00.000000"}, {"id": "2", "time": "2021-04-17 18:30:00.000000"}, {"id": "3", "time": "2021-04-18 16:30:00.000000"}];
    notifications = [{"id": "1", "groupid": "g1", "groupname": "group 1", "text": "New message in group", "time": "2021-04-17 12:30:00.000000"}, {"id": "1", "groupid": "g1", "groupname": "group 1", "text": "New suggestion in group", "time": "2021-04-17 10:30:00.000000"}];

    return Container(
      padding: EdgeInsets.only(top: 60),
      child: Column(
        children: [
          upcomingEvents.isEmpty ? Container() : Container(
            child: Text(
              "Upcoming Events",
              style: TextStyle(
                fontSize: 30,
                color: currTextColor
              ),
            ),
          ),

          upcomingEvents.isEmpty ? Container() : Container (
            padding: EdgeInsets.only(top: 20),
            child: makeCurrentEventRow(upcomingEvents)
          ),

          notifications.isEmpty ? Container() : Container(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              "Notifications",
              style: TextStyle(
                fontSize: 30,
                color: currTextColor
              ),
            ),
          ),

          notifications.isEmpty ? Container() : makeNotificationRow(notifications),
        ],
      ),
    );
  }
}
