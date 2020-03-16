import 'package:flutter/material.dart';
import 'package:mygameslist_flutter/styles.dart';

class AuthInputField extends StatelessWidget {
  const AuthInputField(
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
      padding: const EdgeInsets.all(10),
      child: TextField(
        obscureText: obscureText,
        controller: _emailController,
        decoration:
            InputDecoration(border: lightGreenBorder, hintText: hintText),
      ),
    );
  }
}
