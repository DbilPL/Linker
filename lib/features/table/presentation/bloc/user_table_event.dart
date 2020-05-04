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

class DeleteLinkType extends UserTableEvent {
  final LinkTypeModel type;
  final UserDataModel prevUserData;
  final DocumentReference reference;

  DeleteLinkType(this.type, this.prevUserData, this.reference);

  @override
  List<Object> get props => [type, prevUserData, reference];
}

class AddNewLink extends UserTableEvent {
  final LinkModel link;
  final UserDataModel prevUserDataModel;
  final DocumentReference reference;

  AddNewLink(this.link, this.prevUserDataModel, this.reference);

  @override
  List<Object> get props => [link, prevUserDataModel, reference];
}

class DeleteLink extends UserTableEvent {
  final LinkModel link;
  final UserDataModel prevUserDataModel;
  final DocumentReference reference;

  DeleteLink(this.link, this.prevUserDataModel, this.reference);

  @override
  List<Object> get props => [link, prevUserDataModel, reference];
}
