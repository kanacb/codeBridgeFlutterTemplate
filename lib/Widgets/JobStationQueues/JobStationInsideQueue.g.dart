// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'JobStationInsideQueue.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobStationInsideQueueAdapter extends TypeAdapter<JobStationInsideQueue> {
  @override
  final int typeId = 47;

  @override
  JobStationInsideQueue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobStationInsideQueue(
      id: fields[0] as String?,
      underscoreId: fields[1] as String?,
      name: fields[2] as String?,
      description: fields[3] as String?,
      technicianId: fields[4] as IdName?,
    );
  }

  @override
  void write(BinaryWriter writer, JobStationInsideQueue obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.underscoreId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.technicianId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobStationInsideQueueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
