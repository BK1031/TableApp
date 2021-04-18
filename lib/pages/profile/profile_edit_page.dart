import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table/models/user.dart';
import 'package:table/utils/config.dart';
import 'package:table/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {

  User profileUser = User();

  final storageRef = FirebaseStorage.instance.ref();

  bool uploading = false;
  double progress = 0.0;

  Future<void> pickImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    if (image != null) {
      var croppedImage = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        maxHeight: 512,
        maxWidth: 512,
      );
      if (croppedImage != null) {
        setState(() {
          uploading = true;
        });
        print("UPLOADING");
        UploadTask imageUploadTask = storageRef.child("users").child("${currUser.id}.png").putFile(croppedImage);
        imageUploadTask.asStream().listen((event) {
          print("UPLOADING: ${event.bytesTransferred.toDouble() / event.totalBytes.toDouble()}");
          setState(() {
            progress = event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
          });
        });
        imageUploadTask.whenComplete(() {
          var downurl = imageUploadTask.snapshot.ref.getDownloadURL();
          var url = downurl.toString();
          print(url);
          FirebaseDatabase.instance.reference().child("users").child(currUser.id).child("profilePicture").set(url);
          setState(() {
            currUser.profilePicture = url;
            uploading = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile", style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: mainColor),),
        backgroundColor: currBackgroundColor,
        elevation: 0,
      ),
      backgroundColor: currBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new Padding(padding: EdgeInsets.all(16)),
                    new ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      child: new Image.network(
                        currUser.profilePicture,
                        height: 100,
                        width: 100,
                      ),
                    ),
                    new Visibility(
                      visible: uploading,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: new LinearProgressIndicator(
                          value: progress,
                        ),
                      ),
                    ),
                    new Visibility(
                      visible: !uploading,
                      child: new CupertinoButton(
                          child: new Text("Edit Picture", style: TextStyle(color: mainColor),),
                          onPressed: () {
                            pickImage();
                          }
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        labelText: "First Name",
                      ),
                      onChanged: (input) {
                        currUser.firstName = input;
                      },
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.name,
                    ),
                    Padding(padding: EdgeInsets.all(4)),
                    TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          labelText: "Last Name",
                        ),
                        onChanged: (input) {
                          currUser.lastName = input;
                        },
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.name
                    ),
                    Padding(padding: EdgeInsets.all(4)),
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
