import 'package:linker/features/group_table/domain/entities/group_link_table.dart';
import 'package:linker/features/table/data/model/link_model.dart';
import 'package:linker/features/table/data/model/link_type_model.dart';

class GroupLinkTableModel extends GroupLinkTable {
  final List<LinkModel> links;
  final List<LinkTypeModel> types;
  final String creatorUid;
  final String tableName;

  GroupLinkTableModel(
      {this.links, this.types, this.creatorUid, this.tableName});

  static GroupLinkTableModel fromJson(Map<String, dynamic> json) {
    return GroupLinkTableModel(
      creatorUid: json['creator_uid'],
      tableName: json['table_name'],
      links: json['links'].map((v) => LinkModel.fromJson(v)).toList(),
      types: json['types'].map((v) => LinkTypeModel.fromJson(v)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'links': this.links.map((val) => val.toJson()).toList(),
      'types': this.types.map((val) => val.toJson()).toList(),
      'creator_uid': this.creatorUid,
      'table_name': this.tableName,
    };
  }

  @override
  List<Object> get props => [links, types, creatorUid, tableName];
}
