// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'IncomingMachineTicket.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IncomingMachineTicketAdapter extends TypeAdapter<IncomingMachineTicket> {
  @override
  final int typeId = 9;

  @override
  IncomingMachineTicket read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IncomingMachineTicket(
      id: fields[0] as String?,
      machineId: fields[1] as String?,
      machineService: fields[15] as String?,
      incomingMachineChecker: fields[2] as IdName?,
      assignedSupervisor: fields[3] as IdName?,
      selectedJobStations: (fields[4] as List?)?.cast<JobStation>(),
      startTime: fields[5] as DateTime?,
      endTime: fields[6] as DateTime?,
      vendingControllerChecklistResponse:
          (fields[7] as List?)?.cast<ChecklistResponse>(),
      status: fields[8] as String?,
      selectedJobStationIndex: fields[9] as int?,
      machineImage: (fields[10] as List?)?.cast<String>(),
      comments: fields[16] as String?,
      createdBy: fields[11] as IdName?,
      updatedBy: fields[12] as IdName?,
      createdAt: fields[13] as DateTime?,
      updatedAt: fields[14] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, IncomingMachineTicket obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.machineId)
      ..writeByte(2)
      ..write(obj.incomingMachineChecker)
      ..writeByte(3)
      ..write(obj.assignedSupervisor)
      ..writeByte(4)
      ..write(obj.selectedJobStations)
      ..writeByte(5)
      ..write(obj.startTime)
      ..writeByte(6)
      ..write(obj.endTime)
      ..writeByte(7)
      ..write(obj.vendingControllerChecklistResponse)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.selectedJobStationIndex)
      ..writeByte(10)
      ..write(obj.machineImage)
      ..writeByte(11)
      ..write(obj.createdBy)
      ..writeByte(12)
      ..write(obj.updatedBy)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt)
      ..writeByte(15)
      ..write(obj.machineService)
      ..writeByte(16)
      ..write(obj.comments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncomingMachineTicketAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
