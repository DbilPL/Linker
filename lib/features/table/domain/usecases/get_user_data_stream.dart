import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/core/usecases/usecase.dart';
import 'package:linker/features/table/domain/repositories/user_table_repository.dart';

class GetUserDataStream extends UseCase<Stream<DocumentSnapshot>, String> {
  final UserTableRepository repository;

  GetUserDataStream(this.repository);

  @override
  Future<Either<Failure, Stream<DocumentSnapshot>>> call(String params) async {
    return await repository.getUserDataStream(uid: params);
  }
}
