import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygameslist_flutter/api/api.dart';

//--------------------Events
class SignupEvent {}

class SignupSignupEvent extends SignupEvent {
  final String username;
  final String email;
  final String password;
  SignupSignupEvent({this.username, this.email, this.password});
}

//--------------------States
class SignupState {}

class SignupSuccessfulSignupState extends SignupState {
  final String username;
  SignupSuccessfulSignupState(this.username);
}

class SignupFailedSignupState extends SignupState {}

//--------------------Bloc
class SignupBloc extends Bloc<SignupEvent, SignupState> {
  @override
  SignupState get initialState => SignupFailedSignupState();

  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    if (event is SignupSignupEvent) {
      bool success = await ApiHelper.signUpWithEmailPass(
          email: event.email,
          password: event.password,
          username: event.username);
      yield success
          ? SignupSuccessfulSignupState(event.username)
          : SignupFailedSignupState();
    }
  }
}
