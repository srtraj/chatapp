import 'package:chatapp/firebaseMessage/firebase_notification_handler.dart';
import 'package:flutter/material.dart';

import 'messaging.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseNotifications firebaseNotification = new FirebaseNotifications();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      firebaseNotification.setupFirebase(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //FirebaseMessaging.instance.deleteToken();
            sendNotification("TestApp", "hi hellkow how are you?",
                "eaa0Pc3PQJWRxopO5FbOZ-:APA91bHTMx5ostMOUv2vM-IWWLFZBcaa1dKtEVw6Ks7YxWU0ft8nLJRB9C9UGpoaubWVyXfjhgIWAe7zyswXZmIp7ENNBSFro3PpAUBmsaM3FHrmyd4m4Ogegt40u6Eqgz-QDioL1DbM");
          },
        ),
        body: Center(
          child: Text('Firebase messaging cloud'),
        ));
  }

  Future sendNotification(title, body, token) async {
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
}
