// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserAddress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAddressAdapter extends TypeAdapter<UserAddress> {
  @override
  final int typeId = 11;

  @override
  UserAddress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserAddress(
      id: fields[0] as String?,
      userId: fields[1] as User?,
      Street1: fields[2] as String?,
      Street2: fields[3] as String?,
      Poscode: fields[4] as String?,
      City: fields[5] as String?,
      stateName: fields[6] as String?,
      Province: fields[7] as String?,
      Country: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserAddress obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.Street1)
      ..writeByte(3)
      ..write(obj.Street2)
      ..writeByte(4)
      ..write(obj.Poscode)
      ..writeByte(5)
      ..write(obj.City)
      ..writeByte(6)
      ..write(obj.stateName)
      ..writeByte(7)
      ..write(obj.Province)
      ..writeByte(8)
      ..write(obj.Country);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
