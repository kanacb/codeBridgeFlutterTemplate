// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserGuideStep.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserGuideStepAdapter extends TypeAdapter<UserGuideStep> {
  @override
  final int typeId = 21;

  @override
  UserGuideStep read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserGuideStep(
      id: fields[0] as String?,
      userGuideID: fields[1] as UserGuide?,
      Steps: fields[2] as String,
      Description: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserGuideStep obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userGuideID)
      ..writeByte(2)
      ..write(obj.Steps)
      ..writeByte(3)
      ..write(obj.Description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserGuideStepAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
