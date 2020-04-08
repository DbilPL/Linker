import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/core/usecases/usecase.dart';
import 'package:linker/features/group_table/domain/repositories/group_table_repository.dart';

class CreateNewGroup
    extends UseCase<Stream<DocumentSnapshot>, CreateNewGroupParams> {
  final GroupTableRepository repository;

  CreateNewGroup(this.repository);

  @override
  Future<Either<Failure, Stream<DocumentSnapshot>>> call(
      CreateNewGroupParams params) async {
    return await repository.createNewGroup(
        userName: params.userName,
        groupName: params.groupName,
        uid: params.uid);
  }
}

class CreateNewGroupParams {
  final String uid, userName, groupName;

  CreateNewGroupParams({this.uid, this.userName, this.groupName});
}
