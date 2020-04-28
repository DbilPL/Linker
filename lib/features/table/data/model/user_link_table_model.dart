import 'package:equatable/equatable.dart';
import 'package:linker/features/table/data/model/link_model.dart';

import 'link_type_model.dart';

class UserLinkTableModel extends Equatable {
  final List<LinkModel> links;
  final List<LinkTypeModel> types;

  UserLinkTableModel({this.links, this.types});

  static UserLinkTableModel fromJson(Map<String, dynamic> json) {
    return json != null
        ? UserLinkTableModel(
            links: json['links']
                .map<LinkModel>((v) => LinkModel.fromJson(v))
                .toList(),
            types: json['types']
                .map<LinkTypeModel>((v) => LinkTypeModel.fromJson(v))
                .toList(),
          )
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'links': this.links.map((val) => val.toJson()).toList(),
      'types': this.types.map((val) => val.toJson()).toList(),
    };
  }

  @override
  List<Object> get props => [links, types];
}
