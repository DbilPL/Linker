import 'package:dartz/dartz.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/core/usecases/usecase.dart';
import 'package:linker/features/authentication/domain/repositories/authentication_repository.dart';

class SignOut extends UseCase<void, NoParams> {
  final AuthenticationRepository repository;

  SignOut(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.signOut();
  }
}

class NoParams {}
