// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserGuide.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserGuideAdapter extends TypeAdapter<UserGuide> {
  @override
  final int typeId = 22;

  @override
  UserGuide read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserGuide(
      id: fields[0] as String?,
      serviceName: fields[1] as String,
      expiry: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserGuide obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.serviceName)
      ..writeByte(2)
      ..write(obj.expiry);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserGuideAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
