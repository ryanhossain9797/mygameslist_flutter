//-----------------------------------------------THIS IS ONLY A PLACEHOLDER
//-----------------------------------------------UNTIL A REAL AUTH SYSTEM IS COMPLETED

import 'package:flutter_bloc/flutter_bloc.dart';

//--------------------Events
class AuthEventFake {}

class SignInAuthEventFake extends AuthEventFake {
  final String username;
  SignInAuthEventFake(this.username);
}

class SignOutAuthEventFake extends AuthEventFake {}

class SignUpAuthEventFake extends AuthEventFake {
  final String username;
  SignUpAuthEventFake(this.username);
}

//--------------------States
class AuthStateFake {}

class SignedInAuthStateFake extends AuthStateFake {
  final String username;
  SignedInAuthStateFake(this.username);
}

class SignedOutAuthStateFake extends AuthStateFake {}

//--------------------Bloc
class AuthBlocFake extends Bloc<AuthEventFake, AuthStateFake> {
  @override
  AuthStateFake get initialState => SignedOutAuthStateFake();

  @override
  Stream<AuthStateFake> mapEventToState(AuthEventFake event) async* {
    if (event is SignInAuthEventFake) {
      yield SignedInAuthStateFake(event.username);
    } else if (event is SignUpAuthEventFake) {
      yield SignedInAuthStateFake(event.username);
    } else {
      yield SignedOutAuthStateFake();
    }
  }
}
