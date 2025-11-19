// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'IncomingMachineAbortHistory.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IncomingMachineAbortHistoryAdapter
    extends TypeAdapter<IncomingMachineAbortHistory> {
  @override
  final int typeId = 49;

  @override
  IncomingMachineAbortHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IncomingMachineAbortHistory(
      id: fields[0] as String?,
      ticketId: fields[1] as String?,
      abortedBy: fields[2] as IdName?,
      abortReason: fields[3] as String?,
      abortedAt: fields[4] as DateTime?,
      machineId: fields[5] as String?,
      status: fields[6] as String?,
      createdBy: fields[7] as IdName?,
      updatedBy: fields[8] as IdName?,
      createdAt: fields[9] as DateTime?,
      updatedAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, IncomingMachineAbortHistory obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ticketId)
      ..writeByte(2)
      ..write(obj.abortedBy)
      ..writeByte(3)
      ..write(obj.abortReason)
      ..writeByte(4)
      ..write(obj.abortedAt)
      ..writeByte(5)
      ..write(obj.machineId)
      ..writeByte(6)
      ..write(obj.status)
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
      other is IncomingMachineAbortHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
