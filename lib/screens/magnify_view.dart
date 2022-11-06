import 'package:crop_doctor/classes/language_init.dart';
import 'package:crop_doctor/classes/strings.dart';
import 'package:crop_doctor/classes/stringsEN.dart';
import 'package:crop_doctor/classes/stringsHI.dart';

import 'package:flutter/material.dart';
import 'package:crop_doctor/classes/colors.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

import 'dart:io';

class Magnify extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Magnify> {

  // @override
  // void dispose() {
  //   Hive.close();
  //   super.dispose();
  // }

  Color buttonColor = AppColor.buttonColorLight;
  double buttonFontSize = 28;
  double buttonWidth = 300;
  double buttonHeight = 60;
  double buttonRadius = 10;
  double buttonIconSize = 48;

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

  Widget _builderFunction(BuildContext context, AsyncSnapshot snapshot) {

    var arguments = ModalRoute.of(context)!.settings.arguments as Map;
    String imagePath = arguments["imagePath"];
    String crop = arguments["crop"];

    Widget child;

    if(snapshot.hasData) {

      appStrings = snapshot.data;

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
          title: Text(""),
          backgroundColor: AppColor.appBarColorLight,
        ),
        body: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                width: double.infinity,
                child: Image(
                  image: FileImage(File(imagePath)),
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.all(20.0),
                child: Center(
                  child : Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: <Widget> [
                      SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.pushNamed(context, "/examine_leaf", arguments: {"filePath": imagePath,"crop":crop});
                          setState(() {});
                        },
                        icon: Align(
                          alignment: Alignment.centerLeft,
                          child: ImageIcon(
                            AssetImage("assets/camera_icon.png"),
                            size: 0,
                          ),
                        ),
                        label: Align(
                          alignment: Alignment.center,
                          child: Text(
                              appStrings!.examinePhoto,
                              textAlign: TextAlign.center
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(buttonRadius)
                                )
                            ),
                            primary: buttonColor,
                            minimumSize: Size(buttonWidth, buttonHeight),
                            textStyle: TextStyle(
                                fontSize: buttonFontSize,
                                fontWeight: FontWeight.bold
                            )
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ],
        ),
      );
    }
    else
      child = Scaffold(
        body: Center(
            child: Text("Loading..")
        ),
      );

    return child;
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: languageInitializer.initLanguage(),
      builder: _builderFunction,
    );
  }
}
