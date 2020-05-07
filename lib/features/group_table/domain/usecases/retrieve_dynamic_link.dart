import 'package:dartz/dartz.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/core/usecases/usecase.dart';
import 'package:linker/features/group_table/domain/repositories/group_table_repository.dart';

class RetrieveDynamicLink extends UseCase<Uri, Function> {
  final GroupTableRepository repository;

  RetrieveDynamicLink(this.repository);

  @override
  Future<Either<Failure, Uri>> call(Function onSuccess) async {
    return await repository.retrieveDynamicLink(onSuccess);
  }
}
