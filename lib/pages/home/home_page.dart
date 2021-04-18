import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:table/models/notification.dart' as push;
import 'package:table/utils/config.dart';
import 'package:table/utils/theme.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Map<String, String>> upcomingEvents = [];
  List<push.Notification> notifications = [];

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
                              color: currDividerColor,
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
                          color: currDividerColor,
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
            width: MediaQuery.of(context).size.width-currentEventWidth - 32,
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

      if (date.year == now.year && date.month == now.month &&
          date.day == now.day) {
        if (date.hour <= 12) {
          time = date.hour.toString() + ":";
        } else {
          time = (date.hour - 12).toString() + ":";
        }

        if (date.minute < 10) {
          time += "0" + date.minute.toString();
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
    }
  }

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  void getNotifications() {
    FirebaseDatabase.instance.reference().child("notifications").onChildAdded.listen((event) {
      push.Notification notification = new push.Notification.fromSnapshot(event.snapshot);
      if (notification.user.id == currUser.id) {
        setState(() {
          notifications.add(notification);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    upcomingEvents = [{"id": "1", "time": "2021-04-17 16:30:00.000000"}, {"id": "2", "time": "2021-04-17 18:30:00.000000"}, {"id": "3", "time": "2021-04-18 16:30:00.000000"}];
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: currDividerColor, //change your color here
        ),
        automaticallyImplyLeading: false,
        title: Text("Table", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: mainColor),),
        backgroundColor: currBackgroundColor,
        elevation: 0,
        centerTitle: false,
      ),
      backgroundColor: currBackgroundColor,
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Upcoming Events",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: currTextColor
              ),
            ),
            upcomingEvents.isEmpty ? Container() : Container (
              padding: EdgeInsets.only(top: 20),
              child: makeCurrentEventRow(upcomingEvents)
            ),
            Padding(padding: EdgeInsets.all(16),),
            Text(
              "Notifications",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: currTextColor
              ),
            ),
            Padding(padding: EdgeInsets.all(4),),
            notifications.isEmpty ? Center(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text("Nothing new to see here!", style: TextStyle(color: currDividerColor),),
              ),
            ) : Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Card(
                    color: currCardColor,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        setState(() {
                          notifications[index].read = true;
                        });
                        FirebaseDatabase.instance.reference().child("notifications").child(notifications[index].id).child("read").set(true);
                        router.navigateTo(context, notifications[index].link, transition: TransitionType.native);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Container(padding: EdgeInsets.all(16), child: Icon(notifications[index].read ? Icons.notifications_none : Icons.notifications, color: notifications[index].read ? currDividerColor : mainColor)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(notifications[index].title, style: TextStyle(color: currTextColor, fontSize: 20)),
                                  Padding(padding: EdgeInsets.all(2),),
                                  Text(notifications[index].desc, style: TextStyle(color: currDividerColor, fontSize: 16),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
