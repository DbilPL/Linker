import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linker/features/group_table/data/model/group_link_table_model.dart';
import 'package:linker/features/group_table/presentation/bloc/bloc.dart';
import 'package:linker/features/table/data/model/link_model.dart';
import 'package:linker/features/table/data/model/link_type_model.dart';

class AddLinkToGroupPage extends StatefulWidget {
  final DocumentSnapshot snapshot;
  final LinkTypeModel type;

  const AddLinkToGroupPage({Key key, this.snapshot, this.type})
      : super(key: key);

  @override
  _AddLinkToGroupPageState createState() => _AddLinkToGroupPageState();
}

class _AddLinkToGroupPageState extends State<AddLinkToGroupPage> {
  TextEditingController _titleController = TextEditingController(text: '');
  TextEditingController _linkController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '"${widget.type.name}" link',
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocListener<GroupTableBloc, GroupTableState>(
          listener: (context, state) {
            if (state is SnapshotsLoaded) {
              Navigator.pop(context);
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
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                    ),
                  ),
                  TextFormField(
                    controller: _linkController,
                    decoration: InputDecoration(
                      labelText: 'Link',
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
                            final prevGroupDataModel =
                                GroupLinkTableModel.fromJson(
                                    widget.snapshot.data);

                            final link = LinkModel(
                              type: widget.type.name,
                              title: _titleController.text,
                              link: _linkController.text,
                            );

                            BlocProvider.of<GroupTableBloc>(context).add(
                              AddNewLinkToGroup(
                                link,
                                prevGroupDataModel,
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
