// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Position.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PositionAdapter extends TypeAdapter<Position> {
  @override
  final int typeId = 8;

  @override
  Position read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Position(
      id: fields[0] as String?,
      roleId: fields[1] as Role?,
      name: fields[2] as String?,
      description: fields[3] as String?,
      abbr: fields[4] as String?,
      isDefault: fields[5] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Position obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.roleId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.abbr)
      ..writeByte(5)
      ..write(obj.isDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PositionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
