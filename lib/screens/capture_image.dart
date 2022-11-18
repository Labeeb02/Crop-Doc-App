import 'dart:io';

import 'package:crop_doctor/classes/colors.dart';
import 'package:crop_doctor/classes/language_init.dart';
import 'package:crop_doctor/classes/strings.dart';
import 'package:crop_doctor/classes/stringsEN.dart';
import 'package:crop_doctor/classes/stringsHI.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CaptureImage extends StatefulWidget {
  @override
  _CaptureImageState createState() => _CaptureImageState();
}

class _CaptureImageState extends State<CaptureImage> {

  Image placeholderImage = Image.asset("assets/placeholder_image.png");
  Image? loadedImage;
  ImagePicker imagePicker = ImagePicker();
  String? filePath;

  Color examineLeafButtonColor = AppColor.disabledButtonColorLight;

  AppStrings? appStrings;

  void pickImage(String crop) async {

    XFile? pickedImage;

    if(crop=="")
    {
      pickedImage = await imagePicker.pickImage(source: ImageSource.camera,maxHeight: 256,maxWidth: 256);
    }
    else if(crop=="millet_ear")
    {
      pickedImage = await imagePicker.pickImage(source: ImageSource.camera,maxHeight: 200,maxWidth: 350);
    }
    else if(crop=="millet_leaf")
    {
      pickedImage = await imagePicker.pickImage(source: ImageSource.camera,maxHeight: 200,maxWidth: 350);
    }
    else if(crop=="tomato")
    {
      pickedImage = await imagePicker.pickImage(source: ImageSource.camera,maxHeight: 256,maxWidth: 256);
    }

    if(pickedImage?.path != null) {
      setState(() {
        filePath = pickedImage!.path;
        loadedImage = Image.file(File(pickedImage.path));
        examineLeafButtonColor = AppColor.buttonColorLight;
      });
    }
  }

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

    Widget child;

    var arguments = ModalRoute.of(context)!.settings.arguments as Map;
    String crop = arguments["crop"];

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
          backgroundColor: AppColor.appBarColorLight,
          title: Text(appStrings!.captureImage),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 8,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                  child: Container(
                    child: loadedImage,
                  ),
                ),
              ),
            ),


            SizedBox(height: 20),
            // RE-TAKE IMAGE
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  pickImage(crop);
                },
                style: ElevatedButton.styleFrom(
                    primary: AppColor.buttonColorLight,
                    fixedSize: Size(180, 42)
                ),
                child: Text(
                  appStrings!.retakeImage,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // EXAMINE LEAF
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.pushReplacementNamed(context, "/examine_leaf", arguments: {"filePath": filePath!,"crop":crop});
                },
                style: ElevatedButton.styleFrom(
                    primary: examineLeafButtonColor,
                    fixedSize: Size(180, 42)
                ),
                child: Text(
                  appStrings!.examineLeaf,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),

            Spacer()
          ],
        ),
      );
    }
    else
      child = Scaffold(
        body: Center(
          child: Text(
            "Loading.."
          )
        ),
      );

    return child;
  }

  @override
  Widget build(BuildContext context) {

    if(loadedImage == null) {
      loadedImage = placeholderImage;
      pickImage("");
    }

    return FutureBuilder(
      future: languageInitializer.initLanguage(),
      builder: _builderFunction
    );
  }
}
