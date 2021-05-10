import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'messaging.dart';
import 'notification_handler.dart';

class FirebaseNotifications {
  var firebase = FirebaseFirestore.instance.collection("data");
  FirebaseMessaging _messaging;
  BuildContext myContext;

  void setupFirebase(BuildContext context) {
    _messaging = FirebaseMessaging.instance;
    NotificationHandler.initNotification(context);
    firebaseCloudMessageListener(context);
    myContext = context;
  }

  void firebaseCloudMessageListener(BuildContext context) async {
    NotificationSettings setting = await _messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    print('Setting${setting.authorizationStatus}');

    _messaging.onTokenRefresh.listen(sendTokentoserver);

    _messaging.getToken().then((token) => {
          print('mytoken: $token'),
          firebase
              .doc(FirebaseAuth.instance.currentUser.phoneNumber)
              .update({"FcmToken": token}),
        });
    _messaging
        .subscribeToTopic("chatapp_demo")
        .whenComplete(() => print('Subscribe ok'));

    FirebaseMessaging.onMessage.listen((remoteMessage) {
      Messaging().updateHivebasedNotification(
          remoteMessage.notification.title, remoteMessage.notification.body);
      // print(
      //     " ${remoteMessage.data['MsgAddress']}, ${remoteMessage.notification.body}");
      if (Platform.isAndroid)
        showNotification(
            remoteMessage.notification.title, remoteMessage.notification.body);
      else if (Platform.isIOS)
        showNotification(
            remoteMessage.notification.title, remoteMessage.notification.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      if (Platform.isIOS) {
        showDialog(
            context: myContext,
            builder: (context) => AlertDialog(
                  title: Text(remoteMessage.notification.title),
                  content: Text(remoteMessage.notification.body),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: Text("ok"),
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                    )
                  ],
                ));
      }
    });
  }

  static void showNotification(title, body) async {
    var androidChannel = AndroidNotificationDetails(
        "com.stj.chatapp", "my Channel", "Description",
        autoCancel: true,
        ongoing: true,
        importance: Importance.max,
        priority: Priority.high);
    var ios = IOSNotificationDetails();
    var platForm = NotificationDetails(android: androidChannel, iOS: ios);
    await NotificationHandler.flutterLocalNotificationsPlugin.show(
        Random().nextInt(1000), title, body, platForm,
        payload: 'My Payload');
  }

  void sendTokentoserver(String fcmToken) {
    print('Token :$fcmToken');
    FirebaseFirestore.instance
        .collection("data")
        .doc("+918157898849")
        .set({'topic': fcmToken});
  }
}
