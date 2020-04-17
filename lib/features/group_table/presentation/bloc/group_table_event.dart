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
