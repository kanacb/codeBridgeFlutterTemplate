// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserTrackerId.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserTrackerIdAdapter extends TypeAdapter<UserTrackerId> {
  @override
  final int typeId = 39;

  @override
  UserTrackerId read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserTrackerId(
      id: fields[0] as String?,
      pageName: fields[1] as String,
      trackerCode: fields[2] as String?,
      userAgent: fields[3] as String?,
      language: fields[4] as String?,
      timeZone: fields[5] as String?,
      cookeisEnabled: fields[6] as String?,
      doNotTrack: fields[7] as String?,
      hardConcurrency: fields[8] as String?,
      marketCode: fields[9] as String?,
      isLoggedIn: fields[10] as bool?,
      userId: fields[11] as User?,
    );
  }

  @override
  void write(BinaryWriter writer, UserTrackerId obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.pageName)
      ..writeByte(2)
      ..write(obj.trackerCode)
      ..writeByte(3)
      ..write(obj.userAgent)
      ..writeByte(4)
      ..write(obj.language)
      ..writeByte(5)
      ..write(obj.timeZone)
      ..writeByte(6)
      ..write(obj.cookeisEnabled)
      ..writeByte(7)
      ..write(obj.doNotTrack)
      ..writeByte(8)
      ..write(obj.hardConcurrency)
      ..writeByte(9)
      ..write(obj.marketCode)
      ..writeByte(10)
      ..write(obj.isLoggedIn)
      ..writeByte(11)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserTrackerIdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
