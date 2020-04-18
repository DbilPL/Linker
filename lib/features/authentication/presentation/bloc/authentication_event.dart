import 'package:equatable/equatable.dart';

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

class AutoRegister extends AuthenticationEvent {}
