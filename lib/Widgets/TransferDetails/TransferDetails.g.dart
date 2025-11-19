// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TransferDetails.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransferDetailsAdapter extends TypeAdapter<TransferDetails> {
  @override
  final int typeId = 34;

  @override
  TransferDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransferDetails(
      id: fields[0] as String,
      sourceWarehouse: fields[1] as String?,
      destinationWarehouse: fields[2] as String?,
      partNumber: fields[3] as String?,
      quantity: fields[4] as int?,
      transferDate: fields[5] as DateTime?,
      transferStatus: fields[6] as String?,
      createdBy: fields[7] as String?,
      updatedBy: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TransferDetails obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sourceWarehouse)
      ..writeByte(2)
      ..write(obj.destinationWarehouse)
      ..writeByte(3)
      ..write(obj.partNumber)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.transferDate)
      ..writeByte(6)
      ..write(obj.transferStatus)
      ..writeByte(7)
      ..write(obj.createdBy)
      ..writeByte(8)
      ..write(obj.updatedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransferDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
