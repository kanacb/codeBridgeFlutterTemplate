// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Staffinfo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StaffinfoAdapter extends TypeAdapter<Staffinfo> {
  @override
  final int typeId = 15;

  @override
  Staffinfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Staffinfo(
      id: fields[0] as String?,
      empno: fields[1] as int?,
      name: fields[2] as String?,
      namenric: fields[3] as String?,
      compcode: fields[4] as int?,
      compname: fields[5] as String?,
      deptcode: fields[6] as String?,
      deptdesc: fields[7] as String?,
      sectcode: fields[8] as int?,
      sectdesc: fields[9] as String?,
      designation: fields[10] as String?,
      email: fields[11] as String?,
      resign: fields[12] as String?,
      supervisor: fields[13] as String?,
      datejoin: fields[14] as int?,
      empgroup: fields[15] as String?,
      empgradecode: fields[16] as String?,
      terminationdate: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Staffinfo obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.empno)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.namenric)
      ..writeByte(4)
      ..write(obj.compcode)
      ..writeByte(5)
      ..write(obj.compname)
      ..writeByte(6)
      ..write(obj.deptcode)
      ..writeByte(7)
      ..write(obj.deptdesc)
      ..writeByte(8)
      ..write(obj.sectcode)
      ..writeByte(9)
      ..write(obj.sectdesc)
      ..writeByte(10)
      ..write(obj.designation)
      ..writeByte(11)
      ..write(obj.email)
      ..writeByte(12)
      ..write(obj.resign)
      ..writeByte(13)
      ..write(obj.supervisor)
      ..writeByte(14)
      ..write(obj.datejoin)
      ..writeByte(15)
      ..write(obj.empgroup)
      ..writeByte(16)
      ..write(obj.empgradecode)
      ..writeByte(17)
      ..write(obj.terminationdate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StaffinfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
