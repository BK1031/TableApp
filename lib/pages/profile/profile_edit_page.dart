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
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController bioController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

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
        imageUploadTask.snapshotEvents.listen((event) {
          print("UPLOADING: ${event.bytesTransferred.toDouble() / event.totalBytes.toDouble()}");
          setState(() {
            progress = event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
          });
        });
        imageUploadTask.whenComplete(() async {
          var url = await storageRef.child("users").child("${currUser.id}.png").getDownloadURL();
          print(url);
          FirebaseDatabase.instance.reference().child("users").child(currUser.id).child("profilePicture").set(url);
          setState(() {
            currUser.profilePicture = url;
            profileUser.profilePicture = url;
            uploading = false;
          });
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    profileUser = currUser;
    firstNameController.text = profileUser.firstName;
    lastNameController.text = profileUser.lastName;
    phoneController.text = profileUser.phone;
    bioController.text = profileUser.bio;
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width - 32,
        child: CupertinoButton(
          color: mainColor,
          onPressed: () {
            setState(() {
              currUser = profileUser;
            });
            FirebaseDatabase.instance.reference().child("users").child(currUser.id).update({
              "firstName": currUser.firstName.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
              "lastName": currUser.lastName.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
              "email": currUser.email,
              "phone": currUser.phone,
              "gender": currUser.gender,
              "bio": currUser.bio,
            });
            router.pop(context);
          },
          child: Text("Save Changes"),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            new ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(1000)),
              child: new CachedNetworkImage(
                imageUrl: currUser.profilePicture,
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
                profileUser.firstName = input;
              },
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.name,
              controller: firstNameController,
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
                profileUser.lastName = input;
              },
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.name,
              controller: lastNameController,
            ),
            Padding(padding: EdgeInsets.all(4)),
            Padding(padding: EdgeInsets.all(4)),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                ),
                labelText: "Phone Number",
              ),
              onChanged: (input) {
                profileUser.phone = input;
              },
              keyboardType: TextInputType.phone,
              controller: phoneController,
            ),
            Padding(padding: EdgeInsets.all(4)),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                ),
                labelText: "Bio",
              ),
              maxLines: null,
              onChanged: (input) {
                profileUser.bio = input;
              },
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              controller: bioController,
            ),
            Padding(padding: EdgeInsets.all(32)),
          ],
        ),
      ),
    );
  }
}
