import 'package:equatable/equatable.dart';

class UserData extends Equatable {
  final List<String> groupNameList;
  final String name;

  UserData({this.groupNameList, this.name});

  @override
  List<Object> get props => [groupNameList, name];
}
