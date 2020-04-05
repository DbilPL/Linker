import 'package:flutter/cupertino.dart';
import 'package:linker/features/authentication/domain/entities/user.dart';

class UserModel extends User {
  final String email, password, uid;

  UserModel({
    @required this.email,
    @required this.password,
    this.uid,
  });

  @override
  List<Object> get props => [name, email, password, uid];

  Map<String, dynamic> toJson() {
    return {
      'password': this.password,
      'email': this.email,
    };
  }

  static UserModel fromJson({Map<String, dynamic> json}) {
    return UserModel(
      password: json['password'],
      email: json['email'],
    );
  }
}
