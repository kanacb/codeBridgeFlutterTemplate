// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MemTicket.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemTicketAdapter extends TypeAdapter<MemTicket> {
  @override
  final int typeId = 51;

  @override
  MemTicket read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemTicket(
      id: fields[0] as String?,
      machineId: fields[1] as String?,
      checklistResponse: (fields[2] as List?)?.cast<String>(),
      salesman: fields[3] as IdName?,
      assignedSupervisor: fields[4] as IdName?,
      assignedTechnician: fields[5] as IdName?,
      status: fields[6] as String?,
      startTime: fields[7] as DateTime?,
      endTime: fields[8] as DateTime?,
      supervisorStartTime: fields[9] as DateTime?,
      supervisorEndTime: fields[10] as DateTime?,
      technicianStartTime: fields[11] as DateTime?,
      technicianEndTime: fields[12] as DateTime?,
      usedParts: (fields[13] as List?)?.cast<UsedPart>(),
      salesmanComment: fields[14] as String?,
      technicianInitialComment: fields[15] as String?,
      technicianCloseComment: fields[16] as String?,
      openingRemarks: fields[17] as String?,
      closingRemarks: fields[18] as String?,
      machineImage: (fields[19] as List?)?.cast<String>(),
      uploadOfPictureBeforeRepair: (fields[20] as List?)?.cast<String>(),
      uploadOfPictureAfterRepair: (fields[21] as List?)?.cast<String>(),
      createdBy: fields[22] as IdName?,
      updatedBy: fields[23] as IdName?,
      createdAt: fields[24] as DateTime?,
      updatedAt: fields[25] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MemTicket obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.machineId)
      ..writeByte(2)
      ..write(obj.checklistResponse)
      ..writeByte(3)
      ..write(obj.salesman)
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
      ..write(obj.usedParts)
      ..writeByte(14)
      ..write(obj.salesmanComment)
      ..writeByte(15)
      ..write(obj.technicianInitialComment)
      ..writeByte(16)
      ..write(obj.technicianCloseComment)
      ..writeByte(17)
      ..write(obj.openingRemarks)
      ..writeByte(18)
      ..write(obj.closingRemarks)
      ..writeByte(19)
      ..write(obj.machineImage)
      ..writeByte(20)
      ..write(obj.uploadOfPictureBeforeRepair)
      ..writeByte(21)
      ..write(obj.uploadOfPictureAfterRepair)
      ..writeByte(22)
      ..write(obj.createdBy)
      ..writeByte(23)
      ..write(obj.updatedBy)
      ..writeByte(24)
      ..write(obj.createdAt)
      ..writeByte(25)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemTicketAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
