import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class UserTableState extends Equatable {
  const UserTableState();
}

class InitialUserTableState extends UserTableState {
  @override
  List<Object> get props => [];
}

class UserDataLoaded extends UserTableState {
  final Stream<DocumentSnapshot> stream;

  UserDataLoaded(this.stream);

  @override
  List<Object> get props => [stream];
}

class FailureUserTableState extends UserTableState {
  final String message;

  FailureUserTableState(this.message);

  @override
  List<Object> get props => [message];
}

class LoadingUserTableState extends UserTableState {
  @override
  List<Object> get props => [];
}
