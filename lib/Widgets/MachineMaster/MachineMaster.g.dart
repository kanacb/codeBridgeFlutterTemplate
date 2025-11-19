// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MachineMaster.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MachineMasterAdapter extends TypeAdapter<MachineMaster> {
  @override
  final int typeId = 12;

  @override
  MachineMaster read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MachineMaster(
      id: fields[0] as String?,
      ownership: fields[1] as Branches,
      vendingMachineCode: fields[2] as String?,
      modelNo: fields[3] as String?,
      serialNumber: fields[4] as String?,
      vendingMachineType: fields[5] as IdName?,
      comissionDate: fields[6] as DateTime?,
      createdBy: fields[7] as String?,
      updatedBy: fields[8] as String?,
      createdAt: fields[9] as DateTime?,
      updatedAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MachineMaster obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ownership)
      ..writeByte(2)
      ..write(obj.vendingMachineCode)
      ..writeByte(3)
      ..write(obj.modelNo)
      ..writeByte(4)
      ..write(obj.serialNumber)
      ..writeByte(5)
      ..write(obj.vendingMachineType)
      ..writeByte(6)
      ..write(obj.comissionDate)
      ..writeByte(7)
      ..write(obj.createdBy)
      ..writeByte(8)
      ..write(obj.updatedBy)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MachineMasterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
