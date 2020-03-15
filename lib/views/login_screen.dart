import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygameslist_flutter/api/api.dart';
import 'package:mygameslist_flutter/blocs/signup_bloc.dart';
import 'package:mygameslist_flutter/blocs/signup_bloc.dart';
import 'package:mygameslist_flutter/colors.dart';
import 'package:mygameslist_flutter/styles.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  trySignup({
    @required String email,
    @required String username,
    @required String password,
  }) async {
    print("$email $password $username");
    BlocProvider.of<SignupBloc>(context).add(SignupSignupEvent(
        email: email, username: username, password: password));
  }

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login Screen",
          style: boldGreenText,
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            BlocBuilder<SignupBloc, SignupState>(
              builder: (context, state) {
                return Text(state is SignupSuccessfulSignupState
                    ? state.username
                    : "Fail");
              },
            ),
            TextField(
              controller: _emailController,
              decoration:
                  InputDecoration(border: lightGreenBorder, hintText: "email"),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                  border: lightGreenBorder, hintText: "username"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                  border: lightGreenBorder, hintText: "password"),
            ),
            RawMaterialButton(
              child: Text("Submit"),
              onPressed: () {
                trySignup(
                  email: _emailController.text,
                  username: _usernameController.text,
                  password: _passwordController.text,
                );
              },
            ),
            SizedBox(height: 100),
            Text("Sign up"),
            TextField(
              decoration:
                  InputDecoration(border: lightGreenBorder, hintText: "email"),
            ),
            TextField(
              decoration: InputDecoration(
                  border: lightGreenBorder, hintText: "password"),
            ),
          ],
        ),
      ),
    );
  }
}
