// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msgList.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MsgListAdapter extends TypeAdapter<MsgList> {
  @override
  final int typeId = 0;

  @override
  MsgList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MsgList(
      fields[0] as String,
      fields[1] as bool,
      fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MsgList obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.msg)
      ..writeByte(1)
      ..write(obj.rcvd)
      ..writeByte(2)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MsgListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
