import 'package:flutter/material.dart';

class PracticeScreen extends StatefulWidget {
  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  double _top = 20;
  double _bottom = null;
  double _left = 20;
  double _right = null;

  @override
  Widget build(BuildContext context) {
    GlobalKey textKey = new GlobalKey();
    GlobalKey bottomLeft = new GlobalKey();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Practice Screen",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              color: Colors.red,
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              key: textKey,
              child: Text("Hellow"),
              top: _top,
              bottom: _bottom,
              left: _left,
              right: _right,
            ),
            Positioned(
              left: 20,
              bottom: 20,
              key: bottomLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  print("pressed");
                  RenderBox button =
                      bottomLeft.currentContext.findRenderObject();

                  print(button.localToGlobal(Offset.zero).dx);
                  print(button.localToGlobal(Offset.zero).dx);
                  setState(() {
                    _left = button.localToGlobal(Offset.zero).dx;
                    _bottom = button.localToGlobal(Offset.zero).dy;
                    _top = null;
                    _bottom = null;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
