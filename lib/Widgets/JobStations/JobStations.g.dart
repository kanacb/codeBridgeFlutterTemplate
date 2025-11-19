// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'JobStations.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobStationsAdapter extends TypeAdapter<JobStations> {
  @override
  final int typeId = 17;

  @override
  JobStations read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobStations(
      id: fields[0] as String?,
      name: fields[1] as String,
      description: fields[2] as String,
      createdBy: fields[3] as IdName?,
      updatedBy: fields[4] as IdName?,
      createdAt: fields[5] as DateTime?,
      updatedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, JobStations obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.createdBy)
      ..writeByte(4)
      ..write(obj.updatedBy)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobStationsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
