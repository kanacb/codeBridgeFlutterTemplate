// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Role.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoleAdapter extends TypeAdapter<Role> {
  @override
  final int typeId = 7;

  @override
  Role read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Role(
      id: fields[0] as String?,
      name: fields[1] as String?,
      description: fields[2] as String?,
      isDefault: fields[3] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Role obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.isDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
