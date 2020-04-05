import 'dart:ui';

import 'package:equatable/equatable.dart';

class LinkType extends Equatable {
  final String name;
  final Color color;
  final int importance;

  LinkType({this.name, this.color, this.importance});

  static LinkType fromJson(Map<String, dynamic> json) {
    return LinkType(
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
