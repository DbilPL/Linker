import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String error;

  Failure({this.error});

  @override
  List<Object> get props => [error];
}

class FirebaseFailure extends Failure {
  FirebaseFailure();

  @override
  List<Object> get props => [];
}

class ConnectionFailure extends Failure {
  ConnectionFailure();

  @override
  List<Object> get props => [];
}

class CacheFailure extends Failure {
  CacheFailure();

  @override
  List<Object> get props => [];
}
