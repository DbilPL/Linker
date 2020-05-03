import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:linker/features/table/data/model/link_model.dart';
import 'package:linker/features/table/data/model/link_type_model.dart';
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

class AddNewLinkTypeEvent extends UserTableEvent {
  final LinkTypeModel type;
  final UserDataModel prevUserDataModel;
  final DocumentReference reference;

  AddNewLinkTypeEvent(this.type, this.prevUserDataModel, this.reference);

  @override
  List<Object> get props => [type, prevUserDataModel, reference];
}

class AddNewLinkEvent extends UserTableEvent {
  final LinkModel link;
  final UserDataModel prevUserDataModel;
  final DocumentReference reference;

  AddNewLinkEvent(this.link, this.prevUserDataModel, this.reference);

  @override
  List<Object> get props => [link, prevUserDataModel, reference];
}

class UpdateUserDataEvent extends UserTableEvent {
  final UserDataModel userDataModel;
  final DocumentReference reference;

  UpdateUserDataEvent(this.userDataModel, this.reference);

  @override
  List<Object> get props => [userDataModel, reference];
}
