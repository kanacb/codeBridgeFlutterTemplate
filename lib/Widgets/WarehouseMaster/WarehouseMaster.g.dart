// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WarehouseMaster.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WarehouseMasterAdapter extends TypeAdapter<WarehouseMaster> {
  @override
  final int typeId = 35;

  @override
  WarehouseMaster read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WarehouseMaster(
      id: fields[0] as String,
      name: fields[1] as String?,
      location: fields[2] as String?,
      createdBy: fields[3] as String?,
      updatedBy: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WarehouseMaster obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.createdBy)
      ..writeByte(4)
      ..write(obj.updatedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WarehouseMasterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
