import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygameslist_flutter/api/api.dart';
import 'package:mygameslist_flutter/models/login_result_model.dart';

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
  LoggedInLoginState(this.username);
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
        //TODO save result.token
        yield LoggedInLoginState(result.message);
      } else {
        yield LoggedOutLoginState("failed");
      }
    } else if (event is LogoutLoginEvent) {
      yield LoggedOutLoginState("Enter email and password");
    }
  }
}
