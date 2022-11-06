import 'dart:io';

import 'package:crop_doctor/classes/colors.dart';
import 'package:crop_doctor/classes/disease_info.dart';
import 'package:crop_doctor/classes/language_init.dart';
import 'package:crop_doctor/classes/strings.dart';
import 'package:crop_doctor/classes/stringsEN.dart';
import 'package:crop_doctor/classes/stringsHI.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DiseaseDescription extends StatefulWidget {
  const DiseaseDescription({Key? key}) : super(key: key);

  @override
  _DiseaseDescriptionState createState() => _DiseaseDescriptionState();
}

class _DiseaseDescriptionState extends State<DiseaseDescription> {

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
    String diseaseID = args["diseaseID"];

    Box<DiseaseInfo> diseaseInfoDatabase = Hive.box<DiseaseInfo>("diseaseInfo");
    DiseaseInfo? diseaseInfo = diseaseInfoDatabase.get(diseaseID);

    // INIT SCREEN LANGUAGE
    AppStrings appStrings = await languageInitializer.initLanguage();

    return {"appStrings": appStrings, "diseaseInfo": diseaseInfo};
  }

  Widget _buildFunction(BuildContext buildContext, AsyncSnapshot snapshot) {

    Widget child;

    if (snapshot.hasData) {

      appStrings = snapshot.data["appStrings"];
      DiseaseInfo _diseaseInfo = snapshot.data["diseaseInfo"];

      String languageID = appStrings!.languageID;
      String diseaseName;
      String plantName;
      String diseaseDescription;

      if(languageID == "EN") {
        diseaseName = _diseaseInfo.diseaseNameEN;
        diseaseDescription = _diseaseInfo.diseaseDescriptionEN;
        plantName = "";
      }
      else {
        diseaseName = _diseaseInfo.diseaseNameHI;
        diseaseDescription = _diseaseInfo.diseaseDescriptionHI;
        plantName = "";
      }

      child = Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (appStrings!.languageID == "EN") {
              languageInitializer.setLanguage("HI");
              setLanguage("HI");
              setState(() {
                diseaseName = _diseaseInfo.diseaseNameHI;
                diseaseDescription = _diseaseInfo.diseaseDescriptionHI;
                plantName = "";
              });
            }
            else {
              languageInitializer.setLanguage("EN");
              setLanguage("EN");
              setState(() {
                diseaseName = _diseaseInfo.diseaseNameEN;
                diseaseDescription = _diseaseInfo.diseaseDescriptionEN;
                plantName = "";
              });
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
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListView(
            children: [
              FadeInImage(
                placeholder: AssetImage("assets/placeholder_image.png"),
                image: FileImage(File(_diseaseInfo.diseaseImagePath)),
                fit: BoxFit.fitWidth,
              ),

              SizedBox(height: 20),

              // DISEASE NAME
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  diseaseName,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),

              SizedBox(height: 20),

              // DISEASE DESCRIPTION
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  diseaseDescription,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
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
