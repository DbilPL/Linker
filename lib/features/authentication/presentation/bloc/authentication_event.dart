import 'package:equatable/equatable.dart';
import 'package:linker/features/authentication/data/model/user_model.dart';

abstract class AuthenticationEvent extends Equatable {
  List<Object> get props => [];
}

class RegisterEvent extends AuthenticationEvent {
  final String password;
  final String email;
  final String name;

  RegisterEvent(this.name, this.email, this.password);

  List<Object> get props => [password, email, name];
}

class SignInEvent extends AuthenticationEvent {
  final String password;
  final String email;

  SignInEvent(this.email, this.password);

  List<Object> get props => [password, email];
}

class AutoSignIn extends AuthenticationEvent {}

class SignOutEvent extends AuthenticationEvent {
  final UserModel prevUser;

  SignOutEvent(this.prevUser);
}
