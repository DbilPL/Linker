import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String name, email, password, uid;

  User({this.name, this.email, this.password, this.uid});

  @override
  List<Object> get props => [name, email, password, uid];
}
