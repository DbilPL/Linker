import 'package:dartz/dartz.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/core/usecases/usecase.dart';
import 'package:linker/features/group_table/domain/repositories/group_table_repository.dart';

class GenerateJoiningLink extends UseCase<String, String> {
  final GroupTableRepository repository;

  GenerateJoiningLink(this.repository);

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await repository.generateJoiningLink(tableName: params);
  }
}
