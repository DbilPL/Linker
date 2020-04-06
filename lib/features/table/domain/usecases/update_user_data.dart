import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/core/usecases/usecase.dart';
import 'package:linker/features/table/domain/repositories/user_table_repository.dart';

class UpdateUserData
    extends UseCase<Stream<DocumentSnapshot>, DocumentReference> {
  final UserTableRepository repository;

  UpdateUserData(this.repository);

  @override
  Future<Either<Failure, Stream<DocumentSnapshot>>> call(
      DocumentReference params) async {
    return await repository.updateUserData(reference: params);
  }
}
