// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SalesOrderItems.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SalesOrderItemsAdapter extends TypeAdapter<SalesOrderItems> {
  @override
  final int typeId = 30;

  @override
  SalesOrderItems read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SalesOrderItems(
      id: fields[0] as String?,
      salesOrder: fields[1] as String,
      part: fields[2] as String,
      quantity: fields[3] as int,
      createdBy: fields[4] as String,
      updatedBy: fields[5] as String,
      createdAt: fields[6] as DateTime?,
      updatedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SalesOrderItems obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.salesOrder)
      ..writeByte(2)
      ..write(obj.part)
      ..writeByte(3)
      ..write(obj.quantity)
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
      other is SalesOrderItemsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
