// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UsedPart.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsedPartAdapter extends TypeAdapter<UsedPart> {
  @override
  final int typeId = 52;

  @override
  UsedPart read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UsedPart(
      partId: fields[0] as String?,
      quantity: fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UsedPart obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.partId)
      ..writeByte(1)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsedPartAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
