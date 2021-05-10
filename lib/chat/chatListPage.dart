import 'package:chatapp/firebaseMessage/firebase_notification_handler.dart';
import 'package:chatapp/login/mobileVerificationPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'PersonalChatHome.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  FirebaseNotifications firebaseNotification = new FirebaseNotifications();
  bool isSearching = false;
  FocusNode fnSearch;
  TextEditingController cntSearch = TextEditingController();

  @override
  void initState() {
    fnSearch = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      firebaseNotification.setupFirebase(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    fnSearch.dispose();
    cntSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail:
                Text("${FirebaseAuth.instance.currentUser.phoneNumber}"),
            accountName: Text("unknown"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("assets/emptyImage.png"),
            ),
          ),
          ListTile(
            title: Text("Logout"),
            leading: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                print("logout");
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MobileVerPage()),
                    ModalRoute.withName("/Home"));
              },
            ),
          )
        ],
      )),
      appBar: AppBar(
        title: !isSearching
            ? Text("ChatApp")
            : TextField(
                controller: cntSearch,
                focusNode: fnSearch,
                decoration: InputDecoration(hintText: "Search..."),
              ),
        backgroundColor: Colors.green,
        actions: [
          !isSearching
              ? IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    isSearching = true;
                    setState(() {});
                    fnSearch.requestFocus();
                  },
                )
              : IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    isSearching = false;
                    cntSearch.clear();
                    setState(() {});
                  },
                )
        ],
      ),
      body: new StreamBuilder(
          stream: FirebaseFirestore.instance.collection("data").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data.docs.map((document) {
                var l = {
                  "name": document["name"],
                  "mob": document.id,
                  "online": document["online"],
                  "image": "assets/emptyImage.png"
                };
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(l["image"]),
                  ),
                  title: Text(l["name"]),
                  subtitle: Text(l["mob"]),
                  trailing: l["online"]
                      ? Text(
                          "online",
                          style: TextStyle(color: Colors.lightGreenAccent),
                        )
                      : Text(
                          "offline",
                          style: TextStyle(color: Colors.grey),
                        ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PersonalChatHome(l)),
                    );
                  },
                );
              }).toList(),
            );
          }),
    );
  }
}
