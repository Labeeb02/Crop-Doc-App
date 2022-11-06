import 'package:crop_doctor/classes/language_init.dart';
import 'package:crop_doctor/classes/strings.dart';
import 'package:crop_doctor/classes/stringsEN.dart';
import 'package:crop_doctor/classes/stringsHI.dart';
import 'package:crop_doctor/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:crop_doctor/classes/colors.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Fruit extends StatefulWidget {
  const Fruit({Key? key}) : super(key: key);

  @override
  State<Fruit> createState() => _FruitState();
}

class _FruitState extends State<Fruit> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

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

  Future<Map> _init() async {
    AppStrings appStrings = await languageInitializer.initLanguage();
    Box appStates = Hive.box("appStates");

    return {"appStrings": appStrings, "appStates": appStates};
  }



  Widget _builderFunction(BuildContext context, AsyncSnapshot snapshot) {
    Widget child;

    if(snapshot.hasData) {

      appStrings = snapshot.data["appStrings"];
      Box appStates = snapshot.data["appStates"];

      String surveyLinkEnglish = appStates.get("surveyLinkEnglish");
      String surveyLinkHindi = appStates.get("surveyLinkHindi");

      child = Scaffold(
        backgroundColor: AppColor.backgroundColorLight,

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
        body: Stack(children: [
          // BACKGROUND IMAGE
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/BG.png")
                )
            ),
          ),

          // BUTTONS AND STUFF
          Padding(
            padding: const EdgeInsets.all(18),
            child: Center(
              child: Column(
                children: [
                  Spacer(),

                  // CAPTURE IMAGES BUTTON
                  ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.pushNamed(context, "/home",arguments: {"crop": "tomato"});
                      setState(() {});
                    },
                    icon: Align(
                      alignment: Alignment.centerLeft,
                      child: ImageIcon(
                        AssetImage("assets/apple.png"),
                        size: 0,
                      ),
                    ),
                    label: Align(
                      alignment: Alignment.center,
                      child: Text(
                          appStrings!.tomato,
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

                  SizedBox(height: 24),

                  // LOAD IMAGES BUTTON
                  ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.pushNamed(context, "/home",arguments: {"crop": "millet_leaf"});
                      setState(() {});
                    },
                    icon: Align(
                      alignment: Alignment.centerLeft,
                      child: ImageIcon(
                        AssetImage("assets/cherry.png"),
                        size: 0,
                      ),
                    ),
                    label: Align(
                      alignment: Alignment.center,
                      child: Text(
                        appStrings!.milletLeaf,
                        textAlign: TextAlign.center,
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
                            fontWeight: FontWeight.bold)
                    ),
                  ),

                  SizedBox(height: 24),

                  // IMAGES LIBRARY BUTTON
                  ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.pushNamed(context, "/home",arguments: {"crop": "millet_ear"});
                      setState(() {});
                    },
                    icon: Align(
                      alignment: Alignment.centerLeft,
                      child: ImageIcon(
                        AssetImage("assets/orange.png"),
                        size: 0,
                      ),
                    ),
                    label: Align(
                      alignment: Alignment.center,
                      child: Text(
                        appStrings!.milletEar,
                        textAlign: TextAlign.center,
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

                  SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed: () async {
                      launch((appStrings!.languageID == "EN" ? surveyLinkEnglish : surveyLinkHindi));
                    },
                    icon: Align(
                      alignment: Alignment.centerLeft,
                      child: ImageIcon(
                        AssetImage("assets/orange.png"),
                        size: 0,
                      ),
                    ),
                    label: Align(
                      alignment: Alignment.center,
                      child: Text(
                        appStrings!.surveyLink,
                        textAlign: TextAlign.center,
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

                  SizedBox(height: 24),

                  Spacer(),

                  Padding(
                    padding: EdgeInsets.all(18),
                    child: TextButton(
                      onPressed: () async {
                        await Navigator.pushNamed(context, "/about");
                        setState(() {});
                      },
                      child: Text(
                          appStrings!.about,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: buttonColor
                          )
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ]),
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
      future: _init(),
      builder: _builderFunction,
    );
  }
}



