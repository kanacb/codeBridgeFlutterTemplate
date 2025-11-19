// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SampleDetails.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SampleDetailsAdapter extends TypeAdapter<SampleDetails> {
  @override
  final int typeId = 31;

  @override
  SampleDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SampleDetails(
      id: fields[0] as String,
      sourceWarehouse: fields[1] as String?,
      partNumber: fields[2] as String?,
      quantity: fields[3] as int?,
      associatedNumber: fields[4] as String?,
      affectiveDate: fields[5] as DateTime?,
      createdBy: fields[6] as String?,
      updatedBy: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SampleDetails obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sourceWarehouse)
      ..writeByte(2)
      ..write(obj.partNumber)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.associatedNumber)
      ..writeByte(5)
      ..write(obj.affectiveDate)
      ..writeByte(6)
      ..write(obj.createdBy)
      ..writeByte(7)
      ..write(obj.updatedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SampleDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
