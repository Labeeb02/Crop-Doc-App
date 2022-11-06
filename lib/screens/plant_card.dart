 import 'dart:io';

import 'package:crop_doctor/classes/plant_info.dart';
import 'package:flutter/material.dart';

class PlantCard extends StatelessWidget {

  final PlantInfo plantInfo;
  final String languageID;

  PlantCard(this.plantInfo, this.languageID);

  @override
  Widget build(BuildContext context) {

    String plantName;
    String plantType;

    if(languageID == "EN") {
      plantName = plantInfo.plantNameEN;
      plantType = plantInfo.plantTypeEN;
    }
    else {
      plantName = plantInfo.plantNameHI;
      plantType = plantInfo.plantTypeHI;
    }

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/plant_diseases",
          arguments: {
            "plantID": plantInfo.plantID
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
                  image: FileImage(File(plantInfo.plantImagePath)),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 18, right: 12, top: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  plantName,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 18, right: 12, top: 6, bottom: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  plantType,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
