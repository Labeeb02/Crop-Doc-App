import "package:hive/hive.dart";
part "disease_info.g.dart";

@HiveType(typeId: 3)
class DiseaseInfo {

  @HiveField(0)
  String diseaseID;

  @HiveField(1)
  String diseaseNameEN;
  @HiveField(2)
  String diseaseNameHI;

  @HiveField(3)
  String diseaseDescriptionEN;
  @HiveField(4)
  String diseaseDescriptionHI;

  @HiveField(5)
  String diseaseImagePath;

  DiseaseInfo({
    required this.diseaseID,

    required this.diseaseNameEN,
    required this.diseaseNameHI,

    required this.diseaseDescriptionEN,
    required this.diseaseDescriptionHI,

    required this.diseaseImagePath
  });
}