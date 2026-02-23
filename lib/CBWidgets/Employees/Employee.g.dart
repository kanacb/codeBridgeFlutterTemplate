// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Employee.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmployeeAdapter extends TypeAdapter<Employee> {
  @override
  final int typeId = 16;

  @override
  Employee read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Employee(
      id: fields[0] as String?,
      empNo: fields[1] as String,
      name: fields[2] as String,
      fullname: fields[3] as String,
      company: fields[4] as Company?,
      department: fields[5] as Department?,
      section: fields[6] as Section?,
      position: fields[7] as Position?,
      supervisor: fields[8] as Employee?,
      dateJoined: fields[9] as DateTime?,
      dateTerminated: fields[10] as DateTime?,
      resigned: fields[11] as String,
      empGroup: fields[12] as String,
      empCode: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Employee obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.empNo)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.fullname)
      ..writeByte(4)
      ..write(obj.company)
      ..writeByte(5)
      ..write(obj.department)
      ..writeByte(6)
      ..write(obj.section)
      ..writeByte(7)
      ..write(obj.position)
      ..writeByte(8)
      ..write(obj.supervisor)
      ..writeByte(9)
      ..write(obj.dateJoined)
      ..writeByte(10)
      ..write(obj.dateTerminated)
      ..writeByte(11)
      ..write(obj.resigned)
      ..writeByte(12)
      ..write(obj.empGroup)
      ..writeByte(13)
      ..write(obj.empCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
