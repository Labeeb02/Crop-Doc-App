import 'package:crop_doctor/classes/strings.dart';
import 'package:crop_doctor/classes/stringsEN.dart';
import 'package:crop_doctor/classes/stringsHI.dart';
import 'package:hive/hive.dart';

class LanguageInitializer {

  Box appStates = Hive.box("appStates");

  void setLanguage(String languageID) {
    appStates.put("languageID", languageID);
  }

  Future<AppStrings> initLanguage() async {

    AppStrings appStrings;
    String languageID = appStates.get("languageID");

    if(languageID == "EN")
      appStrings = AppStringsEN();
    else
      appStrings = AppStringsHI();

    print(languageID);

    return appStrings;
  }
}