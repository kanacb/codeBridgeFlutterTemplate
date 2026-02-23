// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserPhone.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPhoneAdapter extends TypeAdapter<UserPhone> {
  @override
  final int typeId = 14;

  @override
  UserPhone read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPhone(
      id: fields[0] as String?,
      userId: fields[1] as User?,
      countryCode: fields[2] as int?,
      operatorCode: fields[3] as int?,
      number: fields[4] as int?,
      type: fields[5] as String?,
      isDefault: fields[6] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, UserPhone obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.countryCode)
      ..writeByte(3)
      ..write(obj.operatorCode)
      ..writeByte(4)
      ..write(obj.number)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.isDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPhoneAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
