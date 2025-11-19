// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MemChecks.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemChecksAdapter extends TypeAdapter<MemChecks> {
  @override
  final int typeId = 55;

  @override
  MemChecks read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemChecks(
      id: fields[0] as String?,
      memCheckListId: fields[1] as String?,
      name: fields[2] as String,
      description: fields[3] as String?,
      createdBy: fields[4] as IdName?,
      updatedBy: fields[5] as IdName?,
      createdAt: fields[6] as DateTime?,
      updatedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MemChecks obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.memCheckListId)
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
      other is MemChecksAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
