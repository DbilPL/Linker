import 'package:cloud_firestore/cloud_firestore.dart';
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

class UpdateUserDataEvent extends UserTableEvent {
  final UserDataModel userDataModel;
  final DocumentReference reference;
  final Stream<DocumentSnapshot> prevStream;

  UpdateUserDataEvent(this.userDataModel, this.reference, this.prevStream);

  @override
  List<Object> get props => [userDataModel, reference, prevStream];
}
