// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserInvite.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserInviteAdapter extends TypeAdapter<UserInvite> {
  @override
  final int typeId = 4;

  @override
  UserInvite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserInvite(
      id: fields[0] as String?,
      emailToInvite: fields[1] as String,
      status: fields[2] as bool?,
      code: fields[3] as int?,
      position: fields[4] as String?,
      role: fields[5] as String?,
      sendMailCounter: fields[6] as int?,
      createdAt: fields[7] as DateTime?,
      updatedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserInvite obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.emailToInvite)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.code)
      ..writeByte(4)
      ..write(obj.position)
      ..writeByte(5)
      ..write(obj.role)
      ..writeByte(6)
      ..write(obj.sendMailCounter)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInviteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
