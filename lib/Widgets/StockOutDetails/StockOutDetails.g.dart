// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StockOutDetails.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockOutDetailsAdapter extends TypeAdapter<StockOutDetails> {
  @override
  final int typeId = 33;

  @override
  StockOutDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockOutDetails(
      id: fields[0] as String,
      partName: fields[1] as String?,
      stockOutType: fields[2] as String?,
      associatedOrderNumber: fields[3] as String?,
      conditionOfItems: fields[4] as String?,
      createdBy: fields[5] as String?,
      updatedBy: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StockOutDetails obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.partName)
      ..writeByte(2)
      ..write(obj.stockOutType)
      ..writeByte(3)
      ..write(obj.associatedOrderNumber)
      ..writeByte(4)
      ..write(obj.conditionOfItems)
      ..writeByte(5)
      ..write(obj.createdBy)
      ..writeByte(6)
      ..write(obj.updatedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockOutDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
