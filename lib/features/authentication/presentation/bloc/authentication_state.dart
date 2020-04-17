import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class InitialAuthenticationState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class Entered extends AuthenticationState {
  final String uid;

  Entered(this.uid);

  @override
  List<Object> get props => [];
}
