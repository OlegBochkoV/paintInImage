import 'package:flutter/material.dart';
import 'package:paintproject/ColorClass.dart';

class BottomItem {
  IconData icon;
  String text;
  BottomItem(this.icon, this.text);
}

class MenuWidget extends StatefulWidget {
  List<BottomItem> menuBottom;
  ClassColor colorSelected;
  MenuWidget({Key? key, required this.menuBottom, required this.colorSelected})
      : super(key: key);

  @override
  MenuWidget1 createState() => MenuWidget1();
}

class MenuWidget1 extends State<MenuWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.menuBottom
            .map((data) => MenuBottom(
                  bottomItem: data,
                  classColor: widget.colorSelected,
                ))
            .toList(),
      ),
    );
  }
}

class MenuBottom extends StatefulWidget {
  BottomItem bottomItem;
  ClassColor classColor;
  MenuBottom({Key? key, required this.bottomItem, required this.classColor})
      : super(key: key);
  @override
  MenuButtonSecond createState() => MenuButtonSecond();
}

class MenuButtonSecond extends State<MenuBottom> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          if (widget.bottomItem.text.contains('Color')) {
            setState(() {
              showMyDialog(context, widget.classColor);
            });
          }
        },
        child: Column(
          children: [
            Icon(widget.bottomItem.icon),
            const SizedBox(height: 5),
            Text(widget.bottomItem.text),
          ],
        ),
      ),
    );
  }

  showMyDialog(BuildContext context, ClassColor selectColor) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: SizedBox(
            height: 440,
            child: StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Container(
                      height: 60,
                      color: Colors.black,
                      child: const Center(
                          child: Text(
                        "Select color",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 22),
                      ))),
                  content: Center(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text('R',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20)),
                            Expanded(
                              child: SliderTheme(
                                data: const SliderThemeData(
                                    inactiveTrackColor: Colors.red,
                                    thumbColor: Colors.red,
                                    activeTrackColor: Colors.red),
                                child: Slider(
                                  value: selectColor.r.toDouble(),
                                  min: 0,
                                  max: 255,
                                  onChanged: (current) {
                                    setState(() {
                                      selectColor.r = current.toInt();
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                                width: 27,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text('${selectColor.r.toInt()}')))
                          ],
                        ),
                        Row(
                          children: [
                            const Text('G',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20)),
                            Expanded(
                              child: SliderTheme(
                                data: const SliderThemeData(
                                    inactiveTrackColor: Colors.green,
                                    thumbColor: Colors.green,
                                    activeTrackColor: Colors.green),
                                child: Slider(
                                  value: selectColor.g.toDouble(),
                                  min: 0,
                                  max: 255,
                                  onChanged: (current) {
                                    setState(() {
                                      selectColor.g = current.toInt();
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                                width: 27,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text('${selectColor.g.toInt()}')))
                          ],
                        ),
                        Row(
                          children: [
                            const Text('B',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20)),
                            Expanded(
                              child: SliderTheme(
                                data: const SliderThemeData(
                                    inactiveTrackColor: Colors.blue,
                                    thumbColor: Colors.blue,
                                    activeTrackColor: Colors.blue),
                                child: Slider(
                                  value: selectColor.b.toDouble(),
                                  min: 0,
                                  max: 255,
                                  onChanged: (current) {
                                    setState(() {
                                      selectColor.b = current.toInt();
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                                width: 27,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text('${selectColor.b.toInt()}')))
                          ],
                        ),
                        ClipOval(
                          child: Container(
                            color: Color.fromRGBO(widget.classColor.r,
                                widget.classColor.g, widget.classColor.b, 1),
                            height: 55,
                            width: 55,
                          ),
                        )
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Center(
                      child: SizedBox(
                        height: 45,
                        width: 100,
                        child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.black),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Apply",
                              style: TextStyle(fontSize: 18),
                            )),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
