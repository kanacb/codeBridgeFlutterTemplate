// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChecklistResponse.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChecklistResponseAdapter extends TypeAdapter<ChecklistResponse> {
  @override
  final int typeId = 40;

  @override
  ChecklistResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChecklistResponse(
      checkListId: fields[0] as IdName?,
      checkId: fields[1] as String?,
      responseValue: fields[2] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, ChecklistResponse obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.checkListId)
      ..writeByte(1)
      ..write(obj.checkId)
      ..writeByte(2)
      ..write(obj.responseValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChecklistResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
