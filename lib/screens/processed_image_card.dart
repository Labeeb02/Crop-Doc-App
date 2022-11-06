import 'dart:io';

import 'package:crop_doctor/classes/disease_info.dart';
import 'package:crop_doctor/classes/processed_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProcessedImageCard extends StatelessWidget {

  final ProcessedImage processedImage;
  final DiseaseInfo diseaseInfo;
  final String languageID;

  ProcessedImageCard(this.processedImage, this.diseaseInfo, this.languageID);

  @override
  Widget build(BuildContext context) {

    String diseaseName;

    if(languageID == "EN") {
      diseaseName = diseaseInfo.diseaseNameEN;
    }
    else {
      diseaseName = diseaseInfo.diseaseNameHI;
    }

    return InkWell(
      onTap: () async {
        var arguments = {
          "filePath": processedImage.imagePath,
          "diseaseID": processedImage.diseaseID,
        };

        await Navigator.pushNamed(context, "/image_details", arguments: arguments);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.grey.withOpacity(0.4),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Padding(
                padding: const EdgeInsets.all(18),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FadeInImage(
                    height: 300,
                    width: double.infinity,
                    placeholder: AssetImage("assets/placeholder_image.png"),
                    image: FileImage(File(processedImage.imagePath)),
                    fit: BoxFit.fitWidth,
                  ),
                )
            ),

            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 12.0, bottom: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  diseaseName,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 12.0, bottom: 12.0),
              child: Row(
                children: [

                  Text(
                      "Date and Time:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17
                      )
                  ),

                  SizedBox(width: 10),

                  Text(
                    DateFormat.yMMMd().add_jm().format(
                        DateTime.fromMillisecondsSinceEpoch(
                            processedImage.epochSeconds
                        )).toString(),
                    style: TextStyle(
                        fontSize: 17
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
