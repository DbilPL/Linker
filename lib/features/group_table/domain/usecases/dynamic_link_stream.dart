import 'package:dartz/dartz.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/core/usecases/usecase.dart';
import 'package:linker/features/authentication/domain/usecases/sign_out.dart';
import 'package:linker/features/group_table/domain/repositories/group_table_repository.dart';

class DynamicLinkStream extends UseCase<Stream<Uri>, NoParams> {
  final GroupTableRepository repository;

  DynamicLinkStream(this.repository);

  @override
  Future<Either<Failure, Stream<Uri>>> call(NoParams params) async {
    return await repository.dynamicLinkStream();
  }
}
