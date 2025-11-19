// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileAdapter extends TypeAdapter<Profile> {
  @override
  final int typeId = 1;

  @override
  Profile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Profile(
      id: fields[0] as String,
      name: fields[1] as String,
      userId: fields[2] as User,
      hod: fields[3] as bool?,
      hos: fields[4] as bool?,
      role: fields[5] as IdName?,
      position: fields[6] as IdName?,
      skills: (fields[7] as List?)?.cast<String>(),
      bio: fields[8] as String?,
      image: fields[9] as String?,
      branch: fields[10] as IdName?,
      company: fields[11] as IdName?,
      department: fields[12] as IdName?,
      section: fields[13] as IdName?,
      address: fields[14] as Address?,
      phone: fields[15] as Phone?,
      createdAt: fields[16] as DateTime,
      updatedAt: fields[17] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Profile obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.hod)
      ..writeByte(4)
      ..write(obj.hos)
      ..writeByte(5)
      ..write(obj.role)
      ..writeByte(6)
      ..write(obj.position)
      ..writeByte(7)
      ..write(obj.skills)
      ..writeByte(8)
      ..write(obj.bio)
      ..writeByte(9)
      ..write(obj.image)
      ..writeByte(10)
      ..write(obj.branch)
      ..writeByte(11)
      ..write(obj.company)
      ..writeByte(12)
      ..write(obj.department)
      ..writeByte(13)
      ..write(obj.section)
      ..writeByte(14)
      ..write(obj.address)
      ..writeByte(15)
      ..write(obj.phone)
      ..writeByte(16)
      ..write(obj.createdAt)
      ..writeByte(17)
      ..write(obj.updatedAt);
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
