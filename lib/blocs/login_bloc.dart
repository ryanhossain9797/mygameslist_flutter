import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygameslist_flutter/api/api.dart';
import 'package:mygameslist_flutter/models/login_result_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

//--------------------Events
class LoginEvent {}

class LoginLoginEvent extends LoginEvent {
  final String email;
  final String password;
  LoginLoginEvent({this.email, this.password});
}

class LogoutLoginEvent extends LoginEvent {}

//--------------------States
class LoginState {}

class LoggedInLoginState extends LoginState {
  final String username;
  final String email;
  LoggedInLoginState({this.username, this.email});
}

class LoggedOutLoginState extends LoginState {
  final String message;
  LoggedOutLoginState(this.message);
}

//--------------------Bloc
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  @override
  LoginState get initialState =>
      LoggedOutLoginState("Enter email and password");

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginLoginEvent) {
      LogInResult result = await ApiHelper.logInWithEmailPass(
        email: event.email,
        password: event.password,
      );
      if (result.success) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", result.token);
        yield LoggedInLoginState(
          username: result.username,
          email: result.email,
        );
      } else {
        yield LoggedOutLoginState("failed");
      }
    } else if (event is LogoutLoginEvent) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("token");
      yield LoggedOutLoginState("Enter email and password");
    }
  }
}
