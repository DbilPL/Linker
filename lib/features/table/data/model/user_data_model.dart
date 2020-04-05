import 'package:linker/features/table/domain/entities/user_data.dart';

import '../../domain/entities/link.dart';
import '../../domain/entities/link_type.dart';

class UserDataModel extends UserData {
  final List<String> groupNameList;
  final List<Link> links;
  final String name;
  final List<LinkType> types;

  UserDataModel({this.groupNameList, this.links, this.name, this.types});

  static UserDataModel fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      name: json['name'],
      groupNameList: json['group_names'],
      links: json['links'].map<Link>((v) {
        return Link.fromJson(v);
      }).toList(),
      types: json['types'].map<LinkType>((v) {
        return LinkType.fromJson(v);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'group_names': this.groupNameList,
      'links': this.links.map((val) => val.toJson()).toList(),
      'types': this.types.map((val) => val.toJson()).toList(),
    };
  }

  @override
  List<Object> get props => [groupNameList, links, name, types];
}
