import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygameslist_flutter/blocs/auth_bloc_fake.dart';
import 'package:mygameslist_flutter/colors.dart';
import 'package:mygameslist_flutter/components/side_drawer.dart';
import 'package:mygameslist_flutter/styles.dart';
import 'package:page_transition/page_transition.dart';

import 'login_screen.dart';

class LoginScreenFake extends StatefulWidget {
  @override
  _LoginScreenFakeState createState() => _LoginScreenFakeState();
}

class _LoginScreenFakeState extends State<LoginScreenFake> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text(
          "Login Fake",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "THIS SCREEN IS A FAKE PLACEHOLDER",
                style: TextStyle(color: Colors.red),
              )),
          Icon(
            Icons.person,
            size: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "username",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: IconButton(
              icon: Icon(Icons.person_add),
              onPressed: () {
                BlocProvider.of<AuthBlocFake>(context)
                    .add(SignInAuthEventFake(_controller.text));
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: RawMaterialButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Signup",
                  style: darkGreyText,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: LoginScreen(),
                  ),
                );
              },
              fillColor: lightAccentColor,
            ),
          )
        ],
      ),
    );
  }
}
