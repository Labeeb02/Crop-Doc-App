import 'dart:async';

import 'package:crop_doctor/classes/plant_info.dart';
import 'package:crop_doctor/classes/language_init.dart';
import 'package:crop_doctor/classes/strings.dart';
import 'package:crop_doctor/classes/stringsEN.dart';
import 'package:crop_doctor/classes/stringsHI.dart';
import 'package:flutter/material.dart';
import 'package:crop_doctor/classes/colors.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';

import '../classes/disease_info.dart';
import 'plant_card.dart';

import 'dart:io';

import 'package:hive/hive.dart';


//same



class RouteTwo extends StatelessWidget {
  final String image;

  RouteTwo({Key? key, required this.image})
      : super(key: key);

  Color buttonColor = AppColor.buttonColorLight;
  double buttonFontSize = 28;
  double buttonWidth = 300;
  double buttonHeight = 60;
  double buttonRadius = 10;
  double buttonIconSize = 48;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen two ✌️'),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              width: double.infinity,
              child: Image(
                image: AssetImage(image),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20.0),
            child: Center(
                child : Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget> [ Text(
                      "hello its me",
                      style: TextStyle(fontSize: 40),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.pushNamed(context, "/capture_image");

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
                            "Capture Image",
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
                          fixedSize: Size(buttonWidth, buttonHeight),
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
}





// delete after use


class SampleImages extends StatefulWidget {
  @override
  _SampleImagesState createState() => _SampleImagesState();
}

class _SampleImagesState extends State<SampleImages> {

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
    Box<List<String>> diseaseListDatabase = Hive.box<List<String>>("diseases");
    Box<DiseaseInfo> diseaseInfoDatabase = Hive.box<DiseaseInfo>("diseaseInfo");

    // INIT SCREEN LANGUAGE
    AppStrings appStrings = await languageInitializer.initLanguage();

    return {"appStrings": appStrings, "plantBox": plantInfoDatabase,"diseaseListBox": diseaseListDatabase,"diseaseInfoBox": diseaseInfoDatabase};
  }



  Widget _buildFunction(BuildContext buildContext, AsyncSnapshot snapshot) {

    Widget child;

    // final assets = const [
    //   Image(image: AssetImage('assets/apple.png')),
    //   Image(image: AssetImage('assets/cherry.png')),
    //   Image(image: AssetImage('assets/orange.png')),
    // ];
    var arguments = ModalRoute.of(context)!.settings.arguments as Map;
    String crop = arguments["crop"];

    if(snapshot.hasData) {

      appStrings = snapshot.data["appStrings"];
      Box<PlantInfo> plantInfoDatabase = snapshot.data["plantBox"];
      Box<List<String>> diseaseListDatabase = snapshot.data["diseaseListBox"];
      Box<DiseaseInfo> diseaseInfoDatabase = snapshot.data["diseaseInfoBox"];
      // final assets = const [
      //   Image(image: AssetImage('assets/apple.png')),
      //   Image(image: AssetImage('assets/cherry.png')),
      //   Image(image: AssetImage('assets/orange.png')),
      // ];

      List<String> diseaseList = diseaseListDatabase.get(crop)!;

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
          title: Text(appStrings!.sampleImages),
          backgroundColor: AppColor.appBarColorLight,
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            crossAxisCount: 3,
          ),
          itemCount: diseaseList.length,
          itemBuilder: (context, index) {
            return new GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/magnify", arguments: {"imagePath":diseaseInfoDatabase.get(diseaseList[index])!.diseaseImagePath,"crop":crop});
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image : FileImage(File(diseaseInfoDatabase.get(diseaseList[index])!.diseaseImagePath)),
                    // image: new AssetImage('assets/${assets[index]}'),
                  ),
                ),
              ),
            );
          },
        ),
      );
      //     Scaffold(
      //   floatingActionButton: FloatingActionButton.extended(
      //     onPressed: () {
      //       if (appStrings!.languageID == "EN") {
      //         languageInitializer.setLanguage("HI");
      //         setLanguage("HI");
      //       }
      //       else {
      //         languageInitializer.setLanguage("EN");
      //         setLanguage("EN");
      //       }
      //     },
      //     label: Text(
      //       appStrings!.otherLanguage,
      //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      //     ),
      //     backgroundColor: AppColor.themeColorLight,
      //   ),
      //   appBar: AppBar(
      //     leading: IconButton(
      //       icon: Icon(Icons.arrow_back),
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //     ),
      //     title: Text(appStrings!.diseasesLibrary),
      //     backgroundColor: AppColor.appBarColorLight,
      //   ),
      //   body: Container(
      //     padding: const EdgeInsets.all(16.0),
      //     child: ListView(
      //         children: [
      //         ElevatedButton(
      //         onPressed: () {
      //             SwipeImageGallery(
      //               context: context,
      //               children: assets,
      //             ).show();
      //           },
      //             child: const Text('Open Gallery With Overlay'),
      //           ),
      //         ]
      //     )
      //   )
      // );
    }
    else
      child = Scaffold(
        body: Center(
          child: Text(
            "Loading..123"
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
