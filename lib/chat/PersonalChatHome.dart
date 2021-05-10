import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'PersonalChatList.dart';

// ignore: must_be_immutable
class PersonalChatHome extends StatefulWidget {
  PersonalChatHome(this.list, {Key key}) : super(key: key);
  var list;

  @override
  _PersonalChatHomeState createState() => _PersonalChatHomeState();
}

class _PersonalChatHomeState extends State<PersonalChatHome> {
  String id;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = widget.list["mob"].toString().replaceAll(RegExp('[^+0-9]'), "");
  }

  @override
  Widget build(BuildContext context) {
    // print("current user:--------------->${FirebaseAuth.instance.currentUser}");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: Hive.openBox(id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Container();
            } else {
              return PersonalChatList(widget.list, id);
            }
          } else {
            return Scaffold();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    Hive.box(id).compact();
    Hive.close();
    super.dispose();
  }
}
