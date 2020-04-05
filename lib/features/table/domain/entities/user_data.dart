import 'package:equatable/equatable.dart';
import 'package:linker/features/table/domain/entities/link.dart';
import 'package:linker/features/table/domain/entities/link_type.dart';

class UserData extends Equatable {
  final List<String> groupNameList;
  final List<Link> links;
  final String name;
  final List<LinkType> types;

  UserData({this.groupNameList, this.links, this.name, this.types});

  @override
  List<Object> get props => [groupNameList, links, name, types];
}
