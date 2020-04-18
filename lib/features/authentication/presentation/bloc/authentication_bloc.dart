import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:linker/features/authentication/domain/usecases/register.dart';
import 'package:linker/features/authentication/domain/usecases/sign_in_auto.dart';
import 'package:linker/features/authentication/domain/usecases/sign_out.dart';

import './bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final Register register;

  final SignInAuto signInAuto;

  AuthenticationBloc(this.register, this.signInAuto);

  @override
  AuthenticationState get initialState => InitialAuthenticationState();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is RegisterEvent) {}
    if (event is AutoRegister) {
      final result = await signInAuto(NoParams());

      yield result.fold((failure) {
        return FailureAuthenticationState();
      }, (user) {
        return Entered(user);
      });
    }
  }
}
