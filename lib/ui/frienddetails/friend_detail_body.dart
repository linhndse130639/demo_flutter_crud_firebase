import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_curd_firebase/ui/friends/friend.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../friends/friend.dart';

class FriendDetailBody extends StatefulWidget {
  FriendDetailBody(this.friend);
  final Friend friend;

  @override
  _FriendDetailBodyState createState() => _FriendDetailBodyState();
}

Future<void> updateFriend(Friend friend) async {
  await Firebase.initializeApp();
  CollectionReference friendDb = FirebaseFirestore.instance.collection('friends');
  return friendDb
      .doc(friend.email)
      .set({
    'name': friend.name,
    'avatar': friend.avatar,
    'location': friend.location,
    'email':friend.email
  })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}

class _FriendDetailBodyState extends State<FriendDetailBody> {
  bool flag = false;
  String name, location;
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  Widget _buildLocationInfo(TextTheme textTheme) {
    location = widget.friend.location;
    return new Row(
      children: <Widget>[
        flag
            ? Expanded(
                child: TextFormField(
                cursorColor: Theme.of(context).cursorColor,
                maxLength: 100,
                controller: locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: "Input location here",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6200EE)),
                  ),
                ),
                  style: TextStyle(color: Colors.white),
              ))
            : new Text(
                location,
                style: textTheme.subhead.copyWith(color: Colors.white),
              ),
        new Icon(
          Icons.place,
          color: Colors.white,
          size: 16.0,
        ),
      ],
    );
  }

  Widget _createCircleBadge(IconData iconData, Color color) {
    return new Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: new CircleAvatar(
        backgroundColor: color,
        child: new Icon(
          iconData,
          color: Colors.white,
          size: 16.0,
        ),
        radius: 16.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    name = widget.friend.name;
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(
          children: [
            flag
                ? Expanded(
                    child: TextFormField(
                    cursorColor: Theme.of(context).cursorColor,
                    maxLength: 50,
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nick Name',
                      labelStyle: TextStyle(color: Colors.white),
                      hintText: "Input nick name here",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6200EE)),
                      ),
                    ),
                      style: TextStyle(color: Colors.white),
                  ))
                : Text(
                    name,
                    style: textTheme.headline.copyWith(color: Colors.white),
                  ),
            SizedBox(
              width: 5,
            ),
            IconButton(
              icon: flag ? Icon(Icons.check_circle, color: Colors.white,) : Icon(Icons.edit,color: Colors.white,),
              onPressed: () {
                setState(() {
                  flag = !flag;
                  if (nameController.text.trim() != null && locationController.text.trim() != null) {
                    if(nameController.text.trim().isNotEmpty && locationController.text.trim().isNotEmpty) {
                      name = nameController.text.trim();
                      location = locationController.text.trim();
                      widget.friend.name = name;
                      widget.friend.location = location;
                      Fluttertoast.showToast(
                          msg: "Update Friends Successfull !",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                  }
                });
                updateFriend(widget.friend);
              },
            ),
          ],
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: _buildLocationInfo(textTheme),
        ),
      ],
    );
  }
}
