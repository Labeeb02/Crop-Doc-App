// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'processed_image.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProcessedImageAdapter extends TypeAdapter<ProcessedImage> {
  @override
  final int typeId = 0;

  @override
  ProcessedImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProcessedImage(
      imagePath: fields[0] as String,
      diseaseID: fields[1] as String,
      epochSeconds: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProcessedImage obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.imagePath)
      ..writeByte(1)
      ..write(obj.diseaseID)
      ..writeByte(2)
      ..write(obj.epochSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProcessedImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
