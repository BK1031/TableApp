import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                          )
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
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    !today ? Container() : Text(
                                      am ? "AM" : "PM",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: widgetSize/8,
                                          fontWeight: FontWeight.bold
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
                      )
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
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                !today ? Container() : Text(
                                  am ? "AM" : "PM",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: widgetSize/8,
                                      fontWeight: FontWeight.bold
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

      notificationWidgets.add(new Container(
          padding: EdgeInsets.all(15),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.grey,
                          width: 2
                      )
                  ),

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
                                            fontWeight: FontWeight.bold
                                        ),
                                      )
                                  ),

                                  Expanded(
                                    child: Text(
                                      time,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
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

    return Expanded (
        child: ListView(
          scrollDirection: Axis.vertical,
          children: notificationWidgets
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> upcomingEvents = [{"id": "1", "time": "2021-04-17 16:30:00.000000"}, {"id": "2", "time": "2021-04-17 18:30:00.000000"}, {"id": "3", "time": "2021-04-18 16:30:00.000000"}];
    List<Map<String, String>> notifications = [{"id": "1", "groupid": "g1", "groupname": "group 1", "text": "New message in group", "time": "2021-04-17 12:30:00.000000"}, {"id": "1", "groupid": "g1", "groupname": "group 1", "text": "New suggestion in group", "time": "2021-04-17 10:30:00.000000"}];

    return Container(
      padding: EdgeInsets.only(top: 60),
      child: Column(
        children: [
          upcomingEvents.isEmpty ? Container() : Container(
            child: Text(
              "Upcoming Events",
              style: TextStyle(
                fontSize: 30,
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
              ),
            ),
          ),

          notifications.isEmpty ? Container() : makeNotificationRow(notifications),
        ],
      ),
    );
  }
}
