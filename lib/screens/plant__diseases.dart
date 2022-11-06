import 'package:crop_doctor/classes/colors.dart';
import 'package:crop_doctor/classes/disease_info.dart';
import 'package:crop_doctor/classes/language_init.dart';
import 'package:crop_doctor/classes/strings.dart';
import 'package:crop_doctor/classes/stringsEN.dart';
import 'package:crop_doctor/classes/stringsHI.dart';
import 'package:crop_doctor/screens/disease_card.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PlantDiseases extends StatefulWidget {

  @override
  _PlantDiseasesState createState() => _PlantDiseasesState();
}

class _PlantDiseasesState extends State<PlantDiseases> {

  AppStrings? appStrings;

  void setLanguage(String languageID) {

    setState(() {
      if(languageID == "EN")
        appStrings = AppStringsEN();
      else
        appStrings = AppStringsHI();
    });
  }

  LanguageInitializer languageInitializer = LanguageInitializer();

  Future<Map> _init(BuildContext context) async {

    final args = ModalRoute.of(context)!.settings.arguments as Map;
    String plantID = args["plantID"];

    Box<List<String>> diseaseListDatabase = Hive.box<List<String>>("diseases");
    List<String>? diseasesList = diseaseListDatabase.get(plantID);
    diseasesList!.remove("unknown");
    diseasesList.remove("disease 00");

    Box<DiseaseInfo> diseaseInfoDatabase = Hive.box<DiseaseInfo>("diseaseInfo");

    // INIT SCREEN LANGUAGE
    AppStrings appStrings = await languageInitializer.initLanguage();

    return {"appStrings": appStrings, "diseasesList": diseasesList, "diseasesInfoBox": diseaseInfoDatabase};
  }

  Widget _buildFunction(BuildContext buildContext, AsyncSnapshot snapshot) {

    Widget child;

    if(snapshot.hasData) {

      appStrings = snapshot.data["appStrings"];
      List<String> diseasesList = snapshot.data["diseasesList"];
      Box<DiseaseInfo> diseaseInfoDatabase = snapshot.data["diseasesInfoBox"];

      child = Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (appStrings!.languageID == "EN") {
              languageInitializer.setLanguage("HI");
              setLanguage("HI");
            }
            else {
              languageInitializer.setLanguage("EN");
              setLanguage("EN");
            }
          },
          label: Text(
            appStrings!.otherLanguage,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          backgroundColor: AppColor.themeColorLight,
        ),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(appStrings!.diseasesLibrary),
          backgroundColor: AppColor.appBarColorLight,
        ),
        body: Center(
          child: ListView.builder(
            itemCount: diseasesList.length,
            itemBuilder: (context, index) {
              return DiseaseCard(
                diseaseInfoDatabase.get(diseasesList[index])!,
                appStrings!.languageID,
                diseaseInfoDatabase.get(diseasesList[index])!.diseaseImagePath
              );
            }),
        ),
      );
    }
    else
      child = Scaffold(
        body: Center(
          child: Text(
            "Loading.."
          ),
        ),
      );

    return child;
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _init(context),
      builder: _buildFunction
    );
  }
}
