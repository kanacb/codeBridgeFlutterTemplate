// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'JobStation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobStationAdapter extends TypeAdapter<JobStation> {
  @override
  final int typeId = 41;

  @override
  JobStation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobStation(
      name: fields[0] as String?,
      technicianId: fields[1] as IdName?,
    );
  }

  @override
  void write(BinaryWriter writer, JobStation obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.technicianId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobStationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
