// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PurchaseOrderItems.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PurchaseOrderItemsAdapter extends TypeAdapter<PurchaseOrderItems> {
  @override
  final int typeId = 28;

  @override
  PurchaseOrderItems read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PurchaseOrderItems(
      id: fields[0] as String?,
      purchaseOrder: fields[1] as String,
      part: fields[2] as String,
      quantity: fields[3] as int,
      unitPrice: fields[4] as double,
      createdBy: fields[5] as String,
      updatedBy: fields[6] as String,
      createdAt: fields[7] as DateTime?,
      updatedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PurchaseOrderItems obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.purchaseOrder)
      ..writeByte(2)
      ..write(obj.part)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.unitPrice)
      ..writeByte(5)
      ..write(obj.createdBy)
      ..writeByte(6)
      ..write(obj.updatedBy)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchaseOrderItemsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
