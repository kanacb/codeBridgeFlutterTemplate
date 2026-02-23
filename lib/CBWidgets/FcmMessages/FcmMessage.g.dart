// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FcmMessage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FcmMessageAdapter extends TypeAdapter<FcmMessage> {
  @override
  final int typeId = 30;

  @override
  FcmMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FcmMessage(
      id: fields[0] as String?,
      title: fields[1] as String?,
      body: fields[2] as String,
      recipients: (fields[3] as List).cast<User>(),
      image: fields[4] as String?,
      payload: fields[5] as String?,
      status: fields[6] as String?,
      successCount: fields[7] as int?,
      failureCount: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, FcmMessage obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.recipients)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.payload)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.successCount)
      ..writeByte(8)
      ..write(obj.failureCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FcmMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
