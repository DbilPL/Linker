import 'package:dartz/dartz.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/core/usecases/usecase.dart';
import 'package:linker/features/authentication/domain/entities/user.dart';
import 'package:linker/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:linker/features/authentication/domain/usecases/sign_out.dart';

class SignInAuto extends UseCase<User, NoParams> {
  final AuthenticationRepository repository;

  SignInAuto(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.signInAuto();
  }
}
