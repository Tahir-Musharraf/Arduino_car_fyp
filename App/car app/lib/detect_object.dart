import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';


class DetectObject extends StatefulWidget {
  File file;
  DetectObject({Key? key,required this.file}) : super(key: key);

  @override
  State<DetectObject> createState() => _DetectObjectState();
}

class _DetectObjectState extends State<DetectObject> {

  List<Widget> list=[];

  @override
  void initState() {
    super.initState();
    processImage();
  }


  Future<void> processImage() async {
    final InputImage visionImage = InputImage.fromFile(widget.file);
    final ObjectDetector objectDetector = ObjectDetector(options: ObjectDetectorOptions(mode:DetectionMode.singleImage,multipleObjects: true,classifyObjects: true));
     await objectDetector.processImage(visionImage).then((_objects) {

      for(DetectedObject detectedObject in _objects){
        final rect = detectedObject.boundingBox;
        final trackingId = detectedObject.trackingId;

        for(Label label in detectedObject.labels){

          list.add(ListTile(
            title: Text("Category: ${label.text}"),
            subtitle: Text("Bounds: ${rect}"),
            trailing:  Text("Confidence: ${label.confidence}"),
          ));
         // print('${label.text} ${label.confidence}');
        }
      }
      objectDetector.close();
      setState(() {

      });
    });

  }

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Result"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.file(widget.file,width: size.width,height: size.height/2,),
              Column(
                children: list.isEmpty? [const CircularProgressIndicator()]: list,
              ),
            ],
          ),
        ),
      ),

    );
  }



}
