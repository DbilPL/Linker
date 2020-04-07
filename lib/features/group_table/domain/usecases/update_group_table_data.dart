import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:linker/core/errors/failure.dart';
import 'package:linker/core/usecases/usecase.dart';
import 'package:linker/features/group_table/domain/entities/group_link_table.dart';
import 'package:linker/features/group_table/domain/repositories/group_table_repository.dart';

class UpdateGroupTableData extends UseCase<void, UpdateGroupTableDataParams> {
  final GroupTableRepository repository;

  UpdateGroupTableData(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateGroupTableDataParams params) async {
    return await repository.updateGroupTableData(
        reference: params.reference, newGroupTable: params.newTable);
  }
}

class UpdateGroupTableDataParams {
  final DocumentReference reference;
  final GroupLinkTable newTable;

  UpdateGroupTableDataParams(this.reference, this.newTable);
}
