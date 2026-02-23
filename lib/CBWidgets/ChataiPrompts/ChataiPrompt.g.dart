// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChataiPrompt.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChataiPromptAdapter extends TypeAdapter<ChataiPrompt> {
  @override
  final int typeId = 26;

  @override
  ChataiPrompt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChataiPrompt(
      id: fields[0] as String?,
      session: fields[1] as String?,
      chatAiEnabler: fields[2] as ChataiEnabler?,
      chatAiConfig: fields[3] as ChataiConfig?,
      prompt: fields[4] as String?,
      refDocs: fields[5] as String?,
      responseText: fields[6] as String?,
      systemId: fields[7] as String?,
      type: fields[8] as String?,
      role: fields[9] as String?,
      model: fields[10] as String?,
      params: fields[11] as String?,
      stopReason: fields[12] as String?,
      stopSequence: fields[13] as String?,
      inputTokens: fields[14] as int?,
      outputTokens: fields[15] as int?,
      cost: fields[16] as int?,
      status: fields[17] as bool?,
      error: fields[18] as String?,
      userRemarks: fields[19] as String?,
      thumbsDown: fields[20] as bool?,
      thumbsUp: fields[21] as bool?,
      copies: fields[22] as bool?,
      emailed: fields[23] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, ChataiPrompt obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.session)
      ..writeByte(2)
      ..write(obj.chatAiEnabler)
      ..writeByte(3)
      ..write(obj.chatAiConfig)
      ..writeByte(4)
      ..write(obj.prompt)
      ..writeByte(5)
      ..write(obj.refDocs)
      ..writeByte(6)
      ..write(obj.responseText)
      ..writeByte(7)
      ..write(obj.systemId)
      ..writeByte(8)
      ..write(obj.type)
      ..writeByte(9)
      ..write(obj.role)
      ..writeByte(10)
      ..write(obj.model)
      ..writeByte(11)
      ..write(obj.params)
      ..writeByte(12)
      ..write(obj.stopReason)
      ..writeByte(13)
      ..write(obj.stopSequence)
      ..writeByte(14)
      ..write(obj.inputTokens)
      ..writeByte(15)
      ..write(obj.outputTokens)
      ..writeByte(16)
      ..write(obj.cost)
      ..writeByte(17)
      ..write(obj.status)
      ..writeByte(18)
      ..write(obj.error)
      ..writeByte(19)
      ..write(obj.userRemarks)
      ..writeByte(20)
      ..write(obj.thumbsDown)
      ..writeByte(21)
      ..write(obj.thumbsUp)
      ..writeByte(22)
      ..write(obj.copies)
      ..writeByte(23)
      ..write(obj.emailed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChataiPromptAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
