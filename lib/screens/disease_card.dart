import 'dart:io';

import 'package:crop_doctor/classes/disease_info.dart';
import 'package:flutter/material.dart';

class DiseaseCard extends StatelessWidget {

  final DiseaseInfo disease;
  final String languageID;
  final String imagePath;

  DiseaseCard(this.disease, this.languageID, this.imagePath);

  @override
  Widget build(BuildContext context) {

    String diseaseName;

    if(languageID == "EN") {
      diseaseName = disease.diseaseNameEN;
    }
    else {
      diseaseName = disease.diseaseNameHI;
    }

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
            "/disease_description",
            arguments: {
            "diseaseID": disease.diseaseID
          }
        );
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
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FadeInImage(
                  height: 200,
                  width: double.infinity,
                  placeholder: AssetImage("assets/placeholder_image.png"),
                  image: FileImage(
                    File(imagePath)
                  ),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  diseaseName,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
