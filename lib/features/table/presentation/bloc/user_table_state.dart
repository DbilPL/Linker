import 'package:equatable/equatable.dart';
import 'package:linker/features/table/data/model/user_data_model.dart';

abstract class UserTableState extends Equatable {
  const UserTableState();
}

class InitialUserTableState extends UserTableState {
  @override
  List<Object> get props => [];
}

class DataLoaded extends UserTableState {
  final UserDataModel data;

  DataLoaded(this.data);

  @override
  List<Object> get props => null;
}
