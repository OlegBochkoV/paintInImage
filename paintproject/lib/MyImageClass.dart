import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MyImageClass extends StatefulWidget {
  const MyImageClass({Key? key}) : super(key: key);

  @override
  _MyImageClassState createState() => _MyImageClassState();
}

class _MyImageClassState extends State<MyImageClass> {
  late File imageFile;
  bool stateImageChoice = false;
  GlobalKey globalKey = GlobalKey();
  List<TouchPoints> points = [];
  double opacity = 1.0;
  StrokeCap strokeType = StrokeCap.round;
  double strokeWidth = 3.0;
  Color selectedColor = Colors.black;

  Future _openGalery(BuildContext context) async {
    final getMedia = ImagePicker().getImage;
    final media = await getMedia(source: ImageSource.gallery);
    final file = File(media!.path);
    setState(() {
      imageFile = file;
      stateImageChoice = true;
    });
  }

  Future<void> _save() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData byteData =
        await image.toByteData(format: ui.ImageByteFormat.png) as ByteData;
    Uint8List pngBytes = byteData.buffer.asUint8List();

    if (!(await Permission.storage.status.isGranted)) {
      await Permission.storage.request();
    }

    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes),
        quality: 100,
        name: "canvas_image");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(child: Text('Paint in image')),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              _openGalery(context);
            },
            child: const Icon(Icons.image_sharp),
          ),
          const SizedBox(
            height: 5,
          ),
          FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              setState(() {
                _save();
              });
            },
            child: const Icon(Icons.download_sharp),
          ),
          const SizedBox(
            height: 5,
          ),
          FloatingActionButton(
            backgroundColor: Colors.black,
            child: ClipOval(
              child: Container(
                padding: const EdgeInsets.only(bottom: 8.0),
                height: 25,
                width: 25,
                color: Colors.green,
              ),
            ),
            onPressed: () {
              setState(() {
                selectedColor = Colors.green;
              });
            },
          ),
          const SizedBox(
            height: 5,
          ),
          FloatingActionButton(
              backgroundColor: Colors.black,
              child: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  points.clear();
                  opacity = 1.0;
                  strokeType = StrokeCap.round;
                  strokeWidth = 3.0;
                  selectedColor = Colors.black;
                });
              }),
          // const SizedBox(
          //   height: 5,
          // ),
          // //ластик
          // FloatingActionButton(
          //     backgroundColor: Colors.black,
          //     child: const Icon(Icons.cleaning_services_sharp),
          //     onPressed: () {
          //       setState(() {
          //         opacity = 0.1;
          //         strokeType = StrokeCap.round;
          //         strokeWidth = 3.0;
          //         selectedColor = Colors.black;
          //       });
          //     }),
        ],
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            points.add(TouchPoints(
                points: renderBox.globalToLocal(details.localPosition),
                paint: Paint()
                  ..strokeCap = strokeType
                  ..isAntiAlias = true
                  ..color = selectedColor.withOpacity(opacity)
                  ..strokeWidth = strokeWidth));
          });
        },
        onPanStart: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            points.add(TouchPoints(
                points: renderBox.globalToLocal(details.localPosition),
                paint: Paint()
                  ..strokeCap = strokeType
                  ..isAntiAlias = true
                  ..color = selectedColor.withOpacity(opacity)
                  ..strokeWidth = strokeWidth));
          });
        },
        child: Container(
          child: stateImageChoice
              ? RepaintBoundary(
                  key: globalKey,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        imageFile,
                        fit: BoxFit.cover,
                      ),
                      CustomPaint(
                        size: Size.infinite,
                        painter: MyPainter(pointsList: points),
                      )
                    ],
                  ),
                )
              : const Placeholder(),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  MyPainter({required this.pointsList});

  List<TouchPoints> pointsList;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      canvas.drawCircle(pointsList[i].points, 3, pointsList[i].paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class TouchPoints {
  Paint paint;
  Offset points;
  TouchPoints({required this.points, required this.paint});
}
