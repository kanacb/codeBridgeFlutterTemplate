// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Uploader.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UploaderAdapter extends TypeAdapter<Uploader> {
  @override
  final int typeId = 36;

  @override
  Uploader read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Uploader(
      id: fields[0] as String?,
      serviceName: fields[1] as String?,
      user: fields[2] as User?,
      results: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Uploader obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.serviceName)
      ..writeByte(2)
      ..write(obj.user)
      ..writeByte(3)
      ..write(obj.results);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UploaderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
