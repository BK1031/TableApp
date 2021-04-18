import 'package:flutter/material.dart';
import 'package:table/utils/theme.dart';
import 'hero_dialog_route.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupSelectPageState createState() => _GroupSelectPageState();
}

class _GroupSelectPageState extends State<GroupsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Group 1',
            ),
            Visibility(
              visible: true,
              child: Text(
                'Group ID',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Color(0xFFafbaca),
                ),
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      child:Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                print("tapped");
                              },
                              child: Container(
                                height: 80,
                                width: 400,
                                child: const ListTile(
                                  leading: Icon(Icons.people),
                                  title: Text('Group 1'),
                                  subtitle: Text('Bharat, Thomas, Kashyap, Rohan'),
                                ),
                              ),
                            )
                          ]
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}