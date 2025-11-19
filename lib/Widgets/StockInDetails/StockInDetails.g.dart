// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StockInDetails.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockInDetailsAdapter extends TypeAdapter<StockInDetails> {
  @override
  final int typeId = 32;

  @override
  StockInDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockInDetails(
      id: fields[0] as String,
      model: fields[1] as String?,
      serialNo: fields[2] as String?,
      partNo: fields[3] as String?,
      pricing: fields[4] as double?,
      quantity: fields[5] as int?,
      purchaseDate: fields[6] as DateTime?,
      partDescription: fields[7] as String?,
      poNumber: fields[8] as String?,
      doNumber: fields[9] as String?,
      category: fields[10] as String?,
      unitOfMeasurement: fields[11] as String?,
      conditionOfTerms: fields[12] as String?,
      warehouse: fields[13] as String?,
      createdBy: fields[14] as String?,
      updatedBy: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StockInDetails obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.model)
      ..writeByte(2)
      ..write(obj.serialNo)
      ..writeByte(3)
      ..write(obj.partNo)
      ..writeByte(4)
      ..write(obj.pricing)
      ..writeByte(5)
      ..write(obj.quantity)
      ..writeByte(6)
      ..write(obj.purchaseDate)
      ..writeByte(7)
      ..write(obj.partDescription)
      ..writeByte(8)
      ..write(obj.poNumber)
      ..writeByte(9)
      ..write(obj.doNumber)
      ..writeByte(10)
      ..write(obj.category)
      ..writeByte(11)
      ..write(obj.unitOfMeasurement)
      ..writeByte(12)
      ..write(obj.conditionOfTerms)
      ..writeByte(13)
      ..write(obj.warehouse)
      ..writeByte(14)
      ..write(obj.createdBy)
      ..writeByte(15)
      ..write(obj.updatedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockInDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
