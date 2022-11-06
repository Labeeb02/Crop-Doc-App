import 'package:crop_doctor/classes/language_init.dart';
import 'package:crop_doctor/classes/strings.dart';
import 'package:crop_doctor/classes/stringsEN.dart';
import 'package:crop_doctor/classes/stringsHI.dart';
import 'package:flutter/material.dart';
import 'package:crop_doctor/classes/colors.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {

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
    AppStrings appStrings = await languageInitializer.initLanguage();
    Box appStates = Hive.box("appStates");

    return {"appStrings": appStrings, "appStates": appStates};
  }

  Widget _builderFunction(BuildContext buildContext, AsyncSnapshot snapshot) {

    Widget child;

    if(snapshot.hasData) {

      appStrings = snapshot.data["appStrings"];
      Box appStates = snapshot.data["appStates"];

      String languageID = appStrings!.languageID;

      String surveyLinkEnglish = appStates.get("surveyLinkEnglish");
      String surveyLinkHindi = appStates.get("surveyLinkHindi");

      String aboutText;
      if(languageID == "EN") {
        aboutText = appStates.get("aboutEN");
      }
      else {
        aboutText = appStates.get("aboutHI");
      }

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
          title: Text(appStrings!.about),
          backgroundColor: AppColor.appBarColorLight,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              Center(
                child: Text(
                  aboutText,
                  style: TextStyle(
                      fontSize: 17
                  ),
                ),
              ),

              SizedBox(height: 20),

              Center(
                child: InkWell(
                    child: Text(appStrings!.surveyLinkEnglish),
                    onTap: () => launch(surveyLinkEnglish)
                ),
              ),

              SizedBox(height: 5),

              Center(
                child: InkWell(
                    child: Text(appStrings!.surveyLinkHindi),
                    onTap: () => launch(surveyLinkHindi)
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
          child: Text("Loading.."),
        ),
      );
    
    return child;
  }
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _init(),
      builder: _builderFunction
    );
  }
}
