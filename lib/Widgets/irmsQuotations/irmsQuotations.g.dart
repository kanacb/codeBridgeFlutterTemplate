// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'irmsQuotations.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class irmsQuotationsAdapter extends TypeAdapter<irmsQuotations> {
  @override
  final int typeId = 26;

  @override
  irmsQuotations read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return irmsQuotations(
      id: fields[0] as String?,
      salesOrder: fields[1] as String,
      validDate: fields[2] as DateTime?,
      quotationIndex: fields[3] as String,
      createdBy: fields[4] as String,
      updatedBy: fields[5] as String,
      createdAt: fields[6] as DateTime?,
      updatedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, irmsQuotations obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.salesOrder)
      ..writeByte(2)
      ..write(obj.validDate)
      ..writeByte(3)
      ..write(obj.quotationIndex)
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
      other is irmsQuotationsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
