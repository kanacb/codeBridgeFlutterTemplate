// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Company.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompanyAdapter extends TypeAdapter<Company> {
  @override
  final int typeId = 3;

  @override
  Company read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Company(
      id: fields[0] as String?,
      name: fields[1] as String?,
      companyNo: fields[2] as String,
      newCompanyNumber: fields[3] as String?,
      DateIncorporated: fields[4] as DateTime?,
      isdefault: fields[5] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Company obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.companyNo)
      ..writeByte(3)
      ..write(obj.newCompanyNumber)
      ..writeByte(4)
      ..write(obj.DateIncorporated)
      ..writeByte(5)
      ..write(obj.isdefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompanyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
