// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PartRequestDetails.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PartRequestDetailsAdapter extends TypeAdapter<PartRequestDetails> {
  @override
  final int typeId = 27;

  @override
  PartRequestDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PartRequestDetails(
      id: fields[0] as String?,
      partName: fields[1] as String?,
      quantity: fields[2] as int?,
      status: fields[3] as String?,
      comment: fields[4] as String?,
      requestedDate: fields[5] as DateTime?,
      jobId: fields[6] as String?,
      technician: fields[7] as IdName?,
      isUsed: fields[8] as bool?,
      approvedDate: fields[9] as DateTime?,
      approvedBy: fields[10] as IdName?,
      warehouse: fields[11] as String?,
      createdBy: fields[12] as IdName?,
      updatedBy: fields[13] as IdName?,
      createdAt: fields[14] as DateTime?,
      updatedAt: fields[15] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PartRequestDetails obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.partName)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.comment)
      ..writeByte(5)
      ..write(obj.requestedDate)
      ..writeByte(6)
      ..write(obj.jobId)
      ..writeByte(7)
      ..write(obj.technician)
      ..writeByte(8)
      ..write(obj.isUsed)
      ..writeByte(9)
      ..write(obj.approvedDate)
      ..writeByte(10)
      ..write(obj.approvedBy)
      ..writeByte(11)
      ..write(obj.warehouse)
      ..writeByte(12)
      ..write(obj.createdBy)
      ..writeByte(13)
      ..write(obj.updatedBy)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartRequestDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
