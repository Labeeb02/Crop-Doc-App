import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crop_doctor/classes/colors.dart';
import 'package:crop_doctor/classes/disease_info.dart';
import 'package:crop_doctor/classes/image_downloader.dart';
import 'package:crop_doctor/classes/plant_info.dart';
import 'package:crop_doctor/classes/processed_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:path_provider/path_provider.dart';

//import 'package:syncfusion_flutter_gauges/gauges.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {


  @override
  void initState() {
    setState(() {
      print(currentTask[progress]);
      progress = 0;
    });

    super.initState();
  }

  int progress = 0;
  Map<int, String> currentTask = {
    0: "Loading local databases",
    1: "Checking internet connectivity",
    2: "Initializing Databse",
    3: "Updating Databse",
    4: "Downloading plant info from cloud",
    5: "Downloading plant info from cloud",
    6: "Downloading plant info from cloud",
    7: "Downloading plant info from cloud",
    8: "Downloading plant info from cloud",
    9: "Downloading plant info from cloud",
    10: "Plants fetched from server",
    11: "Updating Other Databases",
    12: "Loading Completed",
  };

  double progressBarWidth = 240/12;
  double completeProgressBarWidth = 240;

  Future<void> fetchPlantInfo() async {

    final appDirectory = await getApplicationDocumentsDirectory();

    setState(() {
      progress = 5;
      print("${currentTask[progress]} - $progress");
    });

    // GET PLANT NAMES AND TYPES FROM FIREBASE RTDB
    await Firebase.initializeApp();
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("plantsList");

    var values;
    await dbRef.get().then((snapshot) => values = snapshot.value);

    Box<PlantInfo> plantInfoDatabase = Hive.box<PlantInfo>("plantInfo");
    Box<List<String>> diseaseListDatabase = Hive.box<List<String>>("diseases");
    Box<DiseaseInfo> diseaseInfoDatabase = Hive.box<DiseaseInfo>("diseaseInfo");

    setState(() {
      progress = 6;
      print("${currentTask[progress]} - $progress");
    });
    int count=1;
    ImageDownloader imageDownloader = ImageDownloader();
    for(String plant in values.keys) {

      if(!(plant =="tomato" || plant =="millet_ear" || plant =="millet_leaf")) {
        continue;
      }

      print(plant);
      String imageDirectory = await imageDownloader.downloadImage(
          plant, values[plant]["imageLink"]);

      PlantInfo plantInfo = PlantInfo(
          plantID: plant,
          plantNameEN: values[plant]["plantNameEN"],
          plantNameHI: values[plant]["plantNameHI"],
          plantTypeEN: values[plant]["plantTypeEN"],
          plantTypeHI: values[plant]["plantTypeHI"],
          plantImagePath: imageDirectory
      );

      plantInfoDatabase.put(plant, plantInfo);

      var diseasesList = await fetchDiseasesList(plant);
      diseaseListDatabase.put(plant, diseasesList);
      for (String disease in diseasesList) {
        DiseaseInfo diseaseInfo = await fetchDiseaseInfo(appDirectory, disease);
        diseaseInfoDatabase.put(disease, diseaseInfo);
      }
      setState(() {
        progress = 6+count;
        print("${currentTask[progress]} - $progress");
      });
      count++;
    }
    setState(() {
      progress = 10;
      print("${currentTask[progress]} - $progress");
    });
    print("Plants list fetched");
  }

  Future<List<String>> fetchDiseasesList(String plantID) async {

    // GET DISEASES NAMES AND STUFF FROM FIREBASE RTDB
    await Firebase.initializeApp();
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("diseasesGroups").child(plantID);
    var values;
    await dbRef.get().then((snapshot) => values = snapshot.value);

    List<String> diseasesList = [];
    for(String disease in values.keys)
      diseasesList.add(disease);

    //print("Diseases list fetched");
    return diseasesList;
  }

  Future<DiseaseInfo> fetchDiseaseInfo(var appDirectory, String diseaseID) async {

    // GET DISEASE DESCRIPTION AND STUFF FROM FIREBASE RTDB
    await Firebase.initializeApp();
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("diseasesList").child(diseaseID);
    var values;
    await dbRef.get().then((snapshot) => values = snapshot.value);

    bool fileExists = await File("${appDirectory.path}/${values["diseaseNameEN"]}.jpg").exists();
    String imageDirectory = "${appDirectory.path}/${values["diseaseNameEN"]}.jpg";

    // IF DISEASE IMAGE IS DOWNLOADED, NO NEED TO DOWNLOAD IMAGE
    // OTHERWISE DOWNLOAD IMAGE AND STORE ITS PATH IN THE DB
    if(!fileExists) {

      File imageFile = File(imageDirectory);

      var response = await Dio().get(
          values["imageLink"],
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: 0
          )
      );

      var raf = imageFile.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
    }

    DiseaseInfo diseaseInfo = DiseaseInfo(
        diseaseID: diseaseID,
        diseaseNameEN: values["diseaseNameEN"],
        diseaseNameHI: values["diseaseNameHI"],
        diseaseDescriptionEN: values["descriptionEN"],
        diseaseDescriptionHI: values["descriptionHI"],
        diseaseImagePath: imageDirectory
    );

    //print("Disease info fetched");

    return diseaseInfo;
  }

  Future<void> _init() async {

    Hive.registerAdapter(ProcessedImageAdapter());
    await Hive.openBox<ProcessedImage>("processedTomatoImages");
    await Hive.openBox<ProcessedImage>("processedMilletEarImages");
    await Hive.openBox<ProcessedImage>("processedMilletLeafImages");

    Hive.registerAdapter(PlantInfoAdapter());
    await Hive.openBox<PlantInfo>("plantInfo");

    Hive.registerAdapter(DiseaseInfoAdapter());
    await Hive.openBox<DiseaseInfo>("diseaseInfo");

    await Hive.openBox<List<String>>("diseases");
    await Hive.openBox("appStates");

    Box appStates = Hive.box("appStates");

    var languageID = appStates.get("languageID");
    if(languageID == null) {
      appStates.put("languageID", "EN");
    }

    var firstLaunch = appStates.get("firstLaunch");
    if(firstLaunch == null) {
      firstLaunch = true;
      appStates.put("firstLaunch", true);
    }

    setState(() {
      progress = 1;
      print("${currentTask[progress]} - $progress");
    });

    // CHECK INTERNET CONNECTIVITY
    Connectivity connectivity = Connectivity();
    ConnectivityResult connectivityResult = await connectivity.checkConnectivity();


    setState(() {
      progress = 2;
      print("${currentTask[progress]} - $progress");
    });
    //await fetchPlantInfo();
    // IF THERE IS INTERNET CONNECTION
    // FETCH DATA FROM FIREBASE
    if(connectivityResult != ConnectivityResult.none) {

      // CHECK WHEN THE DATABASE WAS LAST UPDATED
      await Firebase.initializeApp();
      DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("last_updated");
      var value;
      await dbRef.get().then((snapshot) => value = snapshot.value);
      var lastUpdated = appStates.get("last_updated");


      setState(() {
        progress = 3;
        print("${currentTask[progress]} - $progress");
      });
      // print("Last updated: $lastUpdated");
      // print("Current updated: $value");

      if(lastUpdated == null || lastUpdated < value) {

        appStates.put("last_updated", value);

        setState(() {
          progress = 4;
          print("${currentTask[progress]} - $progress");
        });
        // GET PLANT NAMES AND TYPES FROM FIREBASE RTDB
        await fetchPlantInfo();

        // GET INFO ABOUT APP

        dbRef = FirebaseDatabase.instance.reference().child("about");
        var aboutTexts;
        await dbRef.get().then((snapshot) => aboutTexts = snapshot.value);
        for(String aboutText in aboutTexts.keys) {
          appStates.put(aboutText, aboutTexts[aboutText]);
        }
        setState(() {
          progress = 11;
          print("${currentTask[progress]} - $progress");
        });
      }

      if(firstLaunch)
        appStates.put("firstLaunch", false);
    }

    setState(() {
      progress = 12;
      print("${currentTask[progress]} - $progress");
    });

    print("Initialization complete");
  }

  Widget _buildFunction(BuildContext context, AsyncSnapshot snapshot) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    color: AppColor.themeColorLight,
                    height: 10,
                    width: completeProgressBarWidth,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    color: AppColor.appBarColorLight,
                    height: 10,
                    width: progress * progressBarWidth,
                  ),
                )
              ],
            ),
            SizedBox(height:30),
            Text(
              currentTask[progress]!,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColor.buttonColorLight
              )
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init().then((response) {
        Navigator.pushReplacementNamed(context, "/fruits");
        return response;
      }),
      builder: _buildFunction
    );
  }
}
