// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Audit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuditAdapter extends TypeAdapter<Audit> {
  @override
  final int typeId = 23;

  @override
  Audit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Audit(
      id: fields[0] as String?,
      serviceName: fields[1] as String?,
      action: fields[2] as String?,
      details: fields[3] as String?,
      method: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Audit obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.serviceName)
      ..writeByte(2)
      ..write(obj.action)
      ..writeByte(3)
      ..write(obj.details)
      ..writeByte(4)
      ..write(obj.method);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuditAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
