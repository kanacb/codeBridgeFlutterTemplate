// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LoginHistory.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoginHistoryAdapter extends TypeAdapter<LoginHistory> {
  @override
  final int typeId = 32;

  @override
  LoginHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginHistory(
      id: fields[0] as String?,
      userId: fields[1] as User?,
      device: fields[2] as String?,
      browser: fields[3] as String?,
      userAgent: fields[4] as String?,
      loginTime: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, LoginHistory obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.device)
      ..writeByte(3)
      ..write(obj.browser)
      ..writeByte(4)
      ..write(obj.userAgent)
      ..writeByte(5)
      ..write(obj.loginTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
