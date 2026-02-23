// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PermissionService.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PermissionServiceAdapter extends TypeAdapter<PermissionService> {
  @override
  final int typeId = 40;

  @override
  PermissionService read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PermissionService(
      id: fields[0] as String?,
      service: fields[1] as String,
      create: fields[2] as bool?,
      read: fields[3] as bool?,
      update: fields[4] as bool?,
      delete: fields[5] as bool?,
      import: fields[6] as bool?,
      export: fields[7] as bool?,
      seeder: fields[8] as bool?,
      userId: fields[9] as User?,
      roleId: fields[10] as Role?,
      profile: fields[11] as Profile?,
      positionId: fields[12] as Position?,
    );
  }

  @override
  void write(BinaryWriter writer, PermissionService obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.service)
      ..writeByte(2)
      ..write(obj.create)
      ..writeByte(3)
      ..write(obj.read)
      ..writeByte(4)
      ..write(obj.update)
      ..writeByte(5)
      ..write(obj.delete)
      ..writeByte(6)
      ..write(obj.import)
      ..writeByte(7)
      ..write(obj.export)
      ..writeByte(8)
      ..write(obj.seeder)
      ..writeByte(9)
      ..write(obj.userId)
      ..writeByte(10)
      ..write(obj.roleId)
      ..writeByte(11)
      ..write(obj.profile)
      ..writeByte(12)
      ..write(obj.positionId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PermissionServiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
