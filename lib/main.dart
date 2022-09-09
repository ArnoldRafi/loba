import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'functions/get_image_from_gallery.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'PaySky text detection'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title = ""}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;
  File? image;
  List<String> collectedTextValues=[];
  List<Rect> rectArr = [];
  var bytesFromImageFile;
  ui.Image? imageForUi;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            InkWell(
                onTap: () async {
                  image = await getImage();
                },
                child: Icon(
                  Icons.camera_alt,
                  size: 30,
                )),
            imageForUi!=null? FittedBox(
              child: Container(
                color: Colors.green,
                height: imageForUi == null ? 100 : imageForUi!.height.toDouble(),
                width: imageForUi == null ? 100 : imageForUi!.width.toDouble(),
                child: CustomPaint(
                  painter: Painter(rectArr, imageForUi!),
                ),
              ),
            ):Container(),
            ListView.builder(
              shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: collectedTextValues.length,
                itemBuilder: (context,index){
              return  Text(
                collectedTextValues[index],
              );
            })
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headline4,
            // ),
          ],
        ),
      ),
      // floatingActionButton: Ic, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  getImage() async {
    image = await GetImage();
    await findText(image!);
    await findImage(image!);
  }

  findText(File image) async {
    InputImage inputImage = InputImage.fromFile(image);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;
    collectedTextValues.clear();
    for (TextBlock block in recognizedText.blocks) {
      // final Rect rect = block.rect;
      // final List<Offset> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        collectedTextValues.add(line.text);
        for (TextElement element in line.elements) {
          // Same getters as TextBlock
        }
      }
    }
    setState((){});
    textRecognizer.close();
  }

  findImage(File image) async {
    final options = FaceDetectorOptions();
    final faceDetector = FaceDetector(options: options);
    final List<Face> faces =
        await faceDetector.processImage(InputImage.fromFile(image));
    print("this isthe face found");
    print(faces.length);
     bytesFromImageFile = image.readAsBytesSync();
    decodeImageFromList(bytesFromImageFile).then((img) {
      setState(() {
        imageForUi = img;
      });
    });
    // imageForUi=copyCrop(Image src, int x, int y, int w, int h);
    // File image=faces[0];
    for (Face face in faces) {
      final Rect boundingBox = face.boundingBox;
      // boundingBox.
      // final double rotX =
      //     face.headEulerAngleX!; // Head is tilted up and down rotX degrees
      // final double rotY =
      //     face.headEulerAngleY!; // Head is rotated to the right rotY degrees
      // final double rotZ =
      //     face.headEulerAngleZ!; // Head is tilted sideways rotZ degrees

      // If landmark detection was enabled with FaceDetectorOptions (mouth, ears,
      // eyes, cheeks, and nose available):
      // final FaceLandmark leftEar = face.landmarks[FaceLandmarkType.leftEar]!;
      rectArr.add(boundingBox);
      // if (leftEar != null) {
      //   final Point<double> leftEarPos = leftEar.position as Point<double>;
      // }
      //
      // // If classification was enabled with FaceDetectorOptions:
      // if (face.smilingProbability != null) {
      //   final double? smileProb = face.smilingProbability;
      // }
      //
      // // If face tracking was enabled with FaceDetectorOptions:
      // if (face.trackingId != null) {
      //   final int? id = face.trackingId;
      // }
    }
    faceDetector.close();
    setState((){});
  }
}
class Painter extends CustomPainter {
  Painter(@required this.rect, @required this.image);

  final List<Rect> rect;
  ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7;

    if (image != null) {
      canvas.drawImage(image, Offset.zero, paint);
    }
    for (var i = 0; i <= rect.length - 1; i++) {
      canvas.drawRect(rect[i], paint);
    }
  }

  @override
  bool shouldRepaint(oldDelegate) {
    return true;
  }
}