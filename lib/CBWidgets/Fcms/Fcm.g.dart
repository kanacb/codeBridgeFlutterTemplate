// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Fcm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FcmAdapter extends TypeAdapter<Fcm> {
  @override
  final int typeId = 28;

  @override
  Fcm read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Fcm(
      id: fields[0] as String?,
      fcmId: fields[1] as String,
      device: fields[2] as String?,
      valid: fields[3] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Fcm obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fcmId)
      ..writeByte(2)
      ..write(obj.device)
      ..writeByte(3)
      ..write(obj.valid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FcmAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
