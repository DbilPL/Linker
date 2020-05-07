import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linker/features/group_table/presentation/bloc/bloc.dart';
import 'package:linker/features/group_table/presentation/pages/group_table_page.dart';
import 'package:linker/features/table/data/model/user_data_model.dart';
import 'package:linker/features/table/presentation/bloc/user_table_bloc.dart';
import 'package:linker/features/table/presentation/bloc/user_table_event.dart';

class AddGroup extends StatefulWidget {
  final DocumentSnapshot snapshot;
  final String uid;

  const AddGroup({Key key, this.snapshot, this.uid}) : super(key: key);

  @override
  _AddGroupState createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  TextEditingController _nameController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocListener<GroupTableBloc, GroupTableState>(
          listener: (context, state) {
            if (state is SnapshotsLoaded) {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => GroupTablePage(
                    snapshot: widget.snapshot,
                  ),
                ),
              );
            }
            if (state is FailureGroupTableState) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).errorColor,
                ),
              );
            }
          },
          child: BlocBuilder<GroupTableBloc, GroupTableState>(
            builder: (context, state) {
              return Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  state is LoadingGroupTableState
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        )
                      : RaisedButton(
                          onPressed: () {
                            final prevUserDataModel =
                                UserDataModel.fromJson(widget.snapshot.data);

                            BlocProvider.of<GroupTableBloc>(context).add(
                              AddNewGroup(
                                _nameController.text,
                                widget.uid,
                                prevUserDataModel.name,
                              ),
                            );

                            BlocProvider.of<UserTableBloc>(context).add(
                              AddNewGroupToUserData(
                                _nameController.text,
                                prevUserDataModel,
                                widget.snapshot.reference,
                              ),
                            );
                          },
                          child: Text(
                            'Add',
                            style: Theme.of(context).textTheme.button,
                          ),
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
