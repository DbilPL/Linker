import 'package:equatable/equatable.dart';
import 'package:linker/features/authentication/data/model/user_model.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class InitialAuthenticationState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class LoadingAuthenticationState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class FailureAuthenticationState extends AuthenticationState {
  final String message;

  FailureAuthenticationState(this.message);

  @override
  List<Object> get props => [];
}

class Entered extends AuthenticationState {
  final UserModel userModel;

  Entered(this.userModel);

  @override
  List<Object> get props => [userModel];
}
