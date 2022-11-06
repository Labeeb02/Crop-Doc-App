import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crop_doctor/classes/colors.dart';
import 'package:crop_doctor/classes/disease_id_map.dart';
import 'package:crop_doctor/classes/image_downloader.dart';
import 'package:crop_doctor/classes/language_init.dart';
import 'package:crop_doctor/classes/processed_image.dart';
import 'package:crop_doctor/classes/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}

class ExamineLeaf extends StatefulWidget {
  @override
  _ExamineLeafState createState() => _ExamineLeafState();
}

class _ExamineLeafState extends State<ExamineLeaf> {

  // LOAD THE ML MODEL
  Future<void> loadModel() async {
    print("Loading model...");
    var result='asd';

    print(result);
  }


  // STORE PREDICTED CLASS AND IMAGE
  void storeDiseaseInfo(String imagePath, String diseaseID, String crop) {

    print("Storing disease info");

    // STORE DISEASE INFO
    Box<ProcessedImage> processedTomatoImagesDatabase = Hive.box<ProcessedImage>("processedTomatoImages");
    Box<ProcessedImage> processedMilletEarImagesDatabase = Hive.box<ProcessedImage>("processedMilletEarImages");
    Box<ProcessedImage> processedMilletLeafImagesDatabase = Hive.box<ProcessedImage>("processedMilletLeafImages");
    ProcessedImage image=ProcessedImage(
        imagePath: imagePath,
        diseaseID: diseaseID,
        epochSeconds: DateTime.now().millisecondsSinceEpoch
    );
    if(crop=="tomato")
      processedTomatoImagesDatabase.add(image);
    else if(crop=="millet_ear")
      processedMilletEarImagesDatabase.add(image);
    else if(crop=="millet_leaf")
      processedMilletLeafImagesDatabase.add(image);
  }


  // PREDICT CLASS OF THE DISEASE LOCALLY
  Future<Map<String, String>> predictClass(String imagePath) async {

    // PREDICT CLASS OF DISEASE
    // List? result = await Tflite.runModelOnImage(
    //   path: imagePath,
    //   threshold: 0.5,
    //   imageMean: 127.5,
    //   imageStd: 127.5,
    //   numResults: 2
    // );
    var result = {};
    print(result);

    int index = result![0]["index"];
    String diseaseID;

    // CHECK IF DISEASE IS RELATED TO TOMATO
    if(index < 28)
      diseaseID = "unknown";
    else
      diseaseID = DiseaseIDMap.diseaseIDMap[index];

    return {
      "imagePath": imagePath,
      "prediction": diseaseID
    };
  }


