import 'package:flutter/material.dart';
import 'package:mygameslist_flutter/colors.dart';
import 'package:mygameslist_flutter/styles.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key key,
    @required TextEditingController controller,
    @required this.hintText,
    this.maxLines = 1,
    this.keyBoardType = TextInputType.text,
    this.obscureText = false,
  })  : _emailController = controller,
        super(key: key);

  final TextEditingController _emailController;
  final String hintText;
  final bool obscureText;
  final TextInputType keyBoardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Theme(
        data: Theme.of(context).copyWith(cursorColor: lightAccentColor),
        child: TextField(
          maxLines: maxLines,
          keyboardType: keyBoardType,
          style: TextStyle(fontFamily: "Poppins"),
          obscureText: obscureText,
          controller: _emailController,
          decoration: InputDecoration(
              border: lightGreenBorder,
              hintText: hintText,
              hintStyle: TextStyle(fontFamily: "Poppins")),
        ),
      ),
    );
  }
}
