// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DepartmentAdmin.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DepartmentAdminAdapter extends TypeAdapter<DepartmentAdmin> {
  @override
  final int typeId = 18;

  @override
  DepartmentAdmin read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DepartmentAdmin(
      id: fields[0] as String?,
      departmentId: fields[1] as Department?,
      employeeId: fields[2] as Employee?,
    );
  }

  @override
  void write(BinaryWriter writer, DepartmentAdmin obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.departmentId)
      ..writeByte(2)
      ..write(obj.employeeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DepartmentAdminAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
