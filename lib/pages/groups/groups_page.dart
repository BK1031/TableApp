import 'package:flutter/material.dart';
import 'package:table/utils/theme.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Groups", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: mainColor),),
        backgroundColor: currBackgroundColor,
        elevation: 0,
        centerTitle: false
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // onPressed code
        },
        child: const Icon(Icons.add),
        backgroundColor: mainColor,
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
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () {
                              print('Card tapped.');
                            },
                          ),
                          SizedBox(
                            width: 300,
                            height: 100,
                            child: const ListTile(
                              leading: Icon(Icons.album),
                              title: Text('Group 1'),
                              subtitle: Text('Bharat, Thomas, Kashyap, Rohan')
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
