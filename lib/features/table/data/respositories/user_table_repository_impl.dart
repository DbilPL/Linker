import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/features/table/data/datasources/user_data_data_source.dart';
import 'package:linker/features/table/data/model/user_data_model.dart';
import 'package:linker/features/table/domain/repositories/user_table_repository.dart';

class UserTableRepositoryImpl extends UserTableRepository {
  final UserTableDataSource dataSource;

  final DataConnectionChecker connectionChecker;

  UserTableRepositoryImpl(this.dataSource, this.connectionChecker);

  @override
  Future<Either<Failure, Stream<DocumentSnapshot>>> getUserDataStream(
      {String uid}) async {
    if (await connectionChecker.hasConnection) {
      try {
        final stream = await dataSource.getUserDataStream(uid: uid);

        return Right(stream);
      } catch (e) {
        return Left(FirebaseFailure());
      }
    } else
      return Left(ConnectionFailure());
  }

  @override
  Future<Either<Failure, void>> updateUserData(
      {DocumentReference reference, UserDataModel newUserData}) async {
    if (await connectionChecker.hasConnection) {
      try {
        final update = await dataSource.updateUserData(
            reference: reference, newUserData: newUserData);

        return Right(update);
      } catch (e) {
        return Left(FirebaseFailure());
      }
    } else
      return Left(ConnectionFailure());
  }
}
