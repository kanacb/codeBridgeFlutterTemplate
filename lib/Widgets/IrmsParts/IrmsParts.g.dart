// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'IrmsParts.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IrmsPartsAdapter extends TypeAdapter<IrmsParts> {
  @override
  final int typeId = 48;

  @override
  IrmsParts read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IrmsParts(
      id: fields[0] as String?,
      serialNo: fields[1] as String?,
      itemNo: fields[2] as String?,
      description: fields[3] as String?,
      createdBy: fields[4] as IdName?,
      updatedBy: fields[5] as IdName?,
      createdAt: fields[6] as DateTime?,
      updatedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, IrmsParts obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.serialNo)
      ..writeByte(2)
      ..write(obj.itemNo)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.createdBy)
      ..writeByte(5)
      ..write(obj.updatedBy)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IrmsPartsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
