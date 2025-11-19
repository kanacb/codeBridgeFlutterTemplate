// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ExternalTickets.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExternalTicketsAdapter extends TypeAdapter<ExternalTickets> {
  @override
  final int typeId = 7;

  @override
  ExternalTickets read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExternalTickets(
      id: fields[0] as String?,
      machineId: fields[1] as String?,
      checklistResponse: (fields[2] as List?)?.cast<String>(),
      externalUser: fields[3] as IdName?,
      assignedSupervisor: fields[4] as IdName?,
      assignedTechnician: fields[5] as IdName?,
      status: fields[6] as String?,
      startTime: fields[7] as DateTime?,
      endTime: fields[8] as DateTime?,
      supervisorStartTime: fields[9] as DateTime?,
      supervisorEndTime: fields[10] as DateTime?,
      technicianStartTime: fields[11] as DateTime?,
      technicianEndTime: fields[12] as DateTime?,
      machineImage: (fields[13] as List?)?.cast<String>(),
      uploadOfPictureBeforeRepair: (fields[14] as List?)?.cast<String>(),
      uploadOfPictureAfterRepair: (fields[15] as List?)?.cast<String>(),
      openingRemarks: fields[16] as String?,
      closingRemarks: fields[17] as String?,
      createdBy: fields[18] as IdName?,
      updatedBy: fields[19] as IdName?,
      createdAt: fields[20] as DateTime?,
      updatedAt: fields[21] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ExternalTickets obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.machineId)
      ..writeByte(2)
      ..write(obj.checklistResponse)
      ..writeByte(3)
      ..write(obj.externalUser)
      ..writeByte(4)
      ..write(obj.assignedSupervisor)
      ..writeByte(5)
      ..write(obj.assignedTechnician)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.startTime)
      ..writeByte(8)
      ..write(obj.endTime)
      ..writeByte(9)
      ..write(obj.supervisorStartTime)
      ..writeByte(10)
      ..write(obj.supervisorEndTime)
      ..writeByte(11)
      ..write(obj.technicianStartTime)
      ..writeByte(12)
      ..write(obj.technicianEndTime)
      ..writeByte(13)
      ..write(obj.machineImage)
      ..writeByte(14)
      ..write(obj.uploadOfPictureBeforeRepair)
      ..writeByte(15)
      ..write(obj.uploadOfPictureAfterRepair)
      ..writeByte(16)
      ..write(obj.openingRemarks)
      ..writeByte(17)
      ..write(obj.closingRemarks)
      ..writeByte(18)
      ..write(obj.createdBy)
      ..writeByte(19)
      ..write(obj.updatedBy)
      ..writeByte(20)
      ..write(obj.createdAt)
      ..writeByte(21)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExternalTicketsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
