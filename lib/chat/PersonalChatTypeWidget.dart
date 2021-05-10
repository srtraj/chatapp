import 'package:chatapp/firebaseMessage/messaging.dart';
import 'package:chatapp/model/msgList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// ignore: must_be_immutable
class PersonalChatTypeWidet extends StatelessWidget {
  PersonalChatTypeWidet(this.receiverId, {Key key}) : super(key: key);
  String receiverId;
  final firebase = FirebaseFirestore.instance.collection("data");

  TextEditingController cntMsg = TextEditingController();
  void addMsgList(MsgList msglist) {
    final contactsBox = Hive.box(receiverId);
    contactsBox.add(msglist);
  }

  sendMsgToFire(msg) {
    firebase
        .doc(receiverId)
        .collection("chat")
        .doc(FirebaseAuth.instance.currentUser.phoneNumber)
        .set({
      "msg": FieldValue.arrayUnion([msg])
    }, SetOptions(merge: true));

    // firebase
    //     .doc(receiverId)
    //     .collection("chat")
    //     .doc(FirebaseAuth.instance.currentUser.phoneNumber)
    //     .get()
    //     .then((value) => {if (value.exists) print(value["msg"])});
  }

  Future sendNotification(context, title, body, token) async {
    final response =
        await Messaging.sendToAll(title: title, body: body, topic: token);
    if (response.statusCode != 200) {
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final wt = MediaQuery.of(context).size.width / 100;
    final ht = MediaQuery.of(context).size.height / 100;
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: EdgeInsets.only(left: wt * 2, right: wt * 2),
              child: TextField(
                controller: cntMsg,
                decoration: InputDecoration(
                    hintText: "Write message...",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none),
              ),
            ),
          ),
        ),
        IconButton(
            icon: Icon(Icons.send_sharp),
            iconSize: ht * wt,
            onPressed: () async {
              if (cntMsg.text.isNotEmpty) {
                final newMsg = MsgList(cntMsg.text, false, DateTime.now());
                addMsgList(newMsg);
                await firebase.doc(receiverId).get().then((value) => {
                      if (value.exists)
                        sendNotification(
                            context,
                            FirebaseAuth.instance.currentUser.phoneNumber,
                            cntMsg.text,
                            value['FcmToken'])
                    });
                cntMsg.clear();
              }
            })
      ],
    );
  }
}
