import 'package:dartz/dartz.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/core/usecases/usecase.dart';
import 'package:linker/features/authentication/domain/entities/user.dart';
import 'package:linker/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:linker/features/authentication/domain/usecases/register.dart';

class SignIn extends UseCase<User, AuthenticationParams> {
  final AuthenticationRepository repository;

  SignIn(this.repository);

  @override
  Future<Either<Failure, User>> call(AuthenticationParams params) async {
    return await repository.signIn(
      password: params.password,
      email: params.email,
    );
  }
}
