// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'QuotationItems.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuotationItemsAdapter extends TypeAdapter<QuotationItems> {
  @override
  final int typeId = 29;

  @override
  QuotationItems read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuotationItems(
      id: fields[0] as String?,
      quotation: fields[1] as String,
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
  void write(BinaryWriter writer, QuotationItems obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.quotation)
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
      other is QuotationItemsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
