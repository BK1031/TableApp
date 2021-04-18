import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table/models/message.dart';
import 'package:table/models/user.dart';
import 'package:table/utils/config.dart';
import 'package:table/utils/theme.dart';

class ChatPage extends StatefulWidget {
  String id;
  ChatPage(this.id);
  @override
  _ChatPageState createState() => _ChatPageState(this.id);
}

class _ChatPageState extends State<ChatPage> {

  String id;

  _ChatPageState(this.id);

  List<Widget> widgetList = [];
  List<Message> chatList = [];
  Message newMessage = new Message();
  FocusNode _focusNode = new FocusNode();
  ScrollController _scrollController = new ScrollController();
  TextEditingController _textController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(focusNodeListener);
    getChat(id);
  }

  Future<Null> focusNodeListener() async {
    if (_focusNode.hasFocus) {
      await Future.delayed(const Duration(milliseconds: 100));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 10.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void getChat(String id) {
    Future.delayed(const Duration(seconds: 1), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 20.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
    FirebaseDatabase.instance.reference().child("groups").child(id).child("chat").onChildAdded.listen((event) async {
      Message message = new Message.fromSnapshot(event.snapshot);
      FirebaseDatabase.instance.reference().child("users").child(message.author.id).once().then((value) {
        message.author = new User.fromSnapshot(value);
        chatList.add(message);
        setState(() {
          // Add the actual chat message widget
          if (chatList.length > 1 && message.author.id == chatList[chatList.length - 2].author.id &&  message.date.difference(chatList[chatList.length - 2].date).inMinutes.abs() < 5) {
            widgetList.add(new InkWell(
              onLongPress: () {},
              child: new Container(
                padding: EdgeInsets.only(left: 12, right: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new Container(width: 52),
                    new Expanded(
                      child: new SelectableText(
                        message.message,
                        style: TextStyle(color: currDividerColor, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ));
          }
          else {
            widgetList.add(new InkWell(
              onLongPress: () {},
              child: new Container(
                padding: EdgeInsets.only(left: 12, top: 8, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    new InkWell(
                      onTap: () {
                        if (message.author.id != currUser.id) {
                          router.navigateTo(context, "/profile/${message.author.id}", transition: TransitionType.nativeModal);
                        }
                      },
                      child: new ClipRRect(
                        borderRadius: new BorderRadius.all(Radius.circular(45)),
                        child: new CachedNetworkImage(
                          imageUrl: message.author.profilePicture,
                          height: 35,
                          width: 35,
                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.all(8)),
                    new Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              new Text(
                                message.author.firstName + " " + message.author.lastName,
                                style: TextStyle(fontSize: 15, color: message.author.id == currUser.id ? mainColor : currTextColor),
                              ),
                              new Text(
                                " • ${DateFormat.jm().format(message.date)}",
                                style: TextStyle(fontSize: 15, color: currDividerColor),
                              ),
                            ],
                          ),
                          new SelectableText(
                            message.message,
                            style: TextStyle(color: currDividerColor, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
          }
        });
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 20.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      });
    });
  }

  void sendMessage() {
    if (newMessage.message.replaceAll(" ", "").replaceAll("\n", "") != "") {
      // Message is not empty
      FirebaseDatabase.instance.reference().child("groups").child(id).child("chat").push().set({
        "message": newMessage.message,
        "author": currUser.id,
        "type": "text",
        "date": DateTime.now().toString(),
      });
      _textController.clear();
      newMessage = Message();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Container(
        color: currBackgroundColor,
        child: Column(
          children: [
            new Expanded(
              child: new SingleChildScrollView(
                controller: _scrollController,
                child: new Column(
                    children: widgetList
                ),
              ),
            ),
            new Container(
              child: new Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                color: currCardColor,
                child: new ListTile(
                    title: Container(
                      child: Row(
                        children: <Widget>[
                          Material(
                            child: new Container(
                              child: new IconButton(
                                icon: new Icon(Icons.image),
                                color: currDividerColor,
                                onPressed: () {
                                },
                              ),
                            ),
                            color: currCardColor,
                          ),
                          // Edit text
                          Flexible(
                            child: Container(
                              child: TextField(
                                controller: _textController,
                                focusNode: _focusNode,
                                textInputAction: TextInputAction.newline,
                                textCapitalization: TextCapitalization.sentences,
                                style: TextStyle(fontSize: 15.0),
                                decoration: InputDecoration.collapsed(
                                    hintText: 'Type your message...',
                                ),
                                onChanged: (input) {
                                  setState(() {
                                    newMessage.message = input;
                                  });
                                },
                                onSubmitted: (input) {
                                  sendMessage();
                                },
                              ),
                            ),
                          ),
                          new Material(
                            child: new Container(
                              child: new IconButton(
                                icon: new Icon(
                                  Icons.send,
                                  color: newMessage.message.replaceAll(" ", "").replaceAll("\n", "") != "" ? mainColor : currDividerColor,
                                ),
                                onPressed: () {
                                  sendMessage();
                                },
                              ),
                            ),
                            color: currCardColor,
                          )
                        ],
                      ),
                      width: double.infinity,
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
