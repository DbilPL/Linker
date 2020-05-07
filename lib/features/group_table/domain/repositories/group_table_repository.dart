import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/features/group_table/domain/entities/group_link_table.dart';

abstract class GroupTableRepository {
  Future<Either<Failure, Stream<DocumentSnapshot>>> getGroupTableStream(
      {String tableName});

  Future<Either<Failure, void>> updateGroupTableData(
      {DocumentReference reference, GroupLinkTable newGroupTable});

  Future<Either<Failure, String>> generateJoiningLink({String tableName});

  Future<Either<Failure, Stream<DocumentSnapshot>>> createNewGroup({
    String groupName,
    String uid,
    String userName,
  });

  Future<Either<Failure, Uri>> retrieveDynamicLink();

  Future<Either<Failure, void>> setOnLinkHandler(Function onSuccess);


}
