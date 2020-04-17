import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/core/presentation/bloc/bloc.dart';
import 'package:linker/features/authentication/domain/entities/user.dart';
import 'package:linker/features/authentication/domain/usecases/register.dart';

import './bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(this.register);

  @override
  AuthenticationState get initialState => InitialAuthenticationState();

  final Register register;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is RegisterEvent) {
      final result = await register(AuthenticationParams(
          password: event.password, email: event.email, name: event.name));
      yield result.fold((failure) {}, (success) {
        return AuthenticationSuccessState(uid: success.uid);
      });
    }
  }
}
