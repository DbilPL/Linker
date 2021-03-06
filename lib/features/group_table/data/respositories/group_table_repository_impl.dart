import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/features/group_table/data/datasources/group_table_data_source.dart';
import 'package:linker/features/group_table/domain/entities/group_link_table.dart';
import 'package:linker/features/group_table/domain/repositories/group_table_repository.dart';

class GroupTableRepositoryImpl extends GroupTableRepository {
  final GroupTableDataSource dataSource;
  final DataConnectionChecker connectionChecker;

  GroupTableRepositoryImpl(this.dataSource, this.connectionChecker);

  @override
  Future<Either<Failure, String>> generateJoiningLink(
      {String tableName}) async {
    try {
      if (await connectionChecker.hasConnection) {
        final link = await dataSource.generateJoiningLink(tableName: tableName);

        return Right(link);
      } else
        return Left(ConnectionFailure());
    } catch (e) {
      return Left(FirebaseFailure());
    }
  }

  @override
  Future<Either<Failure, Stream<DocumentSnapshot>>> getGroupTableStream(
      {String tableName}) async {
    try {
      if (await connectionChecker.hasConnection) {
        final stream =
            await dataSource.getGroupTableStream(tableName: tableName);

        return Right(stream);
      } else
        return Left(Failure(error: 'Has no connection to internet!'));
    } catch (e) {
      return Left(Failure(error: 'Something went wrong!'));
    }
  }

  @override
  Future<Either<Failure, void>> updateGroupTableData(
      {DocumentReference reference, GroupLinkTable newGroupTable}) async {
    try {
      if (await connectionChecker.hasConnection) {
        final success = await dataSource.updateGroupTableData(
            reference: reference, newGroupTable: newGroupTable);

        return Right(success);
      } else
        return Left(Failure(error: 'Has no connection to internet!'));
    } catch (e) {
      return Left(Failure(error: 'Something went wrong!'));
    }
  }

  @override
  Future<Either<Failure, Stream<DocumentSnapshot>>> createNewGroup(
      {String groupName, String uid, String userName}) async {
    try {
      if (await connectionChecker.hasConnection) {
        final stream = await dataSource.createNewGroup(
            uid: uid, groupName: groupName, userName: userName);

        return Right(stream);
      } else
        return Left(Failure(error: 'Has no connection to internet!'));
    } catch (e) {
      return Left(Failure(error: 'Something went wrong!'));
    }
  }

  @override
  Future<Either<Failure, Uri>> retrieveDynamicLink() async {
    try {
      if (await connectionChecker.hasConnection) {
        final link = await dataSource.retrieveDynamicLink();

        return Right(link);
      } else
        return Left(Failure(error: 'Has no connection to internet!'));
    } catch (e) {
      return Left(Failure(error: 'Something went wrong!'));
    }
  }

  Future<Either<Failure, void>> setOnLinkHandler(Function onSuccess) async {

    try {
      if (await connectionChecker.hasConnection) {
        final success = await dataSource.setOnLinkHandler(onSuccess);

        return Right(success);
      } else
        return Left(Failure(error: 'Has no connection to internet!'));
    } catch (e) {
      return Left(Failure(error: 'Something went wrong!'));
    }

  }
}
