// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'IdName.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IdNameAdapter extends TypeAdapter<IdName> {
  @override
  final int typeId = 19;

  @override
  IdName read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IdName(
      sId: fields[0] as String?,
      name: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, IdName obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.sId)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdNameAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
