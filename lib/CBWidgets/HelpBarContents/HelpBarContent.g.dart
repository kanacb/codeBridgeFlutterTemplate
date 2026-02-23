// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HelpBarContent.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HelpBarContentAdapter extends TypeAdapter<HelpBarContent> {
  @override
  final int typeId = 31;

  @override
  HelpBarContent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HelpBarContent(
      id: fields[0] as String?,
      serviceName: fields[1] as String?,
      content: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HelpBarContent obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.serviceName)
      ..writeByte(2)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HelpBarContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
