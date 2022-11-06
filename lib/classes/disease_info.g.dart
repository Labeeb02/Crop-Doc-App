// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disease_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiseaseInfoAdapter extends TypeAdapter<DiseaseInfo> {
  @override
  final int typeId = 3;

  @override
  DiseaseInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiseaseInfo(
      diseaseID: fields[0] as String,
      diseaseNameEN: fields[1] as String,
      diseaseNameHI: fields[2] as String,
      diseaseDescriptionEN: fields[3] as String,
      diseaseDescriptionHI: fields[4] as String,
      diseaseImagePath: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DiseaseInfo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.diseaseID)
      ..writeByte(1)
      ..write(obj.diseaseNameEN)
      ..writeByte(2)
      ..write(obj.diseaseNameHI)
      ..writeByte(3)
      ..write(obj.diseaseDescriptionEN)
      ..writeByte(4)
      ..write(obj.diseaseDescriptionHI)
      ..writeByte(5)
      ..write(obj.diseaseImagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiseaseInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
