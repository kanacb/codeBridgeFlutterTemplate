// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PermissionField.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PermissionFieldAdapter extends TypeAdapter<PermissionField> {
  @override
  final int typeId = 41;

  @override
  PermissionField read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PermissionField(
      id: fields[0] as String?,
      servicePermissionId: fields[1] as PermissionService?,
      fieldName: fields[2] as String?,
      onCreate: fields[3] as bool?,
      onUpdate: fields[4] as bool?,
      onDetail: fields[5] as bool?,
      onTable: fields[6] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, PermissionField obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.servicePermissionId)
      ..writeByte(2)
      ..write(obj.fieldName)
      ..writeByte(3)
      ..write(obj.onCreate)
      ..writeByte(4)
      ..write(obj.onUpdate)
      ..writeByte(5)
      ..write(obj.onDetail)
      ..writeByte(6)
      ..write(obj.onTable);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PermissionFieldAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
