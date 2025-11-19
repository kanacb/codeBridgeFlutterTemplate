// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'IncomingMachineChecklists.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IncomingMachineChecklistsAdapter
    extends TypeAdapter<IncomingMachineChecklists> {
  @override
  final int typeId = 15;

  @override
  IncomingMachineChecklists read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IncomingMachineChecklists(
      id: fields[0] as String?,
      name: fields[1] as String,
      optionsType: fields[2] as String,
      description: fields[7] as String?,
      createdBy: fields[3] as IdName?,
      updatedBy: fields[4] as IdName?,
      createdAt: fields[5] as DateTime?,
      updatedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, IncomingMachineChecklists obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.optionsType)
      ..writeByte(3)
      ..write(obj.createdBy)
      ..writeByte(4)
      ..write(obj.updatedBy)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncomingMachineChecklistsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
