// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'JobStationQueue.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobStationQueueAdapter extends TypeAdapter<JobStationQueue> {
  @override
  final int typeId = 46;

  @override
  JobStationQueue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobStationQueue(
      id: fields[0] as String?,
      ticketId: fields[1] as String?,
      machineId: fields[2] as String?,
      machineService: fields[3] as String?,
      jobStations: (fields[4] as List?)?.cast<JobStationInsideQueue>(),
      priority: fields[5] as int?,
      errorMessage: fields[6] as String?,
      startTime: fields[7] as DateTime?,
      endTime: fields[8] as DateTime?,
      selectedUser: fields[9] as IdName?,
      createdAt: fields[10] as DateTime?,
      updatedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, JobStationQueue obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ticketId)
      ..writeByte(2)
      ..write(obj.machineId)
      ..writeByte(3)
      ..write(obj.machineService)
      ..writeByte(4)
      ..write(obj.jobStations)
      ..writeByte(5)
      ..write(obj.priority)
      ..writeByte(6)
      ..write(obj.errorMessage)
      ..writeByte(7)
      ..write(obj.startTime)
      ..writeByte(8)
      ..write(obj.endTime)
      ..writeByte(9)
      ..write(obj.selectedUser)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobStationQueueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
