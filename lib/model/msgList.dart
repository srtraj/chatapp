import 'package:hive/hive.dart';

part 'msgList.g.dart';

@HiveType(typeId: 0)
class MsgList {
  @HiveField(0)
  final String msg;
  @HiveField(1)
  final bool rcvd;
  @HiveField(2)
  final DateTime time;

  MsgList(this.msg, this.rcvd, this.time);
}
