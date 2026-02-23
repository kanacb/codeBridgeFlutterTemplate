// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChataiEnabler.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChataiEnablerAdapter extends TypeAdapter<ChataiEnabler> {
  @override
  final int typeId = 24;

  @override
  ChataiEnabler read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChataiEnabler(
      id: fields[0] as String?,
      name: fields[1] as String?,
      serviceName: fields[2] as String?,
      description: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChataiEnabler obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.serviceName)
      ..writeByte(3)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChataiEnablerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
