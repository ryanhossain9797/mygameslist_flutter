import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygameslist_flutter/blocs/auth_bloc.dart';
import 'package:mygameslist_flutter/components/side_drawer.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text(
          "Login",
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
                BlocProvider.of<AuthBloc>(context)
                    .add(SignInAuthEvent(_controller.text));
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
