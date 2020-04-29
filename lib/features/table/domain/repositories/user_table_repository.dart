import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/features/table/data/model/user_data_model.dart';

abstract class UserTableRepository {
  Future<Either<Failure, Stream<DocumentSnapshot>>> getUserDataStream(
      {String uid});

  Future<Either<Failure, void>> updateUserData(
      {DocumentReference reference, UserDataModel newUserData});
}
