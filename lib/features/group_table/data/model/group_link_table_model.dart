import 'package:linker/features/group_table/domain/entities/group_link_table.dart';
import 'package:linker/features/table/data/model/link_model.dart';
import 'package:linker/features/table/data/model/link_type_model.dart';

class GroupLinkTableModel extends GroupLinkTable {
  final List<LinkModel> links;
  final List<LinkTypeModel> types;
  final String creatorUid;
  final String tableName;
  final List<String> usersOfGroup;

  GroupLinkTableModel(
      {this.links,
      this.types,
      this.creatorUid,
      this.tableName,
      this.usersOfGroup});

  static GroupLinkTableModel fromJson(Map<String, dynamic> json) {
    return GroupLinkTableModel(
      creatorUid: json['creator_uid'],
      tableName: json['table_name'],
      usersOfGroup:
          json['users_of_group'].map<String>((v) => v.toString()).toList(),
      links:
          json['links'].map<LinkModel>((v) => LinkModel.fromJson(v)).toList(),
      types: json['types']
          .map<LinkTypeModel>((v) => LinkTypeModel.fromJson(v))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'links': this.links.map((val) => val.toJson()).toList(),
      'types': this.types.map((val) => val.toJson()).toList(),
      'creator_uid': this.creatorUid,
      'table_name': this.tableName,
      'users_of_group': this.usersOfGroup,
    };
  }

  @override
  List<Object> get props => [links, types, creatorUid, tableName];
}
