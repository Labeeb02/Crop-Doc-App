import 'package:crop_doctor/classes/disease_info.dart';
import 'package:crop_doctor/screens/processed_image_card.dart';

import 'package:crop_doctor/classes/language_init.dart';
import 'package:crop_doctor/classes/processed_image.dart';
import 'package:crop_doctor/classes/strings.dart';
import 'package:crop_doctor/classes/stringsEN.dart';
import 'package:crop_doctor/classes/stringsHI.dart';
import 'package:flutter/material.dart';
import 'package:crop_doctor/classes/colors.dart';

import 'package:hive_flutter/hive_flutter.dart';

class ImagesLibrary extends StatefulWidget {
  @override
  _ImagesLibraryState createState() => _ImagesLibraryState();
}

class _ImagesLibraryState extends State<ImagesLibrary> {

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

    //print("init");

    Box<ProcessedImage> processedTomatoImagesDatabase = Hive.box<ProcessedImage>("processedTomatoImages");
    Box<ProcessedImage> processedMilletEarImagesDatabase = Hive.box<ProcessedImage>("processedMilletEarImages");
    Box<ProcessedImage> processedMilletLeafImagesDatabase = Hive.box<ProcessedImage>("processedMilletLeafImages");
    Box<DiseaseInfo> diseaseInfoDatabase = Hive.box<DiseaseInfo>("diseaseInfo");

    AppStrings appStrings = await languageInitializer.initLanguage();

    //print("init done");

    return {
      "appStrings": appStrings,
      "processedTomatoImagesDatabase": processedTomatoImagesDatabase,
      "processedMilletEarImagesDatabase": processedMilletEarImagesDatabase,
      "processedMilletLeafImagesDatabase": processedMilletLeafImagesDatabase,
      "diseaseInfoDatabase": diseaseInfoDatabase
    };
  }

  Widget _buildFunction(BuildContext context, AsyncSnapshot snapshot) {

    var arguments = ModalRoute.of(context)!.settings.arguments as Map;
    String crop = arguments["crop"];

    Widget child;

    if(snapshot.hasData) {

      appStrings = snapshot.data["appStrings"];
      Box<ProcessedImage> processedImagesDatabase = snapshot.data["processedMilletLeafImagesDatabase"];
      Box<DiseaseInfo> diseaseInfoDatabase = snapshot.data["diseaseInfoDatabase"];

      if(crop == "tomato")
        processedImagesDatabase = snapshot.data["processedTomatoImagesDatabase"];
      else if(crop == "millet_ear")
        processedImagesDatabase = snapshot.data["processedMilletEarImagesDatabase"];

      child = Scaffold(

        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if(appStrings!.languageID == "EN") {
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17
            ),
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
          title: Text(appStrings!.imageLibrary),
          backgroundColor: AppColor.appBarColorLight,
        ),

        // PROCESSED IMAGES LIST
        body: ValueListenableBuilder(
          valueListenable: processedImagesDatabase.listenable(),
          builder: (BuildContext context, value, Widget? child) {

            List<int> imagesList = processedImagesDatabase.keys.cast<int>().toList().reversed.toList();
            return ListView.separated(
              itemBuilder: (context, index) {

                int key = imagesList[index];
                ProcessedImage? processedImage = processedImagesDatabase.get(key);
                DiseaseInfo? diseaseInfo = diseaseInfoDatabase.get(processedImage!.diseaseID);

                // PROCESSED IMAGE CARD
                return ProcessedImageCard(processedImage, diseaseInfo!, appStrings!.languageID);
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: imagesList.length
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
