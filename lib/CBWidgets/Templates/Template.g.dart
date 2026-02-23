// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Template.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TemplateAdapter extends TypeAdapter<Template> {
  @override
  final int typeId = 10;

  @override
  Template read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Template(
      id: fields[0] as String?,
      name: fields[1] as String?,
      subject: fields[2] as String?,
      body: fields[3] as String?,
      variables: fields[4] as String?,
      image: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Template obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.subject)
      ..writeByte(3)
      ..write(obj.body)
      ..writeByte(4)
      ..write(obj.variables)
      ..writeByte(5)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
