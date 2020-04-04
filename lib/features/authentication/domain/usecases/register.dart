import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/core/usecases/usecase.dart';
import 'package:linker/features/authentication/domain/entities/user.dart';
import 'package:linker/features/authentication/domain/repositories/authentication_repository.dart';

class Register extends UseCase<User, AuthenticationParams> {
  final AuthenticationRepository repository;

  Register(this.repository);

  @override
  Future<Either<Failure, User>> call(AuthenticationParams params) async {
    return await repository.register(
        password: params.password, email: params.email, name: params.name);
  }
}

class AuthenticationParams {
  final String password, email, name;

  AuthenticationParams({
    @required this.password,
    @required this.email,
    this.name,
  });
}
