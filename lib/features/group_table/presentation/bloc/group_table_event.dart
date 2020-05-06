import 'package:equatable/equatable.dart';

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
