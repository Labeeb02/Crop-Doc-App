import "package:hive/hive.dart";
part "plant_info.g.dart";

@HiveType(typeId: 1)
class PlantInfo {

  @HiveField(0)
  String plantID;

  @HiveField(1)
  String plantNameEN;
  @HiveField(2)
  String plantNameHI;

  @HiveField(3)
  String plantTypeEN;
  @HiveField(4)
  String plantTypeHI;

  @HiveField(5)
  String plantImagePath;

  PlantInfo({
    required this.plantID,

    required this.plantNameEN,
    required this.plantNameHI,

    required this.plantTypeEN,
    required this.plantTypeHI,

    required this.plantImagePath
  });
}