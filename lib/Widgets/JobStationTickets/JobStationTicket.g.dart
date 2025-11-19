// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'JobStationTicket.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobStationTicketAdapter extends TypeAdapter<JobStationTicket> {
  @override
  final int typeId = 18;

  @override
  JobStationTicket read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobStationTicket(
      id: fields[0] as String?,
      ticketId: fields[1] as String?,
      jobStationId: fields[2] as String?,
      supervisorId: fields[3] as IdName?,
      technicianId: fields[4] as IdName?,
      machineId: fields[5] as String?,
      machineService: fields[6] as String?,
      startTime: fields[7] as DateTime?,
      endTime: fields[8] as DateTime?,
      status: fields[9] as String?,
      visibility: fields[10] as String?,
      uploadOfPictureBeforeRepair: (fields[11] as List?)?.cast<String>(),
      uploadOfPictureAfterRepair: (fields[12] as List?)?.cast<String>(),
      incomingRemarks: fields[13] as String?,
      jobCarriedOut: fields[14] as String?,
      comments: fields[15] as String?,
      createdBy: fields[16] as IdName?,
      updatedBy: fields[17] as IdName?,
      createdAt: fields[18] as DateTime?,
      updatedAt: fields[19] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, JobStationTicket obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ticketId)
      ..writeByte(2)
      ..write(obj.jobStationId)
      ..writeByte(3)
      ..write(obj.supervisorId)
      ..writeByte(4)
      ..write(obj.technicianId)
      ..writeByte(5)
      ..write(obj.machineId)
      ..writeByte(6)
      ..write(obj.machineService)
      ..writeByte(7)
      ..write(obj.startTime)
      ..writeByte(8)
      ..write(obj.endTime)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.visibility)
      ..writeByte(11)
      ..write(obj.uploadOfPictureBeforeRepair)
      ..writeByte(12)
      ..write(obj.uploadOfPictureAfterRepair)
      ..writeByte(13)
      ..write(obj.incomingRemarks)
      ..writeByte(14)
      ..write(obj.jobCarriedOut)
      ..writeByte(15)
      ..write(obj.comments)
      ..writeByte(16)
      ..write(obj.createdBy)
      ..writeByte(17)
      ..write(obj.updatedBy)
      ..writeByte(18)
      ..write(obj.createdAt)
      ..writeByte(19)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobStationTicketAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
