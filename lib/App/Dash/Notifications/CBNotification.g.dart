// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CBNotification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CBNotificationAdapter extends TypeAdapter<CBNotification> {
  @override
  final int typeId = 5;

  @override
  CBNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CBNotification(
      id: fields[0] as String?,
      toUser: fields[1] as IdName?,
      content: fields[2] as String?,
      path: fields[3] as String?,
      method: fields[4] as String?,
      data: fields[5] as String?,
      recordId: fields[6] as String?,
      read: fields[7] as bool?,
      sent: fields[8] as DateTime?,
      createdBy: fields[9] as IdName?,
      updatedBy: fields[10] as IdName?,
      createdAt: fields[11] as DateTime?,
      updatedAt: fields[12] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CBNotification obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.toUser)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.path)
      ..writeByte(4)
      ..write(obj.method)
      ..writeByte(5)
      ..write(obj.data)
      ..writeByte(6)
      ..write(obj.recordId)
      ..writeByte(7)
      ..write(obj.read)
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
      other is CBNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
