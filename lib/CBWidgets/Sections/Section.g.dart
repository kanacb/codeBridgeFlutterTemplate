// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Section.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SectionAdapter extends TypeAdapter<Section> {
  @override
  final int typeId = 6;

  @override
  Section read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Section(
      id: fields[0] as String?,
      departmentId: fields[1] as Department?,
      name: fields[2] as String?,
      code: fields[3] as String?,
      isDefault: fields[4] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Section obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.departmentId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.code)
      ..writeByte(4)
      ..write(obj.isDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
