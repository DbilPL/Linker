import 'package:linker/features/table/data/model/link_table_model.dart';
import 'package:linker/features/table/domain/entities/user_data.dart';

class UserDataModel extends UserData {
  final List<String> groupNameList;
  final String name;
  final UserLinkTableModel table;
  UserDataModel({this.table, this.groupNameList, this.name});

  static UserDataModel fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      name: json['name'],
      groupNameList: json['group_names'],
      table: UserLinkTableModel.fromJson(json['user_link_table']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'group_names': this.groupNameList,
      'user_link_table': this.table.toJson(),
    };
  }

  @override
  List<Object> get props => [groupNameList, links, name, types];
}
