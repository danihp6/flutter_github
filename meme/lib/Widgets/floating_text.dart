import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:meme/Controller/navigator.dart';

List<Color> colors = [
  Colors.black,
  Colors.white,
  Colors.red,
  Colors.yellow,
  Colors.orange,
  Colors.blue,
  Colors.green,
  Colors.pink,
  Colors.purple,
  Colors.lime,
  Colors.brown,
  Colors.teal,
];

class FloatingText extends StatefulWidget {
  Function remove;
  Key key;
  bool isTextOptionsVisible;
  FloatingText({ this.remove, this.key, this.isTextOptionsVisible = true});
  @override
  _FloatingTextState createState() => _FloatingTextState();
}

class _FloatingTextState extends State<FloatingText> {
  Offset textOffset = Offset.zero;
  double scaleFactor = 40.0;
  double baseScaleFactor = 1.0;
  FocusNode focusNode = FocusNode();
  TextEditingController textController = TextEditingController(text: 'Texto');
  GlobalKey<FittedTextFieldContainerState> keyText =
      GlobalKey<FittedTextFieldContainerState>();
  Color textColor = Colors.white;
  bool _isTextOptionsVisible;

  @override
  void dispose() {
    focusNode.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isTextOptionsVisible = widget.isTextOptionsVisible;
    changeColor(Color color) {
      setState(() {
        textColor = color;
      });
    }

    return Positioned(
      left: textOffset.dx,
      top: textOffset.dy,
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: FittedTextFieldContainer(
              key: keyText,
              child: TextField(
                keyboardType: TextInputType.multiline,
                scrollPhysics: NeverScrollableScrollPhysics(),
                maxLines: null,
                textAlign: TextAlign.center,
                controller: textController,
                focusNode: focusNode,
                style: TextStyle(fontSize: scaleFactor, color: textColor),
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  keyText.currentState.resize();
                },
              ),
            ),
            onPanStart: (initialPoint) {
              focusNode.unfocus();
            },
            onPanUpdate: (details) {
              setState(() {
                textOffset = textOffset + details.delta;
              });
            },
          ),
          if (_isTextOptionsVisible)
            Row(
              children: <Widget>[
                if(widget.remove != null)
                GestureDetector(
                  child: SizedBox(
                    width: scaleFactor < 40 ? 20 : scaleFactor * 0.5,
                    child: FittedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Material(
                          color: Colors.white.withOpacity(0.8),
                          elevation: 2,
                          child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Icon(Icons.delete)),
                        ),
                      ),
                    ),
                  ),
                  onTap: () => widget.remove(widget.key),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  child: SizedBox(
                    width: scaleFactor < 40 ? 20 : scaleFactor * 0.5,
                    child: FittedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Material(
                          color: Colors.white.withOpacity(0.8),
                          elevation: 2,
                          child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Icon(Icons.format_size)),
                        ),
                      ),
                    ),
                  ),
                  onPanUpdate: (details) {
                    focusNode.unfocus();

                    if (scaleFactor > 10 || details.delta.dy > 0)
                      setState(() {
                        scaleFactor += details.delta.dy;
                      });
                    keyText.currentState.resize();
                  },
                ),
                SizedBox(
                  width: 5,
                ),
                TextColorButton(
                  scaleFactor: scaleFactor,
                  textColor: textColor,
                  changeColor: changeColor,
                ),
              ],
            )
        ],
      ),
    );
  }
}

class TextColorButton extends StatelessWidget {
  TextColorButton(
      {@required this.scaleFactor,
      @required this.textColor,
      @required this.changeColor});

  double scaleFactor;
  Color textColor;
  Function changeColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        width: scaleFactor < 40 ? 20 : scaleFactor * 0.5,
        child: FittedBox(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Material(
              color: textColor.withOpacity(0.8),
              elevation: 2,
              child:
                  Padding(padding: const EdgeInsets.all(2), child: Container()),
            ),
          ),
        ),
      ),
      onTap: () async {
        Color color = await buildColorsBottomSheet(context);
        print(color);
        if (color != null) changeColor(color);
      },
    );
  }
}

Future<Color> buildColorsBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            itemCount: colors.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => SizedBox(width: 5),
            itemBuilder: (context, index) => GestureDetector(
                child: FittedBox(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Material(
                      color: colors[index],
                      elevation: 2,
                      child: Padding(
                          padding: const EdgeInsets.all(2), child: Container()),
                    ),
                  ),
                ),
                onTap: () {
                  print(colors[index]);
                  navigator.pop(context, colors[index]);
                }),
          ),
        ),
      );
    },
  );
}