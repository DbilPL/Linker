import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/core/usecases/usecase.dart';
import 'package:linker/features/group_table/domain/repositories/group_table_repository.dart';

class GetGroupTableStream extends UseCase<Stream<DocumentSnapshot>, String> {
  final GroupTableRepository repository;

  GetGroupTableStream(this.repository);

  @override
  Future<Either<Failure, Stream<DocumentSnapshot>>> call(String params) async {
    return await repository.getGroupTableStream(tableName: params);
  }
}
