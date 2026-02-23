// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileAdapter extends TypeAdapter<Profile> {
  @override
  final int typeId = 9;

  @override
  Profile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Profile(
      id: fields[0] as String?,
      name: fields[1] as String,
      userId: fields[2] as User?,
      image: fields[3] as String,
      bio: fields[4] as String?,
      department: fields[5] as Department,
      hod: fields[6] as bool,
      section: fields[7] as Section?,
      hos: fields[8] as bool,
      role: fields[9] as Role?,
      position: fields[10] as Position,
      manager: fields[11] as User?,
      company: fields[12] as Company,
      branch: fields[13] as Branch?,
      skills: fields[14] as String?,
      address: fields[15] as UserAddress?,
      phone: fields[16] as UserPhone?,
    );
  }

  @override
  void write(BinaryWriter writer, Profile obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.bio)
      ..writeByte(5)
      ..write(obj.department)
      ..writeByte(6)
      ..write(obj.hod)
      ..writeByte(7)
      ..write(obj.section)
      ..writeByte(8)
      ..write(obj.hos)
      ..writeByte(9)
      ..write(obj.role)
      ..writeByte(10)
      ..write(obj.position)
      ..writeByte(11)
      ..write(obj.manager)
      ..writeByte(12)
      ..write(obj.company)
      ..writeByte(13)
      ..write(obj.branch)
      ..writeByte(14)
      ..write(obj.skills)
      ..writeByte(15)
      ..write(obj.address)
      ..writeByte(16)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
