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

  final _cardWidgetKey = GlobalKey();
  double? heightImage;
  double? widthImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[100],
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Center(child: Text('Paint in image')),
        ),
        body: choice
            ? Center(
                child: Card(
                  key: _cardWidgetKey,
                  child: GestureDetector(
                    child: imageClassView(),
                    onPanStart: (details) async {
                      await paintStart(details);
                    },
                    onPanUpdate: (details) async {
                      await paintUpdate(details);
                    },
                  ),
                ),
              )
            : const Placeholder(
                color: Colors.blueGrey,
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
      for (int i = 10; i > 0; i--) {
        libImage.drawCircle(
            image,
            400,
            400,
            i,
            libImage.getColor(
                colorSelected.r, colorSelected.g, colorSelected.b));
      }
    });
  }

  Widget imageClassView() {
    Uint8List bytes = Uint8List.fromList(libImage.encodePng(image));
    return Image.memory(
      bytes,
    );
  }

  Future<void> paintStart(DragStartDetails details) async {
    heightImage = _cardWidgetKey.currentContext?.size?.height;
    widthImage = _cardWidgetKey.currentContext?.size?.width;
    final x = (details.localPosition.dx * image.width) ~/ widthImage!;
    final y = (details.localPosition.dy * image.height) ~/ heightImage!;
    for (int i = 10; i > 0; i--) {
      libImage.drawCircle(image, x, y, i,
          libImage.getColor(colorSelected.r, colorSelected.g, colorSelected.b));
    }
    setState(() {
      image;
    });
  }

  Future<void> paintUpdate(DragUpdateDetails details) async {
    final x = (details.localPosition.dx * image.width) ~/ widthImage!;
    final y = (details.localPosition.dy * image.height) ~/ heightImage!;
    for (int i = 10; i > 0; i--) {
      libImage.drawCircle(image, x, y, i,
          libImage.getColor(colorSelected.r, colorSelected.g, colorSelected.b));
    }
    setState(() {
      image;
    });
  }
}
