import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class GroupTableState extends Equatable {
  const GroupTableState();
}

class InitialGroupTableState extends GroupTableState {
  @override
  List<Object> get props => [];
}

class FailureGroupTableState extends GroupTableState {
  final String message;

  FailureGroupTableState(this.message);

  @override
  List<Object> get props => [message];
}

class LoadingGroupTableState extends GroupTableState {
  LoadingGroupTableState();

  @override
  List<Object> get props => [];
}

class SnapshotsLoaded extends GroupTableState {
  final Stream<DocumentSnapshot> stream;
  final String joiningLink;
  SnapshotsLoaded(this.stream, {this.joiningLink});

  @override
  List<Object> get props => [stream];
}
