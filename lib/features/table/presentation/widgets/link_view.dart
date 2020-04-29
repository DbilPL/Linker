import 'package:flutter/material.dart';
import 'package:linker/features/table/data/model/link_model.dart';

class LinkView extends StatefulWidget {
  final LinkModel link;

  LinkView({Key key, this.link}) : super(key: key);

  @override
  _LinkViewState createState() => _LinkViewState();
}

class _LinkViewState extends State<LinkView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
