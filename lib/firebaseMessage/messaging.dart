import 'dart:convert';
import 'package:chatapp/model/msgList.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:hive/hive.dart';

class Messaging {
  static final Client client = Client();

  static const String serverKey =
      'AAAAFvCK8Ac:APA91bGj9GJbqKnOuf35uMOHRDgzWkpzaVrZcE0Q7groCB6-V6WN3iqNqsETLL6_Pzbn1MsOt0C_YKH0dZjTqy8mJ-ya1fPKVzGW65sJfDZ9RdxpE8TTqm46amIWX4NCFVuJAc28L2bC';

  static Future<Response> sendToAll({
    @required String title,
    @required String body,
    @required String topic,
  }) =>
      sendToTopic(title: title, body: body, topic: topic);

  static Future<Response> sendToTopic(
          {@required String title,
          @required String body,
          @required String topic}) =>
      sendTo(title: title, body: body, fcmToken: topic);

  static Future<Response> sendTo({
    @required String title,
    @required String body,
    @required String fcmToken,
  }) =>
      client.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: json.encode({
          'notification': {'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': '$fcmToken',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );

  updateHivebasedNotification(id, msg) async {
    await Hive.openBox(id);
    MsgList msglist = MsgList(msg, true, DateTime.now());
    final contactsBox = Hive.box(id);
    await contactsBox.add(msglist);
  }
}
