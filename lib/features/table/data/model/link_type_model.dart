import 'dart:ui';

import 'package:linker/features/table/domain/entities/link_type.dart';

class LinkTypeModel extends LinkType {
  final String name;
  final Color color;
  final int importance;

  LinkTypeModel({this.name, this.color, this.importance});

  static LinkTypeModel fromJson(Map<String, dynamic> json) {
    return LinkTypeModel(
      name: json['name'],
      color: Color.fromRGBO(
        json['color'][0] as int,
        json['color'][1] as int,
        json['color'][2] as int,
        1,
      ),
      importance: json['importance'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'importance': this.importance,
      'color': [
        this.color.red,
        this.color.green,
        this.color.blue,
      ],
    };
  }

  @override
  List<Object> get props => [name, color, importance];
}
