// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Branch.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BranchAdapter extends TypeAdapter<Branch> {
  @override
  final int typeId = 4;

  @override
  Branch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Branch(
      id: fields[0] as String?,
      companyId: fields[1] as Company,
      name: fields[2] as String,
      isDefault: fields[3] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Branch obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.companyId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.isDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BranchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
