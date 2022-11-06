import 'dart:io';

import 'package:crop_doctor/classes/colors.dart';
import 'package:crop_doctor/classes/disease_info.dart';
import 'package:crop_doctor/classes/language_init.dart';
import 'package:crop_doctor/classes/strings.dart';
import 'package:crop_doctor/classes/stringsEN.dart';
import 'package:crop_doctor/classes/stringsHI.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}


class ImageDetails extends StatefulWidget {
  @override
  _ImageDetailsState createState() => _ImageDetailsState();
}

class _ImageDetailsState extends State<ImageDetails> {

  Image? loadedImage;
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

    print("init");
    var arguments = ModalRoute.of(context)!.settings.arguments as Map;

    String filePath = arguments["filePath"];

    print(filePath);


    loadedImage = Image.file(File(filePath));
    // if(assetImage == "true") {
    //   File file = await getImageFileFromAssets(filePath);
    //     loadedImage = Image.file(file);
    // }
    // else {
    //     loadedImage = Image.file(File(filePath));
    //
    // }

    // loadedImage = Image.file(File(filePath));
    //
    // loadedImage = Image.file(await getImageFileFromAssets("apple.png"));

    String diseaseID = arguments["diseaseID"];
    Box<DiseaseInfo> diseaseInfoDatabase = Hive.box<DiseaseInfo>("diseaseInfo");

    DiseaseInfo? diseaseInfo = diseaseInfoDatabase.get(diseaseID);

    AppStrings appStrings = await languageInitializer.initLanguage();

    return {"appStrings": appStrings, "diseaseInfo": diseaseInfo};
  }

  Widget _builderFunction(BuildContext context, AsyncSnapshot snapshot) {

    Widget child;

    if(snapshot.hasData) {

      appStrings = snapshot.data["appStrings"];
      DiseaseInfo diseaseInfo = snapshot.data["diseaseInfo"];


      String languageID = appStrings!.languageID;
      String diseaseName;
      String diseaseDescription;

      if(languageID == "EN") {
        diseaseName = diseaseInfo.diseaseNameEN;
        diseaseDescription = diseaseInfo.diseaseDescriptionEN;
      }
      else {
        diseaseName = diseaseInfo.diseaseNameHI;
        diseaseDescription = diseaseInfo.diseaseDescriptionHI;
      }

      child = Scaffold(

        // CHANGE LANGUAGE BUTTON
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
          backgroundColor: AppColor.appBarColorLight,
          title: Text(appStrings!.leafInfo),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              Container(
                child: loadedImage,
              ),

              SizedBox(height: 20),

              Text(
                diseaseName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold
                ),
              ),

              SizedBox(height: 20),

              Text(
                diseaseDescription,
                style: TextStyle(
                  fontSize: 18
                ),
              )
            ]
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
      builder: _builderFunction
    );
  }
}
