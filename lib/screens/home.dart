import 'package:crop_doctor/classes/language_init.dart';
import 'package:crop_doctor/classes/strings.dart';
import 'package:crop_doctor/classes/stringsEN.dart';
import 'package:crop_doctor/classes/stringsHI.dart';

import 'package:flutter/material.dart';
import 'package:crop_doctor/classes/colors.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {

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
    String crop = arguments["crop"];

    Widget child;

    if(snapshot.hasData) {

      appStrings = snapshot.data;

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
                  AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    title: Text((crop=="tomato")?appStrings!.tomato:(crop=="millet_ear")?appStrings!.milletEar:appStrings!.milletLeaf),
                    backgroundColor : Colors.green,
                  ),
                  Spacer(),

                  // CAPTURE IMAGES BUTTON
                  ElevatedButton.icon(

                    onPressed: () async {
                      await Navigator.pushNamed(context, "/capture_image", arguments: {"crop":crop});
                      setState(() {});
                    },
                    icon: Align(
                      alignment: Alignment.centerLeft,
                      child: ImageIcon(
                        AssetImage("assets/camera_icon.png"),
                        size: buttonIconSize,
                      ),
                    ),
                    label: Align(
                      alignment: Alignment.center,
                      child: Text(
                          appStrings!.captureImage,
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
                        // fixedSize: Size(buttonWidth, buttonHeight),
                        minimumSize: Size(buttonWidth, buttonHeight),
                        //maximumSize: Size(buttonWidth, buttonHeight*2),
                        textStyle: TextStyle(
                            fontSize: buttonFontSize,
                            fontWeight: FontWeight.bold
                        )
                    ),
                  ),

                  SizedBox(height: 24),

                  // SAMPLE IMAGES BUTTON
                  ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.pushNamed(context, "/sample_images", arguments: {"crop":crop});
                      setState(() {});
                    },
                    icon: Align(
                      alignment: Alignment.centerLeft,
                      child: ImageIcon(
                        AssetImage("assets/image_gallery_icon.png"),
                        size: buttonIconSize,
                      ),
                    ),
                    label: Align(
                      alignment: Alignment.center,
                      child: Text(
                        appStrings!.sampleImages,
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
                      await Navigator.pushNamed(context, "/images_library", arguments: {"crop":crop});
                      setState(() {});
                    },
                    icon: Align(
                      alignment: Alignment.centerLeft,
                      child: ImageIcon(
                        AssetImage("assets/captured_images_icon.png"),
                        size: buttonIconSize,
                      ),
                    ),
                    label: Align(
                      alignment: Alignment.center,
                      child: Text(
                        appStrings!.imageLibrary,
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

                  // DISEASES LIBRARY BUTTON
                  ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.pushNamed(context, "/diseases_library", arguments: {"crop":crop});
                      setState(() {});
                    },
                    icon: Align(
                      alignment: Alignment.centerLeft,
                      child: ImageIcon(
                        AssetImage("assets/diseases_library_icon.png"),
                        size: buttonIconSize,
                      ),
                    ),
                    label: Align(
                      alignment: Alignment.center,
                      child: Text(
                        appStrings!.diseasesLibrary,
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
            child: Text("Loading..123")
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

