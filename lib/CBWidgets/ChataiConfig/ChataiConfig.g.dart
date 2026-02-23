// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChataiConfig.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChataiConfigAdapter extends TypeAdapter<ChataiConfig> {
  @override
  final int typeId = 25;

  @override
  ChataiConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChataiConfig(
      id: fields[0] as String?,
      name: fields[1] as String?,
      chatAiEnabler: fields[2] as ChataiEnabler,
      bedrockModelId: fields[3] as String?,
      modelParamsJson: fields[4] as String?,
      human: fields[5] as String?,
      task: fields[6] as String?,
      noCondition: fields[7] as String?,
      yesCondition: fields[8] as String?,
      documents: fields[9] as String?,
      example: fields[10] as String?,
      preamble: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChataiConfig obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.chatAiEnabler)
      ..writeByte(3)
      ..write(obj.bedrockModelId)
      ..writeByte(4)
      ..write(obj.modelParamsJson)
      ..writeByte(5)
      ..write(obj.human)
      ..writeByte(6)
      ..write(obj.task)
      ..writeByte(7)
      ..write(obj.noCondition)
      ..writeByte(8)
      ..write(obj.yesCondition)
      ..writeByte(9)
      ..write(obj.documents)
      ..writeByte(10)
      ..write(obj.example)
      ..writeByte(11)
      ..write(obj.preamble);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChataiConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
