// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DisposalDetails.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DisposalDetailsAdapter extends TypeAdapter<DisposalDetails> {
  @override
  final int typeId = 24;

  @override
  DisposalDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DisposalDetails(
      id: fields[0] as String?,
      sourceWarehouse: fields[1] as String,
      partNumber: fields[2] as String,
      quantity: fields[3] as int,
      associatedNumber: fields[4] as String,
      affectiveDate: fields[5] as DateTime?,
      createdBy: fields[6] as String,
      updatedBy: fields[7] as String,
      createdAt: fields[8] as DateTime?,
      updatedAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DisposalDetails obj) {
    writer
      ..writeByte(10)
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
      ..write(obj.updatedBy)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DisposalDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
