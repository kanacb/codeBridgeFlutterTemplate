// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProfileMenu.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileMenuAdapter extends TypeAdapter<ProfileMenu> {
  @override
  final int typeId = 34;

  @override
  ProfileMenu read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileMenu(
      id: fields[0] as String?,
      user: fields[1] as User?,
      roles: (fields[2] as List?)?.cast<Role>(),
      positions: (fields[3] as List?)?.cast<Position>(),
      profiles: (fields[4] as List?)?.cast<Profile>(),
      menuItems: fields[5] as String?,
      company: fields[6] as Company?,
      branch: fields[7] as Branch?,
      section: fields[8] as Section?,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileMenu obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.user)
      ..writeByte(2)
      ..write(obj.roles)
      ..writeByte(3)
      ..write(obj.positions)
      ..writeByte(4)
      ..write(obj.profiles)
      ..writeByte(5)
      ..write(obj.menuItems)
      ..writeByte(6)
      ..write(obj.company)
      ..writeByte(7)
      ..write(obj.branch)
      ..writeByte(8)
      ..write(obj.section);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileMenuAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
