// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'irmsDeliveryOrders.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class irmsDeliveryOrdersAdapter extends TypeAdapter<irmsDeliveryOrders> {
  @override
  final int typeId = 25;

  @override
  irmsDeliveryOrders read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return irmsDeliveryOrders(
      id: fields[0] as String?,
      purchaseOrder: fields[1] as String,
      deliveryOrderId: fields[2] as String,
      createdBy: fields[3] as String,
      updatedBy: fields[4] as String,
      createdAt: fields[5] as DateTime?,
      updatedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, irmsDeliveryOrders obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.purchaseOrder)
      ..writeByte(2)
      ..write(obj.deliveryOrderId)
      ..writeByte(3)
      ..write(obj.createdBy)
      ..writeByte(4)
      ..write(obj.updatedBy)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is irmsDeliveryOrdersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
