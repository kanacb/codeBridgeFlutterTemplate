// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MemParts.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemPartsAdapter extends TypeAdapter<MemParts> {
  @override
  final int typeId = 53;

  @override
  MemParts read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemParts(
      id: fields[0] as String?,
      item: fields[1] as String?,
      machineType: (fields[2] as List?)?.cast<String>(),
      createdBy: fields[3] as IdName?,
      updatedBy: fields[4] as IdName?,
      createdAt: fields[5] as DateTime?,
      updatedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MemParts obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.item)
      ..writeByte(2)
      ..write(obj.machineType)
      ..writeByte(3)
      ..write(obj.createdBy)
      ..writeByte(4)
      ..write(obj.updatedBy)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemPartsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
