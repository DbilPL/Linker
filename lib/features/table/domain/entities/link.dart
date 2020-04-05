import 'package:equatable/equatable.dart';

class Link extends Equatable {
  final String title;
  final String link;
  final String type;

  Link({this.link, this.type, this.title});

  @override
  List<Object> get props => [link, type];

  static Link fromJson(Map<String, dynamic> json) {
    return Link(
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
