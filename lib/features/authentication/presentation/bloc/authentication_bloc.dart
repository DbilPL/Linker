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
    yield LoadingAuthenticationState();

    final RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    final RegExp spaces = RegExp(r"\s+\b|\b\s");

    if (event is SignInEvent) {
      final email = event.email.replaceAll(spaces, '');
      final password = event.password.replaceAll(spaces, '');

      if (emailRegExp.hasMatch(email)) {
        if (password.length > 6) {
        } else
          yield FailureAuthenticationState('Email isn\'t valid!');
      } else
        yield FailureAuthenticationState('Email isn\'t valid!');
    }
    if (event is RegisterEvent) {
      final name = event.name.replaceAll(spaces, '');
      final email = event.email.replaceAll(spaces, '');
      final password = event.password.replaceAll(spaces, '');
    }
    if (event is AutoSignIn) {
      final result = await signInAuto(NoParams());

      yield result.fold((failure) {
        return FailureAuthenticationState(failure.error);
      }, (user) {
        return Entered(user);
      });
    }
  }
}
