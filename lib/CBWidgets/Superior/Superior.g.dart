// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Superior.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SuperiorAdapter extends TypeAdapter<Superior> {
  @override
  final int typeId = 17;

  @override
  Superior read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Superior(
      id: fields[0] as String?,
      superior: fields[1] as Staffinfo?,
      subordinate: fields[2] as Staffinfo?,
    );
  }

  @override
  void write(BinaryWriter writer, Superior obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.superior)
      ..writeByte(2)
      ..write(obj.subordinate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuperiorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
