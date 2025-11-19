// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PartsMaster.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PartsMasterAdapter extends TypeAdapter<PartsMaster> {
  @override
  final int typeId = 20;

  @override
  PartsMaster read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PartsMaster(
      itemNo: fields[0] as String?,
      description: fields[1] as String?,
      quantity: fields[2] as int?,
      costAmount: fields[3] as double?,
      createdBy: fields[4] as String?,
      updatedBy: fields[5] as String?,
      createdAt: fields[6] as DateTime?,
      updatedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PartsMaster obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.itemNo)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.costAmount)
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
      other is PartsMasterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
