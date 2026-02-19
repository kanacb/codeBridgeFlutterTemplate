// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Companies.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompaniesAdapter extends TypeAdapter<Companies> {
  @override
  final int typeId = 38;

  @override
  Companies read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Companies(
      id: fields[0] as String,
      name: fields[1] as String,
      companyNo: fields[2] as String?,
      newCompanyNumber: fields[3] as dynamic,
      companyType: fields[4] as String?,
      isDefault: fields[5] as bool,
      createdBy: fields[6] as String?,
      updatedBy: fields[7] as String?,
      createdAt: fields[8] as DateTime,
      updatedAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Companies obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.companyNo)
      ..writeByte(3)
      ..write(obj.newCompanyNumber)
      ..writeByte(4)
      ..write(obj.companyType)
      ..writeByte(5)
      ..write(obj.isDefault)
      ..writeByte(6)
      ..write(obj.createdBy)
      ..writeByte(7)
      ..write(obj.updatedBy)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompaniesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
