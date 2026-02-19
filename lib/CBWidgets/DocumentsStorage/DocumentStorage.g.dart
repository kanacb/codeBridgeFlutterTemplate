// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DocumentStorage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DocumentStorageAdapter extends TypeAdapter<DocumentStorage> {
  @override
  final int typeId = 6;

  @override
  DocumentStorage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DocumentStorage(
      id: fields[0] as String?,
      name: fields[1] as String?,
      size: fields[2] as int?,
      path: fields[3] as String?,
      lastModified: fields[5] as int?,
      lastModifiedDate: fields[4] as DateTime?,
      eTag: fields[6] as String?,
      versionId: fields[7] as String?,
      url: fields[8] as String?,
      tableId: fields[9] as String?,
      tableName: fields[10] as String?,
      createdBy: fields[11] as User?,
      updatedBy: fields[12] as User?,
      createdAt: fields[13] as DateTime,
      updatedAt: fields[14] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DocumentStorage obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.size)
      ..writeByte(3)
      ..write(obj.path)
      ..writeByte(4)
      ..write(obj.lastModifiedDate)
      ..writeByte(5)
      ..write(obj.lastModified)
      ..writeByte(6)
      ..write(obj.eTag)
      ..writeByte(7)
      ..write(obj.versionId)
      ..writeByte(8)
      ..write(obj.url)
      ..writeByte(9)
      ..write(obj.tableId)
      ..writeByte(10)
      ..write(obj.tableName)
      ..writeByte(11)
      ..write(obj.createdBy)
      ..writeByte(12)
      ..write(obj.updatedBy)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentStorageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
