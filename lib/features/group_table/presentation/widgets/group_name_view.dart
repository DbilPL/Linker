import 'package:flutter/material.dart';

class GroupNameView extends StatefulWidget {
  final String groupName;

  GroupNameView({Key key, this.groupName}) : super(key: key);

  @override
  _GroupNameViewState createState() => _GroupNameViewState();
}

class _GroupNameViewState extends State<GroupNameView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('load group data');
      },
      child: Container(
        width: double.infinity,
        height: 50,
        color: Theme.of(context).primaryColor,
        alignment: Alignment.centerLeft,
        child: Text(widget.groupName),
      ),
    );
  }
}
