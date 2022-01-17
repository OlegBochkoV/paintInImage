import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as libImage;
import 'package:image_picker/image_picker.dart';
import 'package:paintproject/BottomMenu.dart';
import 'package:paintproject/ColorClass.dart';

class SecondFile extends StatefulWidget {
  const SecondFile({Key? key}) : super(key: key);

  @override
  _MyImage createState() => _MyImage();
}

class _MyImage extends State<SecondFile> {
  List<BottomItem> bottomMenuValue = [
    BottomItem(Icons.color_lens_outlined, 'Color'),
    // BottomItem(Icons.text_fields_outlined, 'Label'),
    // BottomItem(Icons.cleaning_services_outlined, 'Erase'),
  ];

  ClassColor colorSelected = ClassColor(r: 0, g: 0, b: 0);

  bool choice = false;
  late libImage.Image image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[100],
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
                _openGalery();
                choice = true;
              },
              child: const Icon(Icons.image_sharp),
            ),
          ],
        ),
        body: choice
            ? GestureDetector(
                child: imageClassView(),
                onPanStart: (details) async {
                  await paintStart(details);
                },
                onPanUpdate: (details) async {
                  await paintUpdate(details);
                },
              )
            : const Placeholder(
                color: Colors.blueGrey,
              ),
        bottomNavigationBar: Container(
          height: 70,
          color: Colors.white,
          child: MenuWidget(
            menuBottom: bottomMenuValue,
            colorSelected: colorSelected,
          ),
        ));
  }

  Future _openGalery() async {
    PickedFile media =
        (await ImagePicker().getImage(source: ImageSource.gallery))!;
    setState(() {
      image = libImage.decodeImage(File(media.path).readAsBytesSync())!;
    });
  }

  Widget imageClassView() {
    Uint8List bytes = Uint8List.fromList(libImage.encodeJpg(image));
    return Center(
      child: Card(
        child: Image.memory(
          bytes,
        ),
      ),
    );
  }

  Future<void> paintStart(DragStartDetails details) async {
    for (int i = 10; i > 0; i--) {
      image = libImage.drawCircle(
          image,
          details.localPosition.dx.toInt(),
          details.localPosition.dy.toInt(),
          i,
          libImage.getColor(colorSelected.r, colorSelected.g, colorSelected.b));
    }
    setState(() {
      image;
    });
  }

  Future<void> paintUpdate(DragUpdateDetails details) async {
    for (int i = 10; i > 0; i--) {
      image = libImage.drawCircle(
          image,
          details.localPosition.dx.toInt(),
          details.localPosition.dy.toInt(),
          i,
          libImage.getColor(colorSelected.r, colorSelected.g, colorSelected.b));
    }
    setState(() {
      image;
    });
  }
}
