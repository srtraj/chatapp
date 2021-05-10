import 'package:chatapp/model/msgList.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'PersonalChatTypeWidget.dart';

// ignore: must_be_immutable
class PersonalChatList extends StatefulWidget {
  PersonalChatList(this.list, this.id);
  var list;
  String id;

  @override
  _PersonalChatListState createState() => _PersonalChatListState();
}

class _PersonalChatListState extends State<PersonalChatList> {
  TextEditingController cntMsg = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final wt = MediaQuery.of(context).size.width / 100;
    final ht = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(ht * 7),
        child: AppBar(
          leading: InkWell(
            onTap: () =>
                Navigator.of(context, rootNavigator: true).pop(context),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back,
                  size: wt * 6,
                ),
                CircleAvatar(
                  radius: ht * 2,
                  backgroundImage: AssetImage(widget.list["image"]),
                ),
              ],
            ),
          ),
          leadingWidth: wt * 18,
          title: Text(widget.list["name"]),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildListView(wt, ht)),
          PersonalChatTypeWidet(widget.id)
        ],
      ),
    );
  }

  _buildListView(wt, ht) {
    // ignore: deprecated_member_use
    return WatchBoxBuilder(
      box: Hive.box(widget.id),
      builder: (context, msgListBox) {
        return ListView.builder(
          shrinkWrap: true,
          reverse: true,
          itemCount: msgListBox.length,
          itemBuilder: (context, index) {
            final msglist =
                msgListBox.getAt(msgListBox.length - 1 - index) as MsgList;

            return Container(
              padding: EdgeInsets.only(
                  left: msglist.rcvd ? wt * 2 : wt * 20,
                  right: msglist.rcvd ? wt * 20 : wt * 2,
                  top: ht,
                  bottom: ht),
              child: Align(
                alignment:
                    (msglist.rcvd ? Alignment.topLeft : Alignment.topRight),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: (msglist.rcvd
                        ? Colors.grey.shade200
                        : Colors.blue[200]),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Text(
                    msglist.msg,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
