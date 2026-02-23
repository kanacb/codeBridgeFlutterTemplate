// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FcmQue.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FcmQueAdapter extends TypeAdapter<FcmQue> {
  @override
  final int typeId = 29;

  @override
  FcmQue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FcmQue(
      id: fields[0] as String?,
      payload: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FcmQue obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.payload);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FcmQueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
