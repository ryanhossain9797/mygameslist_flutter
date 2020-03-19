import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_button.dart';

typedef LargeButtonPress();

class LargeButton extends StatelessWidget {
  const LargeButton({Key key, this.onPress, this.text}) : super(key: key);
  final LargeButtonPress onPress;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GFButton(
      size: 50,
      color: Colors.lightGreenAccent,
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.grey[800]),
        ),
      ),
      //---------------Go to Authentication Screen
      onPressed: () {
        onPress();
      },
    );
  }
}
