// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserChangePassword.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserChangePasswordAdapter extends TypeAdapter<UserChangePassword> {
  @override
  final int typeId = 37;

  @override
  UserChangePassword read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserChangePassword(
      id: fields[0] as String?,
      userEmail: fields[1] as String,
      server: fields[2] as String,
      environment: fields[3] as String?,
      code: fields[4] as String,
      status: fields[5] as bool?,
      sendEmailCounter: fields[6] as int?,
      lastAttempt: fields[7] as DateTime?,
      ipAddress: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserChangePassword obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userEmail)
      ..writeByte(2)
      ..write(obj.server)
      ..writeByte(3)
      ..write(obj.environment)
      ..writeByte(4)
      ..write(obj.code)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.sendEmailCounter)
      ..writeByte(7)
      ..write(obj.lastAttempt)
      ..writeByte(8)
      ..write(obj.ipAddress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserChangePasswordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
