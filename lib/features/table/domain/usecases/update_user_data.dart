import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/core/usecases/usecase.dart';
import 'package:linker/features/table/data/model/user_data_model.dart';
import 'package:linker/features/table/domain/repositories/user_table_repository.dart';

class UpdateUserData extends UseCase<void, UpdateUserDataParams> {
  final UserTableRepository repository;

  UpdateUserData(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateUserDataParams params) async {
    return await repository.updateUserData(
      reference: params.reference,
      newUserData: params.newUserData,
    );
  }
}

class UpdateUserDataParams {
  final DocumentReference reference;
  final UserDataModel newUserData;

  UpdateUserDataParams({this.reference, this.newUserData});
}
