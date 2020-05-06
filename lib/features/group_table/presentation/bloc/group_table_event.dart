import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:linker/features/group_table/data/model/group_link_table_model.dart';
import 'package:linker/features/table/data/model/link_model.dart';
import 'package:linker/features/table/data/model/link_type_model.dart';

abstract class GroupTableEvent extends Equatable {
  const GroupTableEvent();
}

class LoadGroupSnapshots extends GroupTableEvent {
  final String groupName;

  LoadGroupSnapshots(this.groupName);

  @override
  List<Object> get props => [groupName];
}

class AddNewGroup extends GroupTableEvent {
  final String groupName, uid, userName;

  AddNewGroup(this.groupName, this.uid, this.userName);

  @override
  List<Object> get props => [groupName, uid, userName];
}

class AddNewLinkTypeForGroupEvent extends GroupTableEvent {
  final LinkTypeModel type;
  final GroupLinkTableModel prevUserDataModel;
  final DocumentReference reference;

  AddNewLinkTypeForGroupEvent(
      this.type, this.prevUserDataModel, this.reference);

  @override
  List<Object> get props => [type, prevUserDataModel, reference];
}

class AddNewLinkToGroup extends GroupTableEvent {
  final LinkModel link;
  final GroupLinkTableModel prevUserDataModel;
  final DocumentReference reference;

  AddNewLinkToGroup(this.link, this.prevUserDataModel, this.reference);

  @override
  List<Object> get props => [link, prevUserDataModel, reference];
}

class DeleteLinkTypeGroup extends GroupTableEvent {
  final LinkTypeModel type;
  final GroupLinkTableModel prevUserData;
  final DocumentReference reference;

  DeleteLinkTypeGroup(this.type, this.prevUserData, this.reference);

  @override
  List<Object> get props => [type, prevUserData, reference];
}

class DeleteLinkGroup extends GroupTableEvent {
  final LinkModel link;
  final GroupLinkTableModel prevUserDataModel;
  final DocumentReference reference;

  DeleteLinkGroup(this.link, this.prevUserDataModel, this.reference);

  @override
  List<Object> get props => [link, prevUserDataModel, reference];
}
