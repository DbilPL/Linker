import 'package:dartz/dartz.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/features/authentication/domain/entities/user.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, User>> register(
      {String email, String password, String name});

  Future<Either<Failure, User>> signIn({String email, String password});

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, User>> signInAuto();
}
