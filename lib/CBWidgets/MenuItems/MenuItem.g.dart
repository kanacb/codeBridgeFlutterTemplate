// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MenuItem.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MenuItemAdapter extends TypeAdapter<MenuItem> {
  @override
  final int typeId = 35;

  @override
  MenuItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MenuItem(
      id: fields[0] as String?,
      userContext: fields[1] as ProfileMenu,
      menuItems: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MenuItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userContext)
      ..writeByte(2)
      ..write(obj.menuItems);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
