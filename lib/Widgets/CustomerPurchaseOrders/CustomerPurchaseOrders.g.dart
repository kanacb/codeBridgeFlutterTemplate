// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CustomerPurchaseOrders.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerPurchaseOrdersAdapter
    extends TypeAdapter<CustomerPurchaseOrders> {
  @override
  final int typeId = 21;

  @override
  CustomerPurchaseOrders read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerPurchaseOrders(
      id: fields[0] as String?,
      quotation: fields[1] as String,
      purchaseOrderDate: fields[2] as DateTime,
      deliveryDate: fields[3] as DateTime,
      purchaseOrderId: fields[4] as String,
      createdBy: fields[5] as String,
      updatedBy: fields[6] as String,
      createdAt: fields[7] as DateTime?,
      updatedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerPurchaseOrders obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.quotation)
      ..writeByte(2)
      ..write(obj.purchaseOrderDate)
      ..writeByte(3)
      ..write(obj.deliveryDate)
      ..writeByte(4)
      ..write(obj.purchaseOrderId)
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
      other is CustomerPurchaseOrdersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
