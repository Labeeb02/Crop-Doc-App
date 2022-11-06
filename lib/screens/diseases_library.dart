
import 'package:crop_doctor/classes/colors.dart';
import 'package:crop_doctor/classes/language_init.dart';
import 'package:crop_doctor/classes/strings.dart';
import 'package:crop_doctor/classes/stringsEN.dart';
import 'package:crop_doctor/classes/stringsHI.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:crop_doctor/classes/plant_info.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'plant_card.dart';

class DiseasesLibrary extends StatefulWidget {
  @override
  _DiseasesLibraryState createState() => _DiseasesLibraryState();
}

class _DiseasesLibraryState extends State<DiseasesLibrary> {

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

  Future<Map> _init() async {

    Box<PlantInfo> plantInfoDatabase = Hive.box<PlantInfo>("plantInfo");

    // INIT SCREEN LANGUAGE
    AppStrings appStrings = await languageInitializer.initLanguage();

    return {"appStrings": appStrings, "hiveBox": plantInfoDatabase};
  }

  Widget _buildFunction(BuildContext buildContext, AsyncSnapshot snapshot) {

    Widget child;

    if(snapshot.hasData) {

      appStrings = snapshot.data["appStrings"];
      Box<PlantInfo> plantInfoDatabase = snapshot.data["hiveBox"];

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
        body: ValueListenableBuilder(
          valueListenable: plantInfoDatabase.listenable(),
          builder: (BuildContext context, Box<PlantInfo> value, Widget? child) {

            List<String> plantInfoList = plantInfoDatabase.keys.cast<String>().toList();

            return ListView.separated(

                itemBuilder: (context, index) {

                  String key = plantInfoList[index];
                  PlantInfo? plantInfo = plantInfoDatabase.get(key);

                  return PlantCard(plantInfo!, appStrings!.languageID);
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: plantInfoList.length
            );
          },
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
        future: _init(),
        builder: _buildFunction
    );
  }
}
