import 'package:flutter_bloc/flutter_bloc.dart';

//--------------------Events
class AuthEvent {}

class SignInAuthEvent extends AuthEvent {
  final String username;
  SignInAuthEvent(this.username);
}

class SignOutAuthEvent extends AuthEvent {}

class SignUpAuthEvent extends AuthEvent {
  final String username;
  SignUpAuthEvent(this.username);
}

//--------------------States
class AuthState {}

class SignedInAuthState extends AuthState {
  final String username;
  SignedInAuthState(this.username);
}

class SignedOutAuthState extends AuthState {}

//--------------------Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  @override
  AuthState get initialState => SignedOutAuthState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is SignInAuthEvent) {
      yield SignedInAuthState(event.username);
    } else if (event is SignUpAuthEvent) {
      yield SignedInAuthState(event.username);
    } else {
      yield SignedOutAuthState();
    }
  }
}
