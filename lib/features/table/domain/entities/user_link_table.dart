import 'package:equatable/equatable.dart';
import 'package:linker/features/table/domain/entities/link.dart';
import 'package:linker/features/table/domain/entities/link_type.dart';

class UserLinkTable extends Equatable {
  final List<Link> links;
  final List<LinkType> types;

  UserLinkTable({this.links, this.types});

  static UserLinkTable fromJson(Map<String, dynamic> json) {
    return UserLinkTable(
      links: json['links'].map((v) => Link.fromJson(v)).toList(),
      types: json['types'].map((v) => LinkType.fromJson(v)).toList(),
    );
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
