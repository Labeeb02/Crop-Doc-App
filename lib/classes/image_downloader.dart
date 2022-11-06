import 'dart:io';

import 'package:dio/dio.dart';

import 'package:path_provider/path_provider.dart';

class ImageDownloader {


  Future<String> downloadImage(String fileName, String imageLink) async {

    final appDirectory = await getApplicationDocumentsDirectory();

    bool fileExists = await File("${appDirectory.path}/$fileName.jpg").exists();
    String imageDirectory = "${appDirectory.path}/$fileName.jpg";

    // IF PLANT IMAGE IS DOWNLOADED, NO NEED TO DOWNLOAD IMAGE
    // OTHERWISE DOWNLOAD IMAGE AND STORE ITS PATH IN THE DB
    if(!fileExists) {

      File imageFile = File(imageDirectory);

      var response = await Dio().get(
          imageLink,
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

    return imageDirectory;
  }
}