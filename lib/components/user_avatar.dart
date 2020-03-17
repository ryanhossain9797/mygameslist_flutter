import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygameslist_flutter/blocs/login_bloc.dart';
import 'package:mygameslist_flutter/styles.dart';
import 'package:mygameslist_flutter/views/login_screen.dart';
import 'package:mygameslist_flutter/views/user_screen.dart';
import 'package:page_transition/page_transition.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoggedInLoginState) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: UserScreen(),
                    type: PageTransitionType.fade,
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.lightGreenAccent,
                child: Text(
                  state.username.toUpperCase().substring(0, 1),
                  style: darkGreyText.copyWith(fontSize: 24),
                ),
              ),
            );
          } else {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: LoginScreen(),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.lightGreenAccent,
                child: Icon(
                  Icons.person,
                  color: Colors.grey[800],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
