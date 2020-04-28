import 'package:equatable/equatable.dart';
import 'package:linker/features/table/data/model/user_data_model.dart';

abstract class UserTableEvent extends Equatable {
  const UserTableEvent();
}

class LoadUserDataInitial extends UserTableEvent {
  final String uid;

  LoadUserDataInitial(this.uid);

  @override
  List<Object> get props => [uid];
}

class UpdateUserData extends UserTableEvent {
  final String uid;
  final UserDataModel userDataModel;

  UpdateUserData(this.uid, this.userDataModel);

  @override
  List<Object> get props => [uid, userDataModel];
}
