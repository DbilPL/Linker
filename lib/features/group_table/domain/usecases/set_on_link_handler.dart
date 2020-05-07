import 'package:dartz/dartz.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/core/usecases/usecase.dart';
import 'package:linker/features/group_table/domain/repositories/group_table_repository.dart';

class SetOnLinkHandler extends UseCase<void, Function> {
  final GroupTableRepository repository;

  SetOnLinkHandler(this.repository);

  @override
  Future<Either<Failure, void>> call(Function params) async {
    return await repository.setOnLinkHandler(params);
  }
}
