// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AtlasChecklists.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AtlasChecklistsAdapter extends TypeAdapter<AtlasChecklists> {
  @override
  final int typeId = 13;

  @override
  AtlasChecklists read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AtlasChecklists(
      id: fields[0] as String?,
      vendingMachineId: fields[1] as String?,
      name: fields[2] as String,
      description: fields[3] as String?,
      createdBy: fields[4] as String,
      updatedBy: fields[5] as String,
      createdAt: fields[6] as DateTime?,
      updatedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AtlasChecklists obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.vendingMachineId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.createdBy)
      ..writeByte(5)
      ..write(obj.updatedBy)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AtlasChecklistsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
