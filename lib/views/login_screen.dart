import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:mygameslist_flutter/api/api.dart';
import 'package:mygameslist_flutter/blocs/login_bloc.dart';
import 'package:mygameslist_flutter/blocs/signup_bloc.dart';
import 'package:mygameslist_flutter/blocs/signup_bloc.dart';
import 'package:mygameslist_flutter/colors.dart';
import 'package:mygameslist_flutter/components/input_field.dart';
import 'package:mygameslist_flutter/styles.dart';
import 'package:mygameslist_flutter/views/home_screen.dart';
import 'package:page_transition/page_transition.dart';

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

  tryLogin({
    @required String email,
    @required String password,
  }) async {
    BlocProvider.of<LoginBloc>(context)
        .add(LoginLoginEvent(email: email, password: password));
  }

  TextEditingController _signupEmailController = TextEditingController();
  TextEditingController _signupPasswordController = TextEditingController();
  TextEditingController _signupUsernameController = TextEditingController();

  TextEditingController _loginEmailController = TextEditingController();
  TextEditingController _loginPasswordController = TextEditingController();
  bool loginScreen = true;
  var loginKey = Key("loginKey");
  var signupKey = Key("signupKey");
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoggedInLoginState) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            loginScreen ? "Login Screen" : "Signup Screen",
            style: appBarText,
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: Padding(
                key: loginScreen ? loginKey : signupKey,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Builder(
                  builder: (context) {
                    return loginScreen
                        ? Column(
                            children: [
                              BlocBuilder<LoginBloc, LoginState>(
                                builder: (context, state) {
                                  if (state is LoggedInLoginState) {
                                    return Text(
                                      state.username,
                                      style:
                                          boldGreenText.copyWith(fontSize: 20),
                                    );
                                  } else if (state is LoggedOutLoginState) {
                                    return Text(
                                      state.message,
                                      style:
                                          boldGreenText.copyWith(fontSize: 20),
                                    );
                                  }
                                  return Text(
                                    "meh",
                                    style: boldGreenText.copyWith(fontSize: 20),
                                  );
                                },
                              ),
                              InputField(
                                  controller: _loginEmailController,
                                  hintText: "email"),
                              InputField(
                                  obscureText: true,
                                  controller: _loginPasswordController,
                                  hintText: "password"),
                              GFButton(
                                color: lightAccentColor,
                                textColor: darkGreyColor,
                                child: Text("Submit"),
                                onPressed: () {
                                  tryLogin(
                                    email: _loginEmailController.text,
                                    password: _loginPasswordController.text,
                                  );
                                  _loginEmailController.clear();
                                  _loginPasswordController.clear();
                                },
                              ),
                              RawMaterialButton(
                                child: Text(
                                  "New here? Sign Up",
                                  style: boldGreenText.copyWith(fontSize: 18),
                                ),
                                onPressed: () {
                                  setState(() {
                                    loginScreen = false;
                                  });
                                },
                              ),
                            ],
                          )
                        //----------------------------------Signup Screen
                        : Column(
                            children: <Widget>[
                              BlocBuilder<SignupBloc, SignupState>(
                                builder: (context, state) {
                                  return Text(
                                    state is SignupSuccessfulSignupState
                                        ? state.username
                                        : "Sign Up",
                                    style: boldGreenText.copyWith(fontSize: 20),
                                  );
                                },
                              ),
                              InputField(
                                  controller: _signupEmailController,
                                  hintText: "email"),
                              InputField(
                                  controller: _signupUsernameController,
                                  hintText: "username"),
                              InputField(
                                  obscureText: true,
                                  controller: _signupPasswordController,
                                  hintText: "password"),
                              GFButton(
                                color: lightAccentColor,
                                textColor: darkGreyColor,
                                child: Text("Submit"),
                                onPressed: () {
                                  trySignup(
                                    email: _signupEmailController.text,
                                    username: _signupUsernameController.text,
                                    password: _signupPasswordController.text,
                                  );
                                  _signupEmailController.clear();
                                  _signupPasswordController.clear();
                                  _signupUsernameController.clear();
                                },
                              ),
                              RawMaterialButton(
                                child: Text(
                                  "Already have an account? Log In",
                                  style: boldGreenText.copyWith(fontSize: 18),
                                ),
                                onPressed: () {
                                  setState(() {
                                    loginScreen = true;
                                  });
                                },
                              ),
                            ],
                          );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
