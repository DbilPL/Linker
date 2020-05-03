import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linker/features/table/data/model/link_model.dart';
import 'package:linker/features/table/data/model/link_type_model.dart';
import 'package:linker/features/table/data/model/user_data_model.dart';
import 'package:linker/features/table/presentation/bloc/bloc.dart';

class AddLinkPage extends StatefulWidget {
  final DocumentSnapshot snapshot;
  final LinkTypeModel type;

  const AddLinkPage({Key key, this.snapshot, this.type}) : super(key: key);

  @override
  _AddLinkPageState createState() => _AddLinkPageState();
}

class _AddLinkPageState extends State<AddLinkPage> {
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
        child: BlocListener<UserTableBloc, UserTableState>(
          listener: (context, state) {
            if (state is UserDataLoaded) {
              Navigator.pop(context);
            }
            if (state is FailureUserTableState) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).errorColor,
                ),
              );
            }
          },
          child: BlocBuilder<UserTableBloc, UserTableState>(
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
                  state is LoadingUserTableState
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        )
                      : RaisedButton(
                          onPressed: () {
                            final prevUserDataModel =
                                UserDataModel.fromJson(widget.snapshot.data);

                            final link = LinkModel(
                              type: widget.type.name,
                              title: _titleController.text,
                              link: _linkController.text,
                            );

                            BlocProvider.of<UserTableBloc>(context).add(
                              AddNewLinkEvent(
                                link,
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