  // PREDICT CLASS OF THE DISEASE ON THE SERVER
  Future<Map<String, dynamic>> predictClassOnline(Uri serverURL, String imagePath, String crop) async {

    print("Server IP Address:" + serverURL.toString());

    // CHECK IF ML SERVER IS UP
    var serverUpResponse = await http.get(serverURL).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        print("Server timeout");
        return http.Response('Error', 408);
      },
    );

    if(serverUpResponse.statusCode == 200) {

      print("Server status: UP");

      // UPLOAD IMAGE TO FIREBASE STORAGE
      String fileURL;

      fileURL = await uploadFile(File(imagePath));
      print(fileURL);
      print("File uploaded");

      //SEND DOWNLOAD LINK TO ML SERVER
      var data = {"image_URL": fileURL,"selected_crop": crop};
      var body = json.encode(data);
      var callUri=serverURL.resolve("/predict_disease");
      var serverPredictionResponse = await http.post(
        callUri,
        headers: {"Content-Type": "application/json"},
        body: body,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          print("Server prediction timeout");
          return http.Response('Service not responding', 408);
        },
      );

      print('Server prediction response status: ${serverPredictionResponse.statusCode}');

      // RESPONSE CONTAINS THE LINK OF THE CLASSIFIED IMAGE
      // USE THE LINK TO DOWNLOAD THE IMAGE AND CHANGE TO THE NEXT ACTIVITY
      Map<String, dynamic> responseData = jsonDecode(serverPredictionResponse.body);
      String prediction = responseData["prediction"];
      print(prediction);

      String outputImageLink = responseData["image_URL"];

      ImageDownloader imageDownloader = ImageDownloader();

      String downloadedImagePath = await imageDownloader.downloadImage(
          DateTime.now().millisecondsSinceEpoch.toString(),
          outputImageLink
      );

      return {
        "statusCode": serverPredictionResponse.statusCode,
        "imagePath": downloadedImagePath,
        "prediction": prediction
      };
    }
    else {
      print('Server response status: ${serverUpResponse.statusCode}');
      print("Server status: DOWN");

      return {"statusCode": serverUpResponse.statusCode};
    }
  }


  // UPLOAD IMAGE TO FIREBASE STORAGE
  Future<String> uploadFile(File file) async {
    var downloadURL;
    try {
      UploadTask uploadTask;

      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      Reference ref = firebaseStorage.ref()
          .child("processed_images")
          .child("${DateTime
          .now()
          .millisecondsSinceEpoch}.jpg");

      uploadTask = ref.putFile(file);


      await uploadTask.whenComplete(() async {
        try {
          downloadURL = await ref.getDownloadURL();
        } catch (onError) {
          print("Error");
        }
      });
    } catch (e) {
      print(e);
    }

    return downloadURL.toString();
  }


  Future<Map> _init(BuildContext context) async {


    //print("here1");

    var arguments = ModalRoute.of(context)!.settings.arguments as Map;
    String imagePath = arguments["filePath"];
    String crop = arguments["crop"];
    String prediction;
    //print(crop);
    //print("here2");
    // CHECK INTERNET CONNECTIVITY
    Connectivity connectivity = Connectivity();
    ConnectivityResult connectivityResult = await connectivity.checkConnectivity();

    // IF THERE IS INTERNET CONNECTION
    // UPLOAD IMAGE TO FIREBASE STORAGE
    if(connectivityResult != ConnectivityResult.none) {
      print("Internet connectivity available");
      // GET ML SERVER LINK FROM FIREBASE RTDB
      DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("new_server_url");
      var serverURLString;
      await dbRef.get().then((snapshot) => serverURLString = snapshot.value);
      var serverURL = Uri.parse(serverURLString);
      // var serverURL = Uri.parse("https://crop-doc-xpg4b2fkjq-el.a.run.app");

      Map<String, dynamic> result = await predictClassOnline(serverURL, imagePath,crop);
      if(result["statusCode"] != 200) {

        print("Server unavailable");

        prediction = "unknown";

      }
      else
        prediction = result["prediction"];
      imagePath = result["imagePath"];
      storeDiseaseInfo(imagePath, prediction,crop);
    }
    else {
      print("No internet connectivity");
      print("Predicting class using local model");

      prediction = "unknown";
    }

    print(imagePath);
    //prediction = "disease 07";
    arguments = {
      "filePath": imagePath,
      "diseaseID": prediction
    };
    Navigator.pushReplacementNamed(context, "/image_details", arguments: arguments);

    LanguageInitializer languageInitializer = LanguageInitializer();
    AppStrings appStrings = await languageInitializer.initLanguage();

    return {"appStrings": appStrings, "imagePath": imagePath};
  }


  Widget _builderFunction(BuildContext context, AsyncSnapshot snapshot) {

    Widget child;

    if(snapshot.hasData) {


      AppStrings appStrings = snapshot.data["appStrings"];
      child = Scaffold(


        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: AppColor.appBarColorLight,
          title: Text(appStrings.examineLeaf),
        ),
        body: Center(
          child: Text(
            "Predicting diseases...",
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        ),
      );
    }
    else
      child = Scaffold(
        body: Center(
          child: Text(
            "Predicting diseases...",
            style: TextStyle(
              fontSize: 17,
            ),
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
