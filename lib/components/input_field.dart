import 'package:flutter/material.dart';
import 'package:mygameslist_flutter/styles.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key key,
      @required TextEditingController controller,
      @required this.hintText,
      this.obscureText = false})
      : _emailController = controller,
        super(key: key);

  final TextEditingController _emailController;
  final String hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        style: TextStyle(fontFamily: "Poppins"),
        obscureText: obscureText,
        controller: _emailController,
        decoration: InputDecoration(
            border: lightGreenBorder,
            hintText: hintText,
            hintStyle: TextStyle(fontFamily: "Poppins")),
      ),
    );
  }
}
