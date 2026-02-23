// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserInvite.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserInviteAdapter extends TypeAdapter<UserInvite> {
  @override
  final int typeId = 38;

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
      position: fields[3] as Position?,
      role: fields[4] as Role?,
      company: fields[5] as Company?,
      branch: fields[6] as Branch?,
      department: fields[7] as Department?,
      section: fields[8] as Section?,
      code: fields[9] as int?,
      sendMailCounter: fields[10] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UserInvite obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.emailToInvite)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.position)
      ..writeByte(4)
      ..write(obj.role)
      ..writeByte(5)
      ..write(obj.company)
      ..writeByte(6)
      ..write(obj.branch)
      ..writeByte(7)
      ..write(obj.department)
      ..writeByte(8)
      ..write(obj.section)
      ..writeByte(9)
      ..write(obj.code)
      ..writeByte(10)
      ..write(obj.sendMailCounter);
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
