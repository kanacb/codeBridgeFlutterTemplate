// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Branches.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BranchesAdapter extends TypeAdapter<Branches> {
  @override
  final int typeId = 37;

  @override
  Branches read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Branches(
      id: fields[0] as String,
      companyId: fields[1] as IdName,
      name: fields[2] as String,
      isDefault: fields[3] as bool,
      createdBy: fields[4] as String?,
      updatedBy: fields[5] as String?,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Branches obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.companyId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.isDefault)
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
      other is BranchesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
