import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:linker/features/authentication/domain/usecases/register.dart';
import 'package:linker/features/authentication/domain/usecases/sign_in.dart';
import 'package:linker/features/authentication/domain/usecases/sign_in_auto.dart';
import 'package:linker/features/authentication/domain/usecases/sign_out.dart';

import './bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final Register _register;

  final SignIn _signIn;

  final SignInAuto _signInAuto;

  final SignOut _signOut;

  AuthenticationBloc(
      this._register, this._signInAuto, this._signIn, this._signOut);

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

      final result = await _signIn(
        AuthenticationParams(
          password: password,
          email: email,
        ),
      );

      yield result.fold((failure) {
        return FailureAuthenticationState(failure.error);
      }, (success) {
        return Entered(success);
      });
    }
    if (event is RegisterEvent) {
      final name = event.name.replaceAll(spaces, '');
      final email = event.email.replaceAll(spaces, '');
      final password = event.password.replaceAll(spaces, '');

      if (emailRegExp.hasMatch(email)) {
        if (password.length > 6) {
          final result = await _register(
            AuthenticationParams(password: password, email: email, name: name),
          );

          yield result.fold((failure) {
            return FailureAuthenticationState(failure.error);
          }, (success) {
            return Entered(success);
          });
        } else
          yield FailureAuthenticationState(
              'Password is too small! (more than 6 chars)');
      } else
        yield FailureAuthenticationState('Email isn\'t valid!');
    }
    if (event is AutoSignIn) {
      final result = await _signInAuto(NoParams());

      yield result.fold((failure) {
        return FailureAuthenticationState(failure.error);
      }, (user) {
        return Entered(user);
      });
    }
    if (event is SignOutEvent) {
      final result = await _signOut(NoParams());

      yield result.fold((failure) {
        return Entered(event.prevUser, msg: failure.error);
      }, (user) {
        return SignedOut();
      });
    }
  }
}
