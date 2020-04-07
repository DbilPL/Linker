import 'package:equatable/equatable.dart';
import 'package:linker/features/table/domain/entities/link.dart';
import 'package:linker/features/table/domain/entities/link_type.dart';

class GroupLinkTable extends Equatable {
  final List<Link> links;
  final List<LinkType> types;
  final String creatorUid;
  final String tableName;

  GroupLinkTable({this.links, this.types, this.creatorUid, this.tableName});

  @override
  List<Object> get props => [links, types, creatorUid, tableName];
}