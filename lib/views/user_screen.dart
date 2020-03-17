import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:mygameslist_flutter/blocs/login_bloc.dart';
import 'package:mygameslist_flutter/colors.dart';
import 'package:mygameslist_flutter/styles.dart';
import 'package:mygameslist_flutter/views/login_screen.dart';
import 'package:page_transition/page_transition.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (!(state is LoggedInLoginState)) {
          Navigator.pushReplacement(
            context,
            PageTransition(child: LoginScreen(), type: PageTransitionType.fade),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: Center(
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoggedInLoginState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.username, style: boldGreenText),
                      GFButton(
                        onPressed: () {
                          BlocProvider.of<LoginBloc>(context).add(
                            LogoutLoginEvent(),
                          );
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              child: LoginScreen(),
                              type: PageTransitionType.fade,
                            ),
                          );
                        },
                        child: Text("logout"),
                      )
                    ],
                  );
                } else {
                  return Icon(
                    Icons.warning,
                    color: dangerWarningColor,
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
