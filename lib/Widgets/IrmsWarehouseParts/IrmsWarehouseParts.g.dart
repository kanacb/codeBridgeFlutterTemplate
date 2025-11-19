// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'IrmsWarehouseParts.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IrmsWarehousePartsAdapter extends TypeAdapter<IrmsWarehouseParts> {
  @override
  final int typeId = 50;

  @override
  IrmsWarehouseParts read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IrmsWarehouseParts(
      id: fields[0] as String?,
      part: fields[1] as String?,
      warehouse: fields[2] as String?,
      quantity: fields[3] as int?,
      costAmount: fields[4] as int?,
      reorderingQuantity: fields[5] as int?,
      reorderingPoint: fields[6] as int?,
      createdBy: fields[7] as IdName?,
      updatedBy: fields[8] as IdName?,
      createdAt: fields[9] as DateTime?,
      updatedAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, IrmsWarehouseParts obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.part)
      ..writeByte(2)
      ..write(obj.warehouse)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.costAmount)
      ..writeByte(5)
      ..write(obj.reorderingQuantity)
      ..writeByte(6)
      ..write(obj.reorderingPoint)
      ..writeByte(7)
      ..write(obj.createdBy)
      ..writeByte(8)
      ..write(obj.updatedBy)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IrmsWarehousePartsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
