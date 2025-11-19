// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AtlasTicket.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AtlasTicketAdapter extends TypeAdapter<AtlasTicket> {
  @override
  final int typeId = 8;

  @override
  AtlasTicket read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AtlasTicket(
      id: fields[0] as String?,
      checklistResponse: (fields[1] as List?)?.cast<String>(),
      assignedSupervisor: fields[3] as IdName?,
      assignedTechnician: fields[4] as IdName?,
      vendingController: fields[2] as IdName?,
      status: fields[5] as String?,
      startTime: fields[6] as DateTime?,
      endTime: fields[7] as DateTime?,
      machineId: fields[8] as String?,
      supervisorEndTime: fields[10] as DateTime?,
      supervisorStartTime: fields[9] as DateTime?,
      technicianStartTime: fields[11] as DateTime?,
      technicianEndTime: fields[12] as DateTime?,
      machineImage: (fields[15] as List?)?.cast<String>(),
      comments: fields[13] as String?,
      technicianComments: fields[14] as String?,
      uploadOfPictureAfterRepair: (fields[17] as List?)?.cast<String>(),
      uploadOfPictureBeforeRepair: (fields[16] as List?)?.cast<String>(),
      createdBy: fields[18] as IdName?,
      updatedBy: fields[19] as IdName?,
      createdAt: fields[20] as DateTime,
      updatedAt: fields[21] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AtlasTicket obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.checklistResponse)
      ..writeByte(2)
      ..write(obj.vendingController)
      ..writeByte(3)
      ..write(obj.assignedSupervisor)
      ..writeByte(4)
      ..write(obj.assignedTechnician)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.startTime)
      ..writeByte(7)
      ..write(obj.endTime)
      ..writeByte(8)
      ..write(obj.machineId)
      ..writeByte(9)
      ..write(obj.supervisorStartTime)
      ..writeByte(10)
      ..write(obj.supervisorEndTime)
      ..writeByte(11)
      ..write(obj.technicianStartTime)
      ..writeByte(12)
      ..write(obj.technicianEndTime)
      ..writeByte(13)
      ..write(obj.comments)
      ..writeByte(14)
      ..write(obj.technicianComments)
      ..writeByte(15)
      ..write(obj.machineImage)
      ..writeByte(16)
      ..write(obj.uploadOfPictureBeforeRepair)
      ..writeByte(17)
      ..write(obj.uploadOfPictureAfterRepair)
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
      other is AtlasTicketAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
