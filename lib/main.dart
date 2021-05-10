import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'chat/chatListPage.dart';
import 'dart:async';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'firebaseMessage/messaging.dart';
import 'login/mobileVerificationPage.dart';
import 'model/msgList.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(MsgListAdapter());
  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  runApp(
    //     DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => MyApp(),
    // )
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // print("current user:--------------->${FirebaseAuth.instance.currentUser}");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme:
      //     ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
      darkTheme: ThemeData(
          brightness: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
              .platformBrightness),
      home: FirebaseAuth.instance.currentUser != null
          ? ChatListPage()
          : MobileVerPage(),
    );
  }
}

Future<void> _backgroundHandler(RemoteMessage remoteMessage) async {
  await Firebase.initializeApp();
  print(
      " ${remoteMessage.notification.title}, ${remoteMessage.notification.body}");
  print('Handle Background service');
  Messaging().updateHivebasedNotification(
      remoteMessage.notification.title, remoteMessage.notification.body);
  // FirebaseNotifications.showNotification(
  //     message.notification.title, message.notification.body);
}
