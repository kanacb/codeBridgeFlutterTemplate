// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Inbox.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InboxAdapter extends TypeAdapter<Inbox> {
  @override
  final int typeId = 2;

  @override
  Inbox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Inbox(
      id: fields[0] as String,
      from: fields[1] as IdName?,
      toUser: fields[2] as IdName?,
      subject: fields[3] as String,
      content: fields[4] as String,
      service: fields[5] as String,
      read: fields[6] as bool,
      flagged: fields[7] as bool,
      sent: fields[8] as DateTime,
      createdBy: fields[9] as String,
      updatedBy: fields[10] as String,
      createdAt: fields[11] as DateTime,
      updatedAt: fields[12] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Inbox obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.from)
      ..writeByte(2)
      ..write(obj.toUser)
      ..writeByte(3)
      ..write(obj.subject)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.service)
      ..writeByte(6)
      ..write(obj.read)
      ..writeByte(7)
      ..write(obj.flagged)
      ..writeByte(8)
      ..write(obj.sent)
      ..writeByte(9)
      ..write(obj.createdBy)
      ..writeByte(10)
      ..write(obj.updatedBy)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InboxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
