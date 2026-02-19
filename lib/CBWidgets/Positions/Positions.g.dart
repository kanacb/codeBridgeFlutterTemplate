// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Positions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PositionsAdapter extends TypeAdapter<Positions> {
  @override
  final int typeId = 56;

  @override
  Positions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Positions(
      id: fields[0] as String?,
      roleId: fields[1] as IdName?,
      name: fields[2] as String?,
      description: fields[3] as String?,
      abbr: fields[4] as String?,
      isDefault: fields[5] as bool?,
      createdBy: fields[6] as IdName?,
      updatedBy: fields[7] as IdName?,
      createdAt: fields[8] as DateTime?,
      updatedAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Positions obj) {
    writer
      ..writeByte(10)
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
      ..write(obj.isDefault)
      ..writeByte(6)
      ..write(obj.createdBy)
      ..writeByte(7)
      ..write(obj.updatedBy)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PositionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
