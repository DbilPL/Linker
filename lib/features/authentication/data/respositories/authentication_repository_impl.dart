import 'package:dartz/dartz.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:linker/core/errors/exceptions.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/features/authentication/data/datasources/authentication_data_source.dart';
import 'package:linker/features/authentication/domain/entities/user.dart';
import 'package:linker/features/authentication/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final AuthenticationDataSource dataSource;

  final DataConnectionChecker connectionChecker;

  AuthenticationRepositoryImpl({this.dataSource, this.connectionChecker});

  @override
  Future<Either<Failure, User>> register(
      {String email, String password, String name}) async {
    if (await connectionChecker.hasConnection) {
      try {
        final user = await dataSource.register(
            email: email, name: name, password: password);
        return Right(user);
      } catch (e) {
        return Left(FirebaseFailure());
      }
    } else
      return Left(ConnectionFailure());
  }

  @override
  Future<Either<Failure, User>> signIn({String email, String password}) async {
    if (await connectionChecker.hasConnection) {
      try {
        final user = await dataSource.signIn(email: email, password: password);
        return Right(user);
      } catch (e) {
        return Left(FirebaseFailure());
      }
    } else
      return Left(ConnectionFailure());
  }

  @override
  Future<Either<Failure, User>> signInAuto() async {
    if (await connectionChecker.hasConnection) {
      try {
        final user = await dataSource.signInAuto();
        return Right(user);
      } catch (e) {
        if (e is CacheException)
          return Left(CacheFailure());
        else if (e is ConnectionException)
          return Left(ConnectionFailure());
        else
          return Left(ConnectionFailure());
      }
    } else
      return Left(ConnectionFailure());
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    if (await connectionChecker.hasConnection) {
      try {
        final success = await dataSource.signOut();
        return Right(success);
      } catch (e) {
        return Left(FirebaseFailure());
      }
    } else
      return Left(ConnectionFailure());
  }
}
