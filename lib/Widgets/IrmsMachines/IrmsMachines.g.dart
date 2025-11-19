// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'IrmsMachines.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IrmsMachinesAdapter extends TypeAdapter<IrmsMachines> {
  @override
  final int typeId = 43;

  @override
  IrmsMachines read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IrmsMachines(
      id: fields[0] as String?,
      ownership: fields[1] as Branches,
      vendingMachineCode: fields[2] as String?,
      modelNo: fields[3] as String?,
      serialNumber: fields[4] as String?,
      vendingMachineType: fields[5] as IdName?,
      commissionDate: fields[6] as DateTime?,
      createdBy: fields[7] as String?,
      updatedBy: fields[8] as String?,
      createdAt: fields[9] as DateTime?,
      updatedAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, IrmsMachines obj) {
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
      ..write(obj.commissionDate)
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
      other is IrmsMachinesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
