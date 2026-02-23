// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CompanyPhone.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompanyPhoneAdapter extends TypeAdapter<CompanyPhone> {
  @override
  final int typeId = 13;

  @override
  CompanyPhone read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompanyPhone(
      id: fields[0] as String?,
      companyId: fields[1] as Company?,
      countryCode: fields[2] as int?,
      operatorCode: fields[3] as int?,
      number: fields[4] as int?,
      type: fields[5] as String?,
      isDefault: fields[6] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, CompanyPhone obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.companyId)
      ..writeByte(2)
      ..write(obj.countryCode)
      ..writeByte(3)
      ..write(obj.operatorCode)
      ..writeByte(4)
      ..write(obj.number)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.isDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompanyPhoneAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
