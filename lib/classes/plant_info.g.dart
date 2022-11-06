// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantInfoAdapter extends TypeAdapter<PlantInfo> {
  @override
  final int typeId = 1;

  @override
  PlantInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantInfo(
      plantID: fields[0] as String,
      plantNameEN: fields[1] as String,
      plantNameHI: fields[2] as String,
      plantTypeEN: fields[3] as String,
      plantTypeHI: fields[4] as String,
      plantImagePath: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PlantInfo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.plantID)
      ..writeByte(1)
      ..write(obj.plantNameEN)
      ..writeByte(2)
      ..write(obj.plantNameHI)
      ..writeByte(3)
      ..write(obj.plantTypeEN)
      ..writeByte(4)
      ..write(obj.plantTypeHI)
      ..writeByte(5)
      ..write(obj.plantImagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
