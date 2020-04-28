import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class UserTableState extends Equatable {
  final Stream<DocumentSnapshot> stream;

  const UserTableState(this.stream);
}

class InitialUserTableState extends UserTableState {
  InitialUserTableState() : super(null);

  @override
  List<Object> get props => [];
}

class UserDataLoaded extends UserTableState {
  final Stream<DocumentSnapshot> stream;

  UserDataLoaded(this.stream) : super(stream);

  @override
  List<Object> get props => [stream];
}

class FailureUserTableState extends UserTableState {
  final String message;
  final Stream<DocumentSnapshot> prevStream;

  FailureUserTableState(this.message, this.prevStream) : super(prevStream);

  @override
  List<Object> get props => [message];
}

class LoadingUserTableState extends UserTableState {
  LoadingUserTableState(Stream<DocumentSnapshot> stream) : super(stream);

  @override
  List<Object> get props => [];
}
