// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MailQue.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MailQueAdapter extends TypeAdapter<MailQue> {
  @override
  final int typeId = 33;

  @override
  MailQue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MailQue(
      id: fields[0] as String?,
      name: fields[1] as String?,
      from: fields[2] as String?,
      subject: fields[3] as String?,
      recipients: fields[4] as String?,
      content: fields[5] as String?,
      payload: fields[6] as String?,
      templateId: fields[7] as String?,
      status: fields[8] as bool?,
      jobId: fields[9] as int?,
      end: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MailQue obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.from)
      ..writeByte(3)
      ..write(obj.subject)
      ..writeByte(4)
      ..write(obj.recipients)
      ..writeByte(5)
      ..write(obj.content)
      ..writeByte(6)
      ..write(obj.payload)
      ..writeByte(7)
      ..write(obj.templateId)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.jobId)
      ..writeByte(10)
      ..write(obj.end);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MailQueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
