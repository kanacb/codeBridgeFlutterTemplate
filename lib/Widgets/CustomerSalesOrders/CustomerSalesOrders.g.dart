// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CustomerSalesOrders.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerSalesOrdersAdapter extends TypeAdapter<CustomerSalesOrders> {
  @override
  final int typeId = 22;

  @override
  CustomerSalesOrders read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerSalesOrders(
      id: fields[0] as String?,
      company: fields[1] as String,
      salesOrderId: fields[2] as String,
      salesOrderDate: fields[3] as DateTime,
      createdBy: fields[4] as String,
      updatedBy: fields[5] as String,
      createdAt: fields[6] as DateTime?,
      updatedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerSalesOrders obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.company)
      ..writeByte(2)
      ..write(obj.salesOrderId)
      ..writeByte(3)
      ..write(obj.salesOrderDate)
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
      other is CustomerSalesOrdersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
