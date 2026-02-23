// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Department.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DepartmentAdapter extends TypeAdapter<Department> {
  @override
  final int typeId = 5;

  @override
  Department read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Department(
      id: fields[0] as String?,
      company: fields[1] as Company,
      deptName: fields[2] as String?,
      code: fields[3] as String?,
      isDefault: fields[4] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Department obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.company)
      ..writeByte(2)
      ..write(obj.deptName)
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
      other is DepartmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
