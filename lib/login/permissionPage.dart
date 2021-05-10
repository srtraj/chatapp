import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatapp/chat/chatListPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PermissionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final wt = mq.width / 100;
    final ht = mq.height / 100;
    return Scaffold(
      body: Center(
        child: Card(
          color: Colors.grey.withOpacity(.5),
          child: Container(
            height: ht * 50,
            width: wt * 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: ht * 2,
                ),
                AutoSizeText(
                  "Please continue to allow Contact permission to chat with contact list",
                  minFontSize: 15,
                  maxFontSize: 25,
                  style: TextStyle(fontSize: 20),
                ),
                Row(
                  children: [
                    Expanded(child: Container()),
                    ElevatedButton(
                        onPressed: () {
                          moveToChatPage(context);
                        },
                        child: Text("deny")),
                    SizedBox(
                      width: wt * 5,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          _askCameraPermission(context);
                        },
                        child: Text("Continue")),
                    SizedBox(
                      width: wt * 2,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _askCameraPermission(context) async {
    await Permission.contacts.request();
    await createRequiredFied();
    moveToChatPage(context);
  }

  moveToChatPage(context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ChatListPage()),
        ModalRoute.withName("/Home"));
  }

  createRequiredFied() {
    final firebase = FirebaseFirestore.instance.collection("data");
    firebase.doc(FirebaseAuth.instance.currentUser.phoneNumber).set({
      "online": true,
      "name": FirebaseAuth.instance.currentUser.phoneNumber,
      "FcmToken": ""
    });
  }
}
