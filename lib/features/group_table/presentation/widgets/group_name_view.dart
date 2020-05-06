import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linker/features/group_table/presentation/bloc/bloc.dart';
import 'package:linker/features/group_table/presentation/pages/group_table_page.dart';

class GroupNameView extends StatefulWidget {
  final String groupName;
  final DocumentSnapshot snapshot;

  GroupNameView({Key key, this.groupName, this.snapshot}) : super(key: key);

  @override
  _GroupNameViewState createState() => _GroupNameViewState();
}

class _GroupNameViewState extends State<GroupNameView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<GroupTableBloc>(context).add(
          LoadGroupSnapshots(
            widget.groupName,
          ),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => GroupTablePage(
              snapshot: widget.snapshot,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Container(
          width: double.infinity,
          height: 50,
          color: Theme.of(context).primaryColor,
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Text(
              widget.groupName,
              style: Theme.of(context).textTheme.button.copyWith(
                    fontSize: 18,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
