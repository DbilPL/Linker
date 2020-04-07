import 'package:linker/features/table/domain/entities/link.dart';

class LinkModel extends Link {
  final String title;
  final String link;
  final String type;

  LinkModel({this.link, this.type, this.title});

  @override
  List<Object> get props => [link, type];

  static LinkModel fromJson(Map<String, dynamic> json) {
    return LinkModel(
      link: json['link'],
      type: json['type'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'link': this.link,
      'type': this.type,
      'title': this.title,
    };
  }
}
